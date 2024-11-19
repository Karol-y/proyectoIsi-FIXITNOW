<?php
// Permitir solicitudes desde cualquier origen
header("Access-Control-Allow-Origin: *");

// Permitir métodos específicos
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");

// Permitir encabezados específicos
header("Access-Control-Allow-Headers: Content-Type, Authorization");

    require 'db2.php';

    //funcion para autenticacion
    function loginUsuario() {
        global $pdo;
        $usuario = $_POST['usuario'] ?? '';
        $contrasena = $_POST['contrasena'] ?? '';

        if (empty($usuario) || empty($contrasena)) {
            http_response_code(400);
            echo json_encode(['message' => 'Usuario o Contraseña faltante']);
            return;
        }

        // Llamada a la función verificarUsuario en db.php
        $resultado = verificarUsuario($pdo, $usuario, $contrasena);

        if ($resultado['success']) {
            http_response_code(200);
            echo json_encode(['message' => 'Inicio de sesión exitoso', 'tipo' => $resultado['tipo']]);
        } else {
            http_response_code(401);
            echo json_encode(['message' => 'Credenciales incorrectas']);
        }
    }

    loginUsuario();

?>