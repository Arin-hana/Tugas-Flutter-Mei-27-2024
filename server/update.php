<?php
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');
header('Content-Type: application/json');
include "./data.php";

// file_put_contents('update_log.txt', print_r($_SERVER, true) . "\n", FILE_APPEND);
file_put_contents('update_log.txt', file_get_contents("php://input") . "\n", FILE_APPEND);

if ($_SERVER['REQUEST_METHOD'] == 'PUT') {
    // parse_str(file_get_contents("php://input"), $input);
    $input = json_decode(file_get_contents("php://input"), true);
    $id = $input['id'] ?? null;
    $name = $input['name'] ?? null;
    $salary = $input['salary'] ?? null;
    $age = $input['age'] ?? null;

    if ($id !== null && $name !== null && $salary !== null && $age !== null) {
        try {
            $stmt = $data->prepare("UPDATE dummy SET name = :name, salary = :salary, age = :age WHERE id = :id");
            $stmt->bindParam(':id', $id, PDO::PARAM_INT);
            $stmt->bindParam(':name', $name);
            $stmt->bindParam(':salary', $salary, PDO::PARAM_INT);
            $stmt->bindParam(':age', $age, PDO::PARAM_INT);
            if ($stmt->execute()) {
                echo json_encode(["message" => "Record updated successfully."]);
            } else {
                echo json_encode(["message" => "Failed to update record."]);
            }
        } catch (Exception $e) {
            echo json_encode(["message" => "Error: " . $e->getMessage()]);
        }
    } else {
        echo json_encode(["message" => "ID, name, salary, and age are required."]);
    }
} else {
    echo json_encode(["message" => "Invalid request method."]);
}

//©Arin Hanabi