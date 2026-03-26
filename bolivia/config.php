<?php
$host = 'localhost';
$db   = 'solar_web';
$user = 'root';
$pass = '';
$charset = 'utf8mb4';

$dsn = "mysql:host=$host;dbname=$db;charset=$charset";
$options = [
    PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    PDO::ATTR_EMULATE_PREPARES   => false,
];

try {
    $pdo = new PDO($dsn, $user, $pass, $options);
} catch (\PDOException $e) {
    throw new \PDOException($e->getMessage(), (int)$e->getCode());
}


function registrarLog($pdo, $accion, $detalle) {
    // Si aún no tienes el login listo, usamos el ID 1 (Admin) por defecto
    $usuario_id = $_SESSION['user_id'] ?? 1; 
    $ip = $_SERVER['REMOTE_ADDR'];
    
    // No incluimos created_at porque tu DB lo pone solo
    $sql = "INSERT INTO logs_actividad (usuario_id, accion, detalle, ip_address) 
            VALUES (?, ?, ?, ?)";
    $stmt = $pdo->prepare($sql);
    $stmt->execute([$usuario_id, $accion, $detalle, $ip]);
}
?>