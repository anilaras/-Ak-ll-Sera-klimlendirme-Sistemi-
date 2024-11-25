<?php
// router.php
require_once 'config.php';
require_once 'database_operations.php';

class Router {
    private $db;
    private $method;
    private $uri;
    private $routes = [
        'GET' => [],
        'POST' => []
    ];

    public function __construct() {
        $this->db = new DatabaseOperations();
        $this->method = $_SERVER['REQUEST_METHOD'];
        $this->uri = trim($_SERVER['REQUEST_URI'], '/');
        
        // CORS ayarları
        header('Access-Control-Allow-Origin: *');
        header('Content-Type: application/json');
        header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
        header('Access-Control-Allow-Headers: Authorization, Content-Type');
        
        if ($this->method === 'OPTIONS') {
            exit(0);
        }
    }

    private function validateToken() {
        $headers = getallheaders();
        if (!isset($headers['Authorization'])) {
            $this->sendResponse(401, ['error' => 'No token provided']);
            return false;
        }

        $token = str_replace('Bearer ', '', $headers['Authorization']);
        if (!$this->db->validateToken($token)) {
            $this->sendResponse(401, ['error' => 'Invalid token']);
            return false;
        }

        return true;
    }

    private function sendResponse($statusCode, $data) {
        http_response_code($statusCode);
        echo json_encode($data);
        exit;
    }

    public function run() {
        // Token kontrolü (public endpoint'ler hariç)
        if (!in_array($this->uri, ['login', 'register'])) {
            if (!$this->validateToken()) {
                return;
            }
        }
        $url_route = substr($this->uri, strpos($this->uri, "/") + 1);
        switch ($url_route) {
            case 'api/' . API_VERSION . '/sensor-data':
                if ($this->method === 'POST') {
                    $data = json_decode(file_get_contents('php://input'), true);
                    if ($this->db->saveSensorData($data)) {
                        $this->sendResponse(201, ['message' => 'Data saved successfully']);
                    }
                } elseif ($this->method === 'GET') {
                    $startDate = $_GET['start_date'] ?? null;
                    $endDate = $_GET['end_date'] ?? null;
                    $data = $this->db->getSensorData($startDate, $endDate);
                    $this->sendResponse(200, $data);
                }
                break;

            case 'api/' . API_VERSION . '/thresholds':
                if ($this->method === 'GET') {
                    $data = $this->db->getThresholds();
                    $this->sendResponse(200, $data);
                } elseif ($this->method === 'POST') {
                    $data = json_decode(file_get_contents('php://input'), true);
                    if ($this->db->updateThresholds($data)) {
                        $this->sendResponse(200, ['message' => 'Thresholds updated']);
                    }
                }
                break;

            case 'api/' . API_VERSION . '/led-settings':
                if ($this->method === 'GET') {
                    $data = $this->db->getLedSettings();
                    $this->sendResponse(200, $data);
                } elseif ($this->method === 'POST') {
                    $data = json_decode(file_get_contents('php://input'), true);
                    if ($this->db->updateLedSettings($data)) {
                        $this->sendResponse(200, ['message' => 'LED settings updated']);
                    }
                }
                break;

            default:
                $this->sendResponse(404, ['error' => 'Endpoint not found']);
        }
    }
}

// Router'ı başlat
$router = new Router();
$router->run();
