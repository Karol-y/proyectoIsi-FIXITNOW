<?php
// Permitir solicitudes desde cualquier origen
header("Access-Control-Allow-Origin: *");

// Permitir métodos específicos
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");

// Permitir encabezados específicos
header("Access-Control-Allow-Headers: Content-Type, Authorization");

    // Manejo de la solicitud OPTIONS
    if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
        http_response_code(200);
        exit;
    }

    require 'db.php';

    function handleRequest() {
        global $pdo;
        $method = $_SERVER['REQUEST_METHOD'];
        $uri = isset($_SERVER['PATH_INFO']) ? explode('/', trim($_SERVER['PATH_INFO'], '/')) : [];

        if (!empty($uri)){
            if ($uri[0] === 'clientes') {
                switch ($method) {
                    case 'GET':
                        return getClientes();
                    case 'POST':
                        return createCliente();
                    case 'PUT':
                        return updateCliente($uri[1]);
                    case 'DELETE':
                        return deleteCliente($uri[1]);
                }
            } elseif ($uri[0] === 'trabajadores') {
                switch ($method) {
                    case 'GET':
                        return getTrabajadores();
                    case 'POST':
                        return createTrabajador();
                    case 'PUT':
                        return updateTrabajador($uri[1]);
                    case 'DELETE':
                        return deleteTrabajador($uri[1]);
                }
            } elseif ($uri[0] === 'calificacion') {
                switch ($method) {
                    case 'GET':
                        return getCalificaciones();
                    case 'POST':
                        return createCalificacion();
                }
            } elseif ($uri[0] === 'servicios') {
                switch ($method) {
                    case 'GET':
                        return searchServicios(); // Llamar a la función de búsqueda
                    case 'POST':
                        return createServicio(); // Llamar a la función para crear un servicio
                }
            }
        }
        http_response_code(404);
        echo json_encode(['message' => 'Not Found']);
    }

    // Funciones para manejar trabajadores
    function getClientes() {
        global $pdo;
        $stmt = $pdo->query("SELECT * FROM clientes");
        $clientes = $stmt->fetchAll(PDO::FETCH_ASSOC);
        echo json_encode($clientes);
    }

    //se envian los datos organizados y validados de los clientes a db.php
    function createCliente() {
        global $pdo;

        if($_SERVER['REQUEST_METHOD'] == 'POST'){
            // Verifica si se ha enviado un archivo
            if (isset($_FILES['foto']) && $_FILES['foto']['error'] == UPLOAD_ERR_OK) {
                $foto = $_FILES['foto'];
                // Validar la extensión del archivo
                $ext = pathinfo($_FILES['foto']['name'], PATHINFO_EXTENSION);
                $extensionesPermitidas = ['jpg', 'jpeg', 'png'];

                if (!in_array(strtolower($ext), $extensionesPermitidas)) {
                    http_response_code(400);
                    echo json_encode(['message' => 'Tipo de archivo no permitido']);
                    return;
                }
                $rutaDestino = 'C:/xampp1/htdocs/apis/uploads/' . basename($foto['name']);

                // Mueve el archivo al directorio deseado
                if (move_uploaded_file($foto['tmp_name'], $rutaDestino)) {
                    error_log('Archivo movido con éxito: ' . $rutaDestino);
                    // El archivo se ha movido con éxito, ahora guarda la ruta en la base de datos
                    // Usar $_POST en lugar de php://input para los datos de formulario 
                    $nombres = isset($_POST['nombres']) ? $_POST['nombres'] : ''; 
                    $apellidos = isset($_POST['apellidos']) ? $_POST['apellidos'] : ''; 
                    $numDoc = isset($_POST['numDoc']) ? intval($_POST['numDoc']) : null; 
                    $email = isset($_POST['email']) ? $_POST['email'] : ''; 
                    $telefono = isset($_POST['telefono']) ? $_POST['telefono'] : ''; 
                    $edad = isset($_POST['edad']) ? intval($_POST['edad']) : null; 
                    $usuario = isset($_POST['usuario']) ? ($_POST['usuario']) : '';
                    $contrasena = isset($_POST['contrasena']) ? ($_POST['contrasena']) : '';
                    
                    // Validación de parámetros
                    if (empty($nombres) || empty($apellidos) || is_null($numDoc) || empty($email) || empty($telefono) || is_null($edad) || empty($usuario) || empty($contrasena)) {
                        error_log('Parámetros faltantes: ' . print_r($_POST, true));
                        http_response_code(400);
                        echo json_encode(['message' => 'Faltan parámetros requeridos']);
                        return;
                    }

                    error_log('Datos a insertar: ' . print_r($_POST, true));
                    error_log('Ruta de la foto: ' . $rutaDestino);

                    // Insertar en la tabla de usuarios y obtener el ID del usuario
                    $stmt = $pdo->prepare("INSERT INTO usuarios (usuario, contrasena, tipo) VALUES (:usuario, :contrasena, :tipo)");
                    $stmt->bindValue(':usuario', $usuario);
                    $stmt->bindValue(':contrasena', password_hash($contrasena, PASSWORD_DEFAULT));
                    $stmt->bindValue(':tipo', 'cliente');

                    if($stmt->execute()) {
                        $userId = $pdo->lastInsertId();

                        //insertar en la tabla clientes
                        $stmt = $pdo->prepare(
                            "INSERT INTO clientes (foto, nombres, apellidos, numDoc, email, telefono, edad, id_usuario) 
                            VALUES (:foto, :nombres, :apellidos, :numDoc, :email, :telefono, :edad, :id_usuario)");

                            if (!$stmt) {
                                die("Error al preparar la consulta: " . implode(", ", $pdo->errorInfo()));
                            }
                            
                            // Asigna los valores a los parámetros usando bindValue
                            $urlFoto = "http://192.168.0.24/apis/uploads/" . basename($foto['name']);
                            $stmt->bindValue(':foto', $urlFoto); // Guarda la URL de la foto
                            $stmt->bindValue(':nombres', $_POST['nombres']);
                            $stmt->bindValue(':apellidos', $_POST['apellidos']);
                            $stmt->bindValue(':numDoc', $_POST['numDoc']);
                            $stmt->bindValue(':email', $_POST['email']);
                            $stmt->bindValue(':telefono', $_POST['telefono']);
                            $stmt->bindValue(':edad', $_POST['edad']);
                            $stmt->bindValue(':id_usuario', $userId);

                            if ($stmt->execute()) {
                                http_response_code(201);
                                echo json_encode(['message' => 'Cliente creado']);
                            } else {
                                http_response_code(500);
                                error_log('Error al crear Cliente: ' . print_r($stmt->errorInfo(), true));
                                echo json_encode(['message' => 'Error al crear Cliente']);
                            }
                    } else {
                        http_response_code(500);
                        error_log('Error al crear usuario: ' . print_r($stmt->errorInfo(), true));
                        echo json_encode(['message' => 'Error al crear usuario']);
                    }
                } else {
                    error_log('Error al mover el archivo: ' . print_r($foto, true));
                    http_response_code(500);
                    echo json_encode(['message' => 'Error al mover el archivo']);
                }
            } else {
                http_response_code(400);
                echo json_encode(['message' => 'No se ha enviado un archivo']);
            }
        }
    }

    // Funciones para manejar trabajadores
    function getTrabajadores() {
        global $pdo;
        $stmt = $pdo->query("SELECT * FROM trabajadores");
        $trabajadores = $stmt->fetchAll(PDO::FETCH_ASSOC);
        echo json_encode($trabajadores);
    }

    function createTrabajador() {
        global $pdo;

        if($_SERVER['REQUEST_METHOD'] == 'POST'){
            
            // Verificar que todos los archivos se procesaron correctamente
            if (isset($_FILES['foto']) && $_FILES['foto']['error'] == UPLOAD_ERR_OK 
                && isset($_FILES['certificado']) && $_FILES['certificado']['error'] == UPLOAD_ERR_OK
                && isset($_FILES['antecedente']) && $_FILES['antecedente']['error'] == UPLOAD_ERR_OK) {

                $foto = $_FILES['foto'];
                $certificadoPath = $_FILES['certificado'];
                $antecedentePath = $_FILES['antecedente'];
                
                // Validar la extensión del archivo
                $ext = pathinfo($_FILES['foto']['name'], PATHINFO_EXTENSION);
                $ext1 = pathinfo($_FILES['certificado']['name'], PATHINFO_EXTENSION);
                $ext2 = pathinfo($_FILES['antecedente']['name'], PATHINFO_EXTENSION);
                $extensionesPermitidas = ['jpg', 'jpeg', 'png', 'pdf', 'docx'];

                if (!in_array(strtolower($ext), $extensionesPermitidas)) {
                    http_response_code(400);
                    echo json_encode(['message' => 'Tipo de archivo no permitido']);
                    return;
                }
                if (!in_array(strtolower($ext1), $extensionesPermitidas)) {
                    http_response_code(400);
                    echo json_encode(['message' => 'Tipo de archivo no permitido']);
                    return;
                }
                if (!in_array(strtolower($ext2), $extensionesPermitidas)) {
                    http_response_code(400);
                    echo json_encode(['message' => 'Tipo de archivo no permitido']);
                    return;
                }
                $rutaDestino = 'C:/xampp1/htdocs/apis/uploads/' . basename($foto['name']);
                $rutaDestino1 = 'C:/xampp1/htdocs/apis/uploads/' . basename($certificadoPath['name']);
                $rutaDestino2 = 'C:/xampp1/htdocs/apis/uploads/' . basename($antecedentePath['name']);

                //mueve el archivo al directorio deseado
                if(move_uploaded_file($foto['tmp_name'], $rutaDestino) 
                && move_uploaded_file($certificadoPath['tmp_name'], $rutaDestino1) 
                && move_uploaded_file($antecedentePath['tmp_name'], $rutaDestino2)) {
                    error_log('Archivo movido con éxito: ' . $rutaDestino);
                    error_log('Archivo movido con éxito: ' . $rutaDestino1);
                    error_log('Archivo movido con éxito: ' . $rutaDestino2);

                    //los archivos se han movido con éxito, ahora guarda la ruta en la base de datos
                    //usar $_POST en lugar de php://input para los datos de formulario
                    $nombres = isset($_POST['nombres']) ? $_POST['nombres'] : ''; 
                    $apellidos = isset($_POST['apellidos']) ? $_POST['apellidos'] : ''; 
                    $numDoc = isset($_POST['numDoc']) ? intval($_POST['numDoc']) : null; 
                    $email = isset($_POST['email']) ? $_POST['email'] : ''; 
                    $telefono = isset($_POST['telefono']) ? $_POST['telefono'] : ''; 
                    $edad = isset($_POST['edad']) ? intval($_POST['edad']) : null;
                    $tipSer = isset($_POST['tipSer']) ? $_POST['tipSer'] : ''; 
                    $usuario = isset($_POST['usuario']) ? $_POST['usuario'] : '';
                    $contrasena = isset($_POST['contrasena']) ? $_POST['contrasena'] : '';
                    
                    // Validación de parámetros
                    if (empty($nombres) || empty($apellidos) || is_null($numDoc) || empty($email) || empty($telefono) || is_null($edad) || empty($tipSer) || empty($usuario) || empty($contrasena)) {
                        error_log('Parámetros faltantes: ' . print_r($_POST, true));
                        http_response_code(400);
                        echo json_encode(['message' => 'Faltan parámetros requeridos']);
                        return;
                    }

                    /*VERIFICA QUE EL EMAIL SEA VALIDO
                    if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
                        http_response_code(400);
                        echo json_encode(['message' => 'Email no válido']);
                        return;
                    }*/

                    error_log('Datos a insertar: ' . print_r($_POST, true));
                    error_log('Ruta de la foto: ' . $rutaDestino);
                    error_log('Ruta del certificado: ' . $rutaDestino1);
                    error_log('Ruta del antecedente: ' . $rutaDestino2);
                
                    // Insertar primero en la tabla de usuarios
                    $stmt = $pdo->prepare("INSERT INTO usuarios (usuario, contrasena, tipo) VALUES (:usuario, :contrasena, :tipo)");
                    $stmt->bindValue(':usuario', $usuario);
                    $stmt->bindValue(':contrasena', password_hash($contrasena, PASSWORD_DEFAULT));
                    $stmt->bindValue(':tipo', 'trabajador');
                    
                    if ($stmt->execute()) {
                        $userId = $pdo->lastInsertId();
                        
                        // Insertar en la tabla de trabajador
                        $stmt = $pdo->prepare("INSERT INTO trabajadores (foto, nombres, apellidos, numDoc, email, telefono, edad, tipSer, certificado, antecedente, id_usuario) 
                        VALUES (:foto, :nombres, :apellidos, :numDoc, :email, :telefono, :edad, :tipSer, :certificado, :antecedente, :id_usuario)");
                        
                        if (!$stmt) {
                            die("Error al preparar la consulta: " . implode(", ", $pdo->errorInfo()));
                        }
                        
                        // Asigna los valores a los parámetros usando bindValue
                        $urlFoto = "http://192.168.0.24/apis/uploads/" . basename($foto['name']);
                        $urlCertificado = "http://192.168.0.24/apis/uploads/" . basename($certificadoPath['name']);
                        $urlAntecedente = "http://192.168.0.24/apis/uploads/" . basename($antecedentePath['name']);

                        $stmt->bindValue(':foto', $urlFoto); //guarda la URL de la foto
                        $stmt->bindValue(':nombres', $nombres);
                        $stmt->bindValue(':apellidos', $apellidos);
                        $stmt->bindValue(':numDoc', $numDoc); 
                        $stmt->bindValue(':email', $email);
                        $stmt->bindValue(':telefono', $telefono);
                        $stmt->bindValue(':edad', $edad); 
                        $stmt->bindValue(':tipSer', $tipSer);
                        $stmt->bindValue(':certificado', $urlCertificado);
                        $stmt->bindValue(':antecedente', $urlAntecedente);
                        $stmt->bindValue(':id_usuario', $userId);
    
                        if ($stmt->execute()) {
                            http_response_code(201);
                            echo json_encode(['message' => 'Trabajador creado']);
                        } else {
                            http_response_code(500);
                            error_log('Error al crear trabajador: ' . print_r($stmt->errorInfo(), true));
                            echo json_encode(['message' => 'Error al crear trabajador']);
                        }
                    } else {
                        http_response_code(500);
                        error_log('Error al crear usuario: ' . print_r($stmt->errorInfo(), true));
                        echo json_encode(['message' => 'Error al crear usuario']);
                    }
                } else {
                    error_log('Error al mover el archivo: ' . print_r($foto, true));
                    error_log('Error al mover el archivo: ' . print_r($antecedentePath, true));
                    error_log('Error al mover el archivo: ' . print_r($certificadoPath, true));
                    http_response_code(500);
                    echo json_encode(['message' => 'Error al procesar los archivos']);
                }   
            } else {
                http_response_code(400);
                echo json_encode(['message' => 'No se ha enviado un archivo']);
            }
        } 
    }

    // Funciones para manejar calificaciones
    function getCalificacion() {
        global $pdo;
        $stmt = $pdo->query("SELECT * FROM calificacion");
        $calificaion = $stmt->fetchAll(PDO::FETCH_ASSOC);
        echo json_encode($calificaion);
    }

    function createCalificacion() {
        global $pdo;
        $data = json_decode(file_get_contents("php://input"), true);

        // Validación de parámetros
        if (!isset($data['Número de identidad del TRABAJADOR'], 
                    $data['Comentario'], 
                    $data['Puntuación'])) {
            http_response_code(400);
            echo json_encode(['message' => 'Faltan parámetros requeridos']);
            return;
        }

        // Asegúrate de que el número de identidad sea un entero válido
        if (!is_numeric($data['Número de identidad del TRABAJADOR'])) {
            http_response_code(400);
            echo json_encode(['message' => 'El número de identidad debe ser un número válido']);
            return;
        }

        // Asegúrate de que Puntuación sea un número válido
        if (!is_numeric($data['Puntuación']) || $data['Puntuación'] < 0 || $data['Puntuación'] > 5) {
            http_response_code(400);
            echo json_encode(['message' => 'La puntuación debe ser un número entre 0 y 5']);
            return;
        }

        // Prepara la consulta SQL para insertar
        try {
            $stmt = $pdo->prepare("INSERT INTO calificacion (`Número de identidad del TRABAJADOR`, Comentario, Puntuación) 
                                    VALUES (:numeroIdentidadTrabajador, :comentario, :puntuacion)");

            // Asigna los valores a los parámetros usando bindValue
            $stmt->bindValue(':numeroIdentidadTrabajador', (int)$data['Número de identidad del TRABAJADOR']); // Convertir a entero
            $stmt->bindValue(':comentario', htmlspecialchars($data['Comentario']));
            $stmt->bindValue(':puntuacion', (int)$data['Puntuación']); // Convertir a entero

            if ($stmt->execute()) {
                http_response_code(201);
                echo json_encode(['message' => 'Calificación creada']);
            } else {
                http_response_code(500);
                echo json_encode(['message' => 'Error al crear calificación']);
                error_log(print_r($stmt->errorInfo(), true)); // Log para depuración
            }
        } catch (PDOException $e) {
            http_response_code(500);
            echo json_encode(['message' => 'Error: ' . implode(":",$e->errorInfo)]);
        }
    }

    // Funciones para manejar servicios
    function getServicios() {
        global $pdo;
        $stmt = $pdo->query("SELECT * FROM servicios");
        $servicios = $stmt->fetchAll(PDO::FETCH_ASSOC);
        echo json_encode($servicios);
    }

    function createServicio() {
        global $pdo;
        $data = json_decode(file_get_contents("php://input"), true);

        // Validación de parámetros
        if (!isset($data['codigoS'], 
                    $data['Número Identificación TRABAJADOR'], 
                    $data['Número Identificación CLIENTE'], 
                    $data['Descripción'], 
                    $data['Tipo de trabajo'])) {
            http_response_code(400);
            echo json_encode(['message' => 'Faltan parámetros requeridos']);
            return;
        }

        // Prepara la consulta SQL para insertar
        try {
            $stmt = $pdo->prepare("INSERT INTO servicios (codigoS, `Número Identificación TRABAJADOR`, `Número Identificación CLIENTE`, Descripción, `Tipo de trabajo`) 
                                    VALUES (:codigoS, :numeroIdentificacionTrabajador, :numeroIdentificacionCliente, :descripcion, :tipoTrabajo)");

            // Asigna los valores a los parámetros usando bindValue
            $stmt->bindValue(':codigoS', htmlspecialchars($data['codigoS']));
            $stmt->bindValue(':numeroIdentificacionTrabajador', htmlspecialchars($data['Número Identificación TRABAJADOR']));
            $stmt->bindValue(':numeroIdentificacionCliente', htmlspecialchars($data['Número Identificación CLIENTE']));
            $stmt->bindValue(':descripcion', htmlspecialchars($data['Descripción']));
            $stmt->bindValue(':tipoTrabajo', htmlspecialchars($data['Tipo de trabajo']));

            if ($stmt->execute()) {
                http_response_code(201);
                echo json_encode(['message' => 'Servicio creado']);
            } else {
                http_response_code(500);
                echo json_encode(['message' => 'Error al crear servicio']);
                error_log(print_r($stmt->errorInfo(), true)); // Log para depuración
            }
        } catch (PDOException $e) {
            http_response_code(500);
            echo json_encode(['message' => 'Error: ' . implode(":",$e->errorInfo)]);
        }
    }

    //funcion para comparar el loggin y el password ingresados en vista iniciosesion
    if($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_POST['usuario'], $_POST['contrasena'])) {
        $usuario = $_POST['usuario'];
        $contrasena = $_POST['contrasena'];

        try{
            //consulta para verificar si el usuario existe y obtener su tipo
            $stmt = $pdo->prepare("SELECT tipo, contrasena FROM usuarios WHERE usuario = :usuario");
            $stmt->bindParam(':usuario', $usuario);
            $stmt->execute();

            $result = $stmt->fetch(PDO::FETCH_ASSOC);

            if($result && password_verify($contrasena, $result['contrasena'])) {
                echo json_encode(['status' => 'success', 'tipo' => $result['tipo']]);
            } else {
                echo json_encode(['status' => 'fail', 'message' => 'Usuario o Contraseña incorrectos']);
            }
        }catch(PDOException $e) {
            echo json_encode(['status' => 'fail', 'message' => 'Error en la base de datos: ' . $e->getMessage()]);
        }
    }

    // Función para buscar servicios por nombre
    function searchServicios() {
        global $pdo;
        
        // Obtener el nombre del servicio desde los parámetros de consulta
        if (!isset($_GET['nombreServicio'])) {
            http_response_code(400);
            echo json_encode(['message' => 'Falta el parámetro nombreServicio']);
            return;
        }

        $nombreServicio = htmlspecialchars($_GET['nombreServicio']);

        // Prepara la consulta SQL para buscar servicios por nombre
        try {
            $stmt = $pdo->prepare("SELECT * FROM servicios WHERE Descripción LIKE :nombreServicio");
            $stmt->bindValue(':nombreServicio', '%' . $nombreServicio . '%'); // Búsqueda parcial

            $stmt->execute();
            
            // Obtener resultados
            $servicios = $stmt->fetchAll(PDO::FETCH_ASSOC);
            
            if ($servicios) {
                echo json_encode($servicios);
            } else {
                http_response_code(404);
                echo json_encode(['message' => 'No se encontraron servicios']);
            }
        } catch (PDOException $e) {
            http_response_code(500);
            echo json_encode(['message' => 'Error: ' . implode(":",$e->errorInfo)]);
        }
    }
    // Llamar a la función que maneja las solicitudes
    handleRequest();
?>