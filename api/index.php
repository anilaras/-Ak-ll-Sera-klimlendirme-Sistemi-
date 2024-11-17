<?php
require_once 'sql_functions.php';

$requestUri = explode('/', trim($_SERVER['REQUEST_URI'], '/'));
$method = $_SERVER['REQUEST_METHOD'];
$token = $_SERVER['HTTP_TOKEN'] ?? null;

if (!validateToken($token)) {
    http_response_code(403);
    echo json_encode(["error" => "Unauthorized"]);
    exit;
}

switch ($requestUri[1]) {
    case 'sensor_data':
        if ($method === 'POST') {
            $data = json_decode(file_get_contents('php://input'), true);
            insertSensorData($data);
            echo json_encode(["status" => "success"]);
        } elseif ($method === 'GET') {
            $startDate = $_GET['start_date'] ?? null;
            $endDate = $_GET['end_date'] ?? null;
            echo json_encode(getSensorData($startDate, $endDate));
        }
        break;

    case 'thresholds':
        if ($method === 'GET') {
            echo json_encode(getThresholds());
        } elseif ($method === 'POST') {
            $data = json_decode(file_get_contents('php://input'), true);
            updateThresholds($data['parameter'], $data['value']);
            echo json_encode(["status" => "success"]);
        }
        break;

    case 'led_settings':
        if ($method === 'GET') {
            echo json_encode(getLedSettings());
        } elseif ($method === 'POST') {
            $data = json_decode(file_get_contents('php://input'), true);
            updateLedSettings($data['red'], $data['green'], $data['blue'], $data['brightness']);
            echo json_encode(["status" => "success"]);
        }
        break;

    default:
        http_response_code(404);
        echo json_encode(["error" => "Endpoint not found"]);
        break;
}
?>
