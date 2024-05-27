<?php
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');
header('Content-Type: application/json');

// Include database connection
include "./data.php";

file_put_contents('delete_log.txt', print_r($_SERVER, true) . "\n", FILE_APPEND);
file_put_contents('delete_log.txt', file_get_contents("php://input") . "\n", FILE_APPEND);

if ($_SERVER['REQUEST_METHOD'] == 'DELETE') {
    parse_str(file_get_contents("php://input"), $input);
    $id = $input['id'] ?? null;

    if ($id !== null) {
        try {
            $stmt = $data->prepare("DELETE FROM dummy WHERE id = :id");
            $stmt->bindParam(':id', $id, PDO::PARAM_INT);
            if ($stmt->execute()) {
                echo json_encode(["message" => "Record deleted successfully."]);
            } else {
                echo json_encode(["message" => "Failed to delete record."]);
            }
        } catch (Exception $e) {
            echo json_encode(["message" => "Error: " . $e->getMessage()]);
        }
    } else {
        echo json_encode(["message" => "ID is required."]);
    }
} else {
    echo json_encode(["message" => "Invalid request method."]);
}

//©Arin Hanabi