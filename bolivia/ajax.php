<?php
// --- CONFIGURACIÓN DE ERRORES ---
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

// --- INICIAR SESIÓN ---
if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

// --- INCLUIR CONFIGURACIÓN ---
require_once 'config.php';

// --- VERIFICAR QUE $pdo EXISTA ---
if (!isset($pdo)) {
    echo json_encode(['success' => false, 'message' => 'Error de conexión a la base de datos']);
    exit;
}

// --- MANEJAR PETICIONES ---

// BUSCAR CUPÓN
if (isset($_GET['buscar_cupon'])) {
    header('Content-Type: application/json');
    header('Cache-Control: no-cache, must-revalidate');
    
    try {
        $codigo = trim($_GET['buscar_cupon']);
        if (empty($codigo)) {
            throw new Exception("Código vacío");
        }
        
        $sql = "SELECT c.*, tc.nombre as tipo_nombre 
                FROM cupones c 
                LEFT JOIN tipo_cupon tc ON c.tipo_cupon_id = tc.id 
                WHERE c.codigo = ? AND c.estado = 1 AND c.usado = 0";
        $stmt = $pdo->prepare($sql);
        $stmt->execute([$codigo]);
        $cupon = $stmt->fetch(PDO::FETCH_ASSOC);
        
        if (!$cupon) {
            echo json_encode(['success' => false, 'message' => 'Cupón no encontrado, inactivo o ya usado']);
            exit;
        }
        
        // VERIFICAR VIGENCIA
        $fecha_actual = date('Y-m-d H:i:s');
        $vigente = true;
        $mensaje = '';
        
        if ($fecha_actual > $cupon['fecha_expiracion']) {
            $vigente = false;
            $mensaje = 'Cupón expirado';
        } elseif ($fecha_actual < $cupon['fecha_inicio']) {
            $vigente = false;
            $mensaje = 'Cupón no vigente aún';
        }
        
        echo json_encode([
            'success' => true,
            'cupon' => $cupon,
            'vigente' => $vigente,
            'mensaje' => $mensaje
        ]);
        exit;
        
    } catch (Exception $e) {
        echo json_encode(['success' => false, 'message' => 'Error: ' . $e->getMessage()]);
        exit;
    }
}

// BUSCAR CLIENTE
if (isset($_GET['buscar_cliente'])) {
    header('Content-Type: application/json');
    header('Cache-Control: no-cache, must-revalidate');
    
    try {
        $ci = trim($_GET['buscar_cliente']);
        if (empty($ci)) {
            throw new Exception("CI vacío");
        }
        
        $stmt = $pdo->prepare("SELECT id, nombre, documento, telefono, email FROM clientes WHERE documento = ? AND estado = 1");
        $stmt->execute([$ci]);
        $cliente = $stmt->fetch(PDO::FETCH_ASSOC);
        
        if ($cliente) {
            echo json_encode(['success' => true, 'cliente' => $cliente]);
        } else {
            echo json_encode(['success' => false, 'message' => 'Cliente no encontrado']);
        }
        exit;
        
    } catch (Exception $e) {
        echo json_encode(['success' => false, 'message' => 'Error: ' . $e->getMessage()]);
        exit;
    }
}

// Si no hay parámetros válidos
echo json_encode(['success' => false, 'message' => 'Solicitud inválida']);
exit;
?>