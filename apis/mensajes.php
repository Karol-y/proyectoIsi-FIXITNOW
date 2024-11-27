
<?php
    /*
    // Permitir solicitudes desde cualquier origen
    header("Access-Control-Allow-Origin: *");

    // Permitir métodos específicos
    header("Access-Control-Allow-Methods: GET, POST, OPTIONS");

    // Permitir encabezados específicos
    header("Access-Control-Allow-Headers: Content-Type, Authorization");

        require 'db2.php';

        $action = $_GET['action']; 
        $data = json_decode(file_get_contents('php://input'), true); 
        echo messages($action, $data);

        // Ruta para enviar un mensaje
        if ($_SERVER['REQUEST_METHOD'] == 'POST' && $_GET['action'] == 'sendMessage') {
            $sender_id = $_POST['sender_id'];
            $receiver_id = $_POST['receiver_id'];
            $message = $_POST['message'];

            $stmt = $pdo->prepare("INSERT INTO mensajes (sender_id, receiver_id, message) VALUES (:sender_id, :receiver_id, :message)");
            $stmt->bindParam(':sender_id', $sender_id);
            $stmt->bindParam(':receiver_id', $receiver_id);
            $stmt->bindParam(':message', $message);
            $stmt->execute();

            echo json_encode(['status' => 'Message sent']);
        }

        // Ruta para obtener mensajes
        if ($_SERVER['REQUEST_METHOD'] == 'GET' && $_GET['action'] == 'getMessages') {
            $user1_id = $_GET['user1_id'];
            $user2_id = $_GET['user2_id'];

            $stmt = $pdo->prepare("SELECT * FROM mensajes WHERE (sender_id = :user1_id AND receiver_id = :user2_id) OR (sender_id = :user2_id AND receiver_id = :user1_id) ORDER BY timestamp ASC");
            $stmt->bindParam(':user1_id', $user1_id);
            $stmt->bindParam(':user2_id', $user2_id);
            $stmt->execute();
            $messages = $stmt->fetchAll(PDO::FETCH_ASSOC);

            echo json_encode($messages);
        }*/

    // Permitir solicitudes desde cualquier origen
    header("Access-Control-Allow-Origin: *");

    // Permitir métodos específicos
    header("Access-Control-Allow-Methods: GET, POST, OPTIONS");

    // Permitir encabezados específicos
    header("Access-Control-Allow-Headers: Content-Type, Authorization");

    require 'db2.php';

    if (isset($_GET['action'])) { 
        $action = $_GET['action']; 
        $data = json_decode(file_get_contents('php://input'), true); 
        echo messages($action, $data); 
    } else { 
        echo json_encode(['status' => 'No action specified']); 
    }
?>
