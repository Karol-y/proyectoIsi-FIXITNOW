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
            } elseif ($uri[0] === 'calificaciones') {
                switch ($method) {
                    case 'GET':
                        return getCalificaciones();
                    case 'POST':
                        return createCalificacion();
                }
            } elseif ($uri[0] === 'servicios') {
                switch ($method) {
                    case 'GET':
                        return getServicios(); // Llamar a la función de búsqueda
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

        if($_SERVER['REQUEST_METHOD'] == 'POST'){

            //obtener datos del cuerpo de la solicitud
            $data = json_decode(file_get_contents('php://input'), true);
            $trabajador_id = isset($data['trabajador_id']) ? intval($data['trabajador_id']) : null;
            $cliente_id = isset($data['cliente_id']) ? intval($data['cliente_id']) : null;
            $comentario = isset($data['comentario']) ? $data['comentario'] : '';
            $puntuacion = isset($data['puntuacion']) ? intval($data['puntuacion']) : null;

            // Validación de parámetros
            if (is_null($trabajador_id) || is_null($cliente_id) || empty($comentario) || is_null($puntuacion)) {
                error_log('Parámetros faltantes: ' . print_r($data, true));
                http_response_code(400);
                echo json_encode(['message' => 'Faltan parámetros requeridos']);
                return;
            }

            error_log('Datos a insertar: ' . print_r($_POST, true));

            // Prepara la consulta SQL para insertar
            try {
                //verificar que cliente_id existe en la tabla clientes
                $clienteStmt = $pdo->prepare("SELECT numDoc FROM clientes WHERE numDoc = :cliente_id");
                $clienteStmt->bindValue(':cliente_id', $cliente_id, PDO::PARAM_INT);
                $clienteStmt->execute();
                if($clienteStmt->rowCount() == 0) {
                    http_response_code(400);
                    echo json_encode(['message' => 'Cliente no encontrado']);
                    return;
                }

                //verificar que trabajador_id existe en la tabla trabajadores
                $trabajadorStmt = $pdo->prepare("SELECT numDoc FROM trabajadores WHERE numDoc = :trabajador_id");
                $trabajadorStmt->bindValue(':trabajador_id', $trabajador_id, PDO::PARAM_INT);
                $trabajadorStmt->execute();
                if($trabajadorStmt->rowCount() == 0) {
                    http_response_code(400);
                    echo json_encode(['message' => 'Trabajador no encontrado']);
                    return;
                }

                $stmt = $pdo->prepare("INSERT INTO calificacion (trabajador_id, cliente_id, comentario, puntuacion) 
                                        VALUES (:trabajador_id, :cliente_id, :comentario, :puntuacion)");

                // Asigna los valores a los parámetros usando bindValue
                $stmt->bindValue(':trabajador_id', $trabajador_id, PDO::PARAM_INT);
                $stmt->bindValue(':cliente_id', $cliente_id, PDO::PARAM_INT);
                $stmt->bindValue(':comentario', htmlspecialchars($comentario));
                $stmt->bindValue(':puntuacion', $puntuacion, PDO::PARAM_INT);

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
                echo json_encode(['message' => 'Error: ' . $e->getMessage()]);
            }
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
        if($_SERVER['REQUEST_METHOD'] == 'POST'){
            //obtener datos del cuerpo de la solicitud
            $data = json_decode(file_get_contents('php://input'), true);
            $id_trabajador = isset($data['id_trabajador']) ? intval($data['id_trabajador']) : null;
            $id_cliente = isset($data['id_cliente']) ? intval($data['id_cliente']) : null;
            $fecha = isset($data['fecha']) ? $data['fecha'] : '';
            $hora = isset($data['hora']) ? $data['hora'] : '';
            $estado = isset($data['estado']) ? $data['estado'] : '';

            // Validación de parámetros
            if (is_null($id_trabajador) || is_null($id_cliente) || empty($fecha) || empty($hora) || empty($estado)) {
                error_log('Parámetros faltantes: ' . print_r($data, true));
                http_response_code(400);
                echo json_encode(['message' => 'Faltan parámetros requeridos']);
                return;
            }

            error_log('Datos a insertar: ' . print_r($_POST, true));

            // Prepara la consulta SQL para insertar
            try {
                $stmt = $pdo->prepare("INSERT INTO servicios (id_trabajador, id_cliente, fecha, hora, estado) 
                                        VALUES (:id_trabajador, :id_cliente, :fecha, :hora, :estado)");

                // Asigna los valores a los parámetros usando bindValue
                $stmt->bindValue(':id_trabajador', $id_trabajador, PDO::PARAM_INT);
                $stmt->bindValue(':id_cliente', $id_cliente, PDO::PARAM_INT);
                $stmt->bindValue(':fecha', htmlspecialchars($fecha));
                $stmt->bindValue(':hora', htmlspecialchars($hora));
                $stmt->bindValue(':estado', htmlspecialchars($estado));

                if ($stmt->execute()) {
                    http_response_code(201);
                    echo json_encode(['message' => 'Servicio agregado']);
                } else {
                    http_response_code(500);
                    echo json_encode(['message' => 'Error al agregar servicio']);
                    error_log(print_r($stmt->errorInfo(), true)); // Log para depuración
                }
            } catch (PDOException $e) {
                http_response_code(500);
                echo json_encode(['message' => 'Error: ' . $e->getMessage()]);
            }
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