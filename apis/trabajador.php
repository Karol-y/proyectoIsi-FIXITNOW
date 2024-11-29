<?php
// Permitir solicitudes desde cualquier origen
header("Access-Control-Allow-Origin: *");

// Permitir métodos específicos
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");

// Permitir encabezados específicos
header("Access-Control-Allow-Headers: Content-Type, Authorization");

//esta api no se está consumiendo aún, pero será para obtener la información de trabajadores, para el inicio de la sesion

    require 'db2.php'; // Asegúrate de que este archivo contiene la conexión a la base de datos.

    // Función para obtener datos del trabajador
    function obtenerTrabajador($id_usuario) {
        global $pdo;

        // Consulta para obtener los detalles del trabajador específico
        $query = "SELECT foto, nombres, apellidos, tipSer FROM trabajadores WHERE id_usuario = :id_usuario";
        $stmt = $pdo->prepare($query);
        $stmt->bindParam(':id_usuario', $id_usuario, PDO::PARAM_INT);
        $stmt->execute();

        if ($stmt->rowCount() > 0) {
            $trabajador = $stmt->fetch(PDO::FETCH_ASSOC);

            // Recuperar calificaciones de los trabajadores (si existe)
            $calificacionesQuery = "SELECT Comentario, Puntuacion FROM calificacion WHERE Numdoc = :idTrabajador";
            $calificacionesStmt = $pdo->prepare($calificacionesQuery);
            $calificacionesStmt->bindParam(':idTrabajador', $idTrabajador, PDO::PARAM_INT);
            $calificacionesStmt->execute();

            $calificaciones = $calificacionesStmt->fetchAll(PDO::FETCH_ASSOC);

            // Devolver los datos del trabajador y las calificaciones en formato JSON
            return [
                'success' => true,
                'data' => [
                    'nombre' => $trabajador['nombres'],
                    'foto' => $trabajador['foto'],
                    'tipo_servicio' => $trabajador['tipSer'],
                    'descripcion' => $trabajador['Descripcion'],
                ]
            ];
        } else {
            return [
                'success' => false,
                'message' => 'Trabajador no encontrado'
            ];
        }
    }

    // Función para manejar la solicitud
    function obtenerInformacionTrabajador() {
        $idTrabajador = $_GET['id'] ?? null;  // Asegúrate de pasar el ID del trabajador en la solicitud GET.

        if ($id_usuario) {
            $resultado = obtenerTrabajador($id_usuario);

            if ($resultado['success']) {
                http_response_code(200);
                echo json_encode($resultado['data']); // Devolver todos los detalles del trabajador en formato JSON
            } else {
                http_response_code(404);
                echo json_encode(['message' => $resultado['message']]);
            }
        } else {
            http_response_code(400);
            echo json_encode(['message' => 'ID del trabajador no proporcionado']);
        }
    }

    obtenerInformacionTrabajador();
?>
