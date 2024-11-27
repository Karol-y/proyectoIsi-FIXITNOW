<?php
// Permitir solicitudes desde cualquier origen
header("Access-Control-Allow-Origin: *");

// Permitir métodos específicos
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");

// Permitir encabezados específicos
header("Access-Control-Allow-Headers: Content-Type, Authorization");

    require 'db2.php';

    //función para obtener datos de los trabajadores
    searchServicios() {
        try {
            $servicios = obtenerServicios($pdo);
            echo json_encode($servicios);
        } catch (Exception $e) {
            http_response_code(500);
            echo json_encode(['error' => 'Error interno del servidor: ' . $e->getMessage()]);
        }
    }

    searchServicios()
?>