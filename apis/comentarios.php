<?php
// Permitir solicitudes desde cualquier origen
header("Access-Control-Allow-Origin: *");

// Permitir métodos específicos
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");

// Permitir encabezados específicos
header("Access-Control-Allow-Headers: Content-Type, Authorization");

    require 'db2.php';

    //función para obtener todos los comentarios hechos a un trabajador
    function searchComments() {
        global $pdo;

        $trabajadorId = $_GET['trabajador_id'] ?? null;

        $resultado = obtenerComentarios($pdo, $trabajadorId);

        if ($resultado['success']) {
            http_response_code(200);
            echo json_encode($resultado['data']); // Devolver todos los comentarios en formato JSON
        } else {
            http_response_code(404);
            echo json_encode(['message' => 'No se encontraron comentarios.']);
        }
    }

    searchComments() 
?>