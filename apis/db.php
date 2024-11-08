<?php
$hostname = 'localhost'; // Cambia esto si es necesario
$dbname = 'serviciosgeneralesbd'; // Nombre de tu base de datos
$username = 'root'; // Tu usuario de base de datos
$pass = '123456'; // Tu contraseña de base de datos

    try {
        $pdo = new PDO("mysql:host=$hostname;dbname=$dbname", $username, $pass);
        $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

        //funcion para insertar usuariso
        function insertarUsuario($pdo, $data) {
            //datos a insertar
            $usuario = isset($_POST['usuario']) ? $_POST['usuario'] : '';
            $contrasena = isset($_POST['contrasena']) ? $_POST['contrasena'] : '';
            $tipo = isset($_POST['tipo']) ? $_POST['tipo'] : '';

            //agregar logs para las variables
            error_log("usuario: " . $usuario);
            error_log("contrasena: " . $contrasena);
            error_log("tipo: " . $tipo);

            //verificar que todas las variables tengan los nombres comletos
            if(!empty($usuario)) {
                //verificar si usuario ya se encuentra en la base de datos
                $checkStmt = $pdo->prepare("SELECT COUNT(*) FROM usuarios WHERE usuario = :usuario");
                $checkStmt->bindValue(':usuario', $usuario);
                $checkStmt->execute();
                $usuarioExists = $checkStmt->fetchColumn();

                if ($usuarioExists) {
                    http_response_code(400);
                    echo json_encode(['message' => 'El usuario ya existe']);
                    return;
                }

                //preparar la consulta
                $sql = "INSERT INTO usuarios (usuario, contrasena, tipo)
                        VALUES (:usuario, :contrasena, :tipo)";

                $stmt = $pdo->prepare($sql);

                // Asignar valores a los parámetros
                $stmt->bindParam(':usuario', $usuario);
                $stmt->bindParam(':contrasena', $contrasena);
                $stmt->bindParam(':tipo', $tipo);

                // Ejecutar la consulta
                $stmt->execute();

                echo json_encode(['message' => "Registro insertado exitosamente."]);
            } else { 
                http_response_code(400);
                echo json_encode(['message' => "Error: Hay variables vacías o incorrectas."]); 
            }
        }

        //funcion para insertar clientes
        function insertarCliente($pdo, $data){

            // Datos a insertar
            $foto = isset($_POST['foto']) ? $_POST['foto'] : ''; 
            $nombres = isset($_POST['nombres']) ? $_POST['nombres'] : ''; 
            $apellidos = isset($_POST['apellidos']) ? $_POST['apellidos'] : ''; 
            $numDoc = isset($_POST['numDoc']) ? ($_POST['numDoc']) : ''; // Asegúrate de que sea un BIGINT 
            $email = isset($_POST['email']) ? $_POST['email'] : ''; // Asegúrate de que sea único 
            $telefono = isset($_POST['telefono']) ? $_POST['telefono'] : ''; // Formato de teléfono 
            $edad = isset($_POST['edad']) ? ($_POST['edad']) : ''; // Asegúrate de que sea un INT 
            $id_usuario = isset($_POST['id_usuario']) ? ($_POST['id_usuario']) : '';

            // Agregar logs para ver las variables 
            error_log("foto: " . $foto); 
            error_log("nombres: " . $nombres); 
            error_log("apellidos: " . $apellidos); 
            error_log("numDoc: " . $numDoc); 
            error_log("email: " . $email); 
            error_log("telefono: " . $telefono); 
            error_log("edad: " . $edad); 
            error_log("id_usuario: " . $id_usuario);
            
            // Verificar que todas las variables tengan valores correctos 
            if (!empty($numDoc) && !empty($edad) && !empty($email)) { 
                // Verificar si numDoc ya existe en la base de datos 
                $checkStmt = $pdo->prepare("SELECT COUNT(*) FROM clientes WHERE numDoc = :numDoc"); 
                $checkStmt->bindValue(':numDoc', $numDoc); 
                $checkStmt->execute(); 
                $numDocExists = $checkStmt->fetchColumn(); 
                
                if ($numDocExists) { 
                    http_response_code(400); 
                    echo json_encode(['message' => 'El número de documento ya existe']); 
                    return; 
                }

                // Preparar la consulta
                $sql = "INSERT INTO clientes (foto, nombres, apellidos, numDoc, email, telefono, edad, id_usuario)
                        VALUES (:foto, :nombres, :apellidos, :numDoc, :email, :telefono, :edad, :id_usuario)";

                $stmt = $pdo->prepare($sql);

                // Asignar valores a los parámetros
                $stmt->bindParam(':foto', $foto);
                $stmt->bindParam(':nombres', $nombres);
                $stmt->bindParam(':apellidos', $apellidos);
                $stmt->bindParam(':numDoc', $numDoc);
                $stmt->bindParam(':email', $email);
                $stmt->bindParam(':telefono', $telefono);
                $stmt->bindParam(':edad', $edad);
                $stmt->bindParam(':id_usuario', $id_usuario);

                // Ejecutar la consulta
                $stmt->execute();

                echo json_encode(['message' => "Registro insertado exitosamente."]);
            } else { 
                http_response_code(400);
                echo json_encode(['message' => "Error: Hay variables vacías o incorrectas."]); 
            }
        } 

        //funcion para insertar trabajador
        function insertarTrabajador($pdo, $data) {
            // Datos a insertar
            $foto = isset($_POST['foto']) ? $_POST['foto'] : ''; 
            $nombres = isset($_POST['nombres']) ? $_POST['nombres'] : ''; 
            $apellidos = isset($_POST['apellidos']) ? $_POST['apellidos'] : ''; 
            $numDoc = isset($_POST['numDoc']) ? ($_POST['numDoc']) : ''; // Asegúrate de que sea un BIGINT 
            $email = isset($_POST['email']) ? $_POST['email'] : ''; // Asegúrate de que sea único 
            $telefono = isset($_POST['telefono']) ? $_POST['telefono'] : ''; // Formato de teléfono 
            $edad = isset($_POST['edad']) ? ($_POST['edad']) : ''; // Asegúrate de que sea un INT 
            $tipSer = isset($_POST['tipSer']) ? $_POST['tipSer'] : '';
            $certificadoPath = isset($_POST['certificado']) ? $_POST['certificado'] : '';
            $antecedentePath = isset($_POST['antecedente']) ? $_POST['antecedente'] : '';
            $id_usuario = isset($_POST['id_usuario']) ? $_POST['id_usuario'] : '';
    
            // Agregar logs para ver las variables 
            error_log("foto: " . $foto); 
            error_log("nombres: " . $nombres); 
            error_log("apellidos: " . $apellidos); 
            error_log("numDoc: " . $numDoc); 
            error_log("email: " . $email); 
            error_log("telefono: " . $telefono); 
            error_log("edad: " . $edad); 
            error_log("tipSer: " . $tipSer);
            error_log("certificado: " . $certificadoPath);
            error_log("antecedente: " . $antecedentePath);
            error_log("id_usuario: " . $id_usuario);
            
            // Verificar que todas las variables tengan valores correctos 
            if (!empty($numDoc) && !empty($edad) && !empty($email) && !empty($usuario)) { 
                // Verificar si numDoc ya existe en la base de datos 
                $checkStmt = $pdo->prepare("SELECT COUNT(*) FROM trabajadores WHERE numDoc = :numDoc"); 
                $checkStmt->bindValue(':numDoc', $numDoc); 
                $checkStmt->execute(); 
                $numDocExists = $checkStmt->fetchColumn(); 
                
                if ($numDocExists) { 
                    http_response_code(400); 
                    echo json_encode(['message' => 'El número de documento ya existe']); 
                    return; 
                }
    
                // Preparar la consulta
                $sql = "INSERT INTO trabajadores (foto, nombres, apellidos, numDoc, email, telefono, edad, tipSer, certificado, antecedente, id_usuario)
                        VALUES (:foto, :nombres, :apellidos, :numDoc, :email, :telefono, :edad, :tipSer, :certificado, :antecedente, :id_usuario)";
    
                $stmt = $pdo->prepare($sql);
    
                // Asignar valores a los parámetros
                $stmt->bindParam(':foto', $foto);
                $stmt->bindParam(':nombres', $nombres);
                $stmt->bindParam(':apellidos', $apellidos);
                $stmt->bindParam(':numDoc', $numDoc);
                $stmt->bindParam(':email', $email);
                $stmt->bindParam(':telefono', $telefono);
                $stmt->bindParam(':edad', $edad);
                $stmt->bindParam(':tipSer', $tipSer);
                $stmt->bindParam(':certificado', $certificadoPath);
                $stmt->bindParam(':antecedente', $antecedentePath);
                $stmt->bindParam(':id_usuario', $id_usuario);
    
                // Ejecutar la consulta
                $stmt->execute();
    
                echo json_encode(['message' => "Registro insertado exitosamente."]);
            } else { 
                http_response_code(400);
                echo json_encode(['message' => "Error: Hay variables vacías o incorrectas."]); 
            }
        }
    } catch(PDOException $e) {
        http_response_code(500);
        echo json_encode(['message' => "Error al insertar registro: " . $e->getMessage()]);
    }
?>
