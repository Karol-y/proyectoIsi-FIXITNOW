<?php
$hostname = 'localhost'; // Cambia esto si es necesario
$dbname = 'serviciosgeneralesbd'; // Nombre de tu base de datos
$username = 'root'; // Tu usuario de base de datos
$pass = '123456'; // Tu contraseña de base de datos

    try {
        $pdo = new PDO("mysql:host=$hostname;dbname=$dbname", $username, $pass);
        $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

        // Función para verificar usuario y contraseña
        function verificarUsuario($pdo, $usuario, $contrasena) {
            $stmt = $pdo->prepare("SELECT contrasena, tipo FROM usuarios WHERE usuario = :usuario");
            $stmt->bindValue(':usuario', $usuario);
            $stmt->execute();
            $user = $stmt->fetch(PDO::FETCH_ASSOC);

            if ($user && password_verify($contrasena, $user['contrasena'])) {
                return ['success' => true, 'tipo' => $user['tipo']];
            } else {
                return ['success' => false];
            }
        }

        //funcion para obtener los datos de los trabajadores, dependiendo del tipo de trabajo
        function obtenerTrabajadores($pdo, $tipSer = null) {
            if ($tipSer) {
                // Consulta para un tipo de servicio específico
                $stmt = $pdo->prepare("SELECT foto, nombres, apellidos, tipSer, telefono, email, descripcion FROM trabajadores WHERE tipSer = :tipSer");
                $stmt->bindValue(':tipSer', $tipSer);
            } else {
                // Consulta para todos los trabajadores
                $stmt = $pdo->prepare("SELECT foto, nombres, apellidos, tipSer, telefono, email, descripcion FROM trabajadores");
            }
            $stmt->execute();
            $trabajadores = $stmt->fetchAll(PDO::FETCH_ASSOC);
        
            if ($trabajadores) {
                return ['success' => true, 'data' => $trabajadores];
            } else {
                return ['success' => false];
            }
        }

        // Función para obtener la información del trabajador que inicia sesión
        function informacionTrabajador($pdo, $usuario, $contrasena) {
            // Consulta para obtener el id_usuario de la tabla usuarios usando el usuario y la contraseña
            $stmt = $pdo->prepare("SELECT id_usuario FROM usuarios WHERE usuario = :usuario AND contrasena = :contrasena");
            $stmt->bindParam(':usuario', $usuario, PDO::PARAM_STR);
            $stmt->bindParam(':contrasena', $contrasena, PDO::PARAM_STR);
            $stmt->execute();

            // Verificar si se encontró un usuario válido
            if ($stmt->rowCount() > 0) {
                // Obtener el id_usuario de la tabla usuarios
                $usuarioData = $stmt->fetch(PDO::FETCH_ASSOC);
                $id_usuario = $usuarioData['id_usuario'];

                // Ahora, usar el id_usuario para obtener la información del trabajador desde la tabla trabajadores
                $stmtTrabajador = $pdo->prepare("SELECT foto, nombres, apellidos, tipSer FROM trabajadores WHERE id_usuario = :id_usuario");
                $stmtTrabajador->bindParam(':id_usuario', $id_usuario, PDO::PARAM_INT);
                $stmtTrabajador->execute();

                // Verificar si se encontró al trabajador
                if ($stmtTrabajador->rowCount() > 0) {
                    // Obtener los datos del trabajador
                    $trabajadorData = $stmtTrabajador->fetch(PDO::FETCH_ASSOC);
                    return [
                        'success' => true,
                        'data' => [
                            'foto' => $trabajadorData['foto'],
                            'nombres' => $trabajadorData['nombres'],
                            'apellidos' => $trabajadorData['apellidos'],
                            'tipo_servicio' => $trabajadorData['tipSer'],
                        ]
                    ];
                } else {
                    return [
                        'success' => false,
                        'message' => 'No se encontró el trabajador.'
                    ];
                }
            } else {
                return [
                    'success' => false,
                    'message' => 'Usuario o contraseña incorrectos.'
                ];
            }
        }

        /*funcion para obtener los tipos de servicios disponibles
        function obtenerServicios($pdo){
            try {
                // Consulta para obtener los tipos de servicio únicos
                $query = "SELECT DISTINCT tipSer AS tipoServicio FROM trabajadores";
                $stmt = $pdo->prepare($query);
                $stmt->execute();
        
                // Obtener los resultados como un arreglo
                $result = $stmt->fetchAll(PDO::FETCH_ASSOC);
        
                return $result;
            } catch (PDOException $e) {
                // Manejo de errores
                return ['error' => 'Error al obtener los tipos de servicios: ' . $e->getMessage()];
            }
        }*/

        function messages($action, $data) { 
            global $pdo; 

            if ($action == 'sendMessage') { 
                $sender_id = $data['sender_id']; 
                $receiver_id = $data['receiver_id']; 
                $message = $data['message']; $stmt = 
                
                $pdo->prepare("INSERT INTO mensajes (sender_id, receiver_id, message) VALUES (:sender_id, :receiver_id, :message)"); 
                $stmt->bindParam(':sender_id', $sender_id); $stmt->bindParam(':receiver_id', $receiver_id); 
                $stmt->bindParam(':message', $message); $stmt->execute(); 
                
                return json_encode(['status' => 'Message sent']); 
            } 
            
            if ($action == 'getMessages') { 
                $user1_id = $data['user1_id']; 
                $user2_id = $data['user2_id']; 
                $stmt = $pdo->prepare("SELECT * FROM mensajes WHERE (sender_id = :user1_id AND receiver_id = :user2_id) OR (sender_id = :user2_id AND receiver_id = :user1_id) ORDER BY timestamp ASC"); 
                $stmt->bindParam(':user1_id', $user1_id); $stmt->bindParam(':user2_id', $user2_id); $stmt->execute(); 
                $messages = $stmt->fetchAll(PDO::FETCH_ASSOC); 
                
                echo "<pre>"; 
                print_r($messages); // Verifica los datos sin procesar 
                echo "</pre>";

                return json_encode($messages); 
            } 
            
            return json_encode(['status' => 'Invalid action']); 
        }

    } catch(PDOException $e) {
        http_response_code(500);
        echo json_encode(['message' => "Error al consultar: " . $e->getMessage()]);
    }
?>