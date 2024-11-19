<?php
// Permitir solicitudes desde cualquier origen
header("Access-Control-Allow-Origin: *");

// Permitir métodos específicos
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");

// Permitir encabezados específicos
header("Access-Control-Allow-Headers: Content-Type, Authorization");

    require 'db2.php';

    //función para obtener datos de los trabajadores
    function searchWorkers() {
        global $pdo;

        $tipSer = $_GET['servicio'] ?? null; // Cambia a GET para que coincida con Flutter
        $resultado = obtenerTrabajadores($pdo, $tipSer);

        if ($resultado['success']) {
            http_response_code(200);
            echo json_encode($resultado['data']); // Devolver todos los trabajadores en formato JSON
        } else {
            http_response_code(404);
            echo json_encode(['message' => 'No se encontraron trabajadores.']);
        }
    }

    searchWorkers() 
?>