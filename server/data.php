<?php  

$data_name = "examflutter";
$data_ip = "localhost";
$username = "root";
$password = "";

try {
    $data = new PDO("mysql:host={$data_ip};dbname={$data_name};charset=utf8", $username, $password);
    $data->setAttribute(PDO::ATTR_EMULATE_PREPARES, false);
    $data->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    echo json_encode(["message" => "Database connection error: " . $e->getMessage()]);
    exit();
}

//©Arin Hanabi