<?php
// exportar_excel.php
if (session_status() === PHP_SESSION_NONE) {
    session_start();
}
include 'config.php';

header('Content-Type: application/vnd.ms-excel');
header('Content-Disposition: attachment; filename="reporte_ventas_' . date('Y-m-d') . '.xls"');

echo "<table border='1'>";
echo "<tr><th>ID</th><th>Fecha</th><th>Sucursal</th><th>Cliente</th><th>Productos</th><th>Total</th><th>Método Pago</th></tr>";

$ventas = $pdo->query("SELECT v.*, s.nombre as sucursal_nombre, c.nombre as cliente_nombre 
                       FROM ventas v 
                       LEFT JOIN sucursales s ON v.sucursal_id = s.id 
                       LEFT JOIN clientes c ON v.cliente_id = c.id 
                       WHERE DATE(v.fecha_venta) = CURDATE() 
                       ORDER BY v.id DESC");

foreach($ventas as $v) {
    // Obtener productos de la venta
    $stmt = $pdo->prepare("SELECT p.nombre, vd.cantidad FROM venta_detalle vd JOIN productos p ON vd.producto_id = p.id WHERE vd.venta_id = ?");
    $stmt->execute([$v['id']]);
    $productos = $stmt->fetchAll();
    $productos_str = implode(", ", array_map(function($item) {
        return $item['nombre'] . " x" . $item['cantidad'];
    }, $productos));
    
    echo "<tr>";
    echo "<td>{$v['id']}</td>";
    echo "<td>{$v['fecha_venta']}</td>";
    echo "<td>{$v['sucursal_nombre']}</td>";
    echo "<td>" . ($v['cliente_nombre'] ?? 'Mostrador') . "</td>";
    echo "<td>$productos_str</td>";
    echo "<td>" . number_format($v['total'], 2) . "</td>";
    
    // Método de pago
    $stmt = $pdo->prepare("SELECT mp.nombre FROM venta_pagos vp JOIN metodos_pago mp ON vp.metodo_pago_id = mp.id WHERE vp.venta_id = ?");
    $stmt->execute([$v['id']]);
    $pagos = $stmt->fetchAll();
    echo "<td>" . implode(", ", array_column($pagos, 'nombre')) . "</td>";
    echo "</tr>";
}
echo "</table>";
?>