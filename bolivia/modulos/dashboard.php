<?php
// dashboard.php
if (session_status() === PHP_SESSION_NONE) {
    session_start();
}


// Ventas de hoy
$hoy = date('Y-m-d');
$stmt = $pdo->prepare("SELECT COUNT(*) as total_ventas, SUM(total) as monto_total FROM ventas WHERE DATE(fecha_venta) = ? AND estado = 1");
$stmt->execute([$hoy]);
$ventas_hoy = $stmt->fetch();

// Ventas por día de la semana (últimos 7 días)
$stmt = $pdo->prepare("SELECT DATE(fecha_venta) as fecha, COUNT(*) as cantidad, SUM(total) as total 
                       FROM ventas 
                       WHERE fecha_venta >= DATE_SUB(NOW(), INTERVAL 7 DAY) AND estado = 1
                       GROUP BY DATE(fecha_venta) 
                       ORDER BY fecha DESC");
$ventas_semana = $stmt->fetchAll();

// Top productos
$stmt = $pdo->prepare("SELECT p.nombre, SUM(vd.cantidad) as total_vendido 
                       FROM venta_detalle vd 
                       JOIN productos p ON vd.producto_id = p.id 
                       JOIN ventas v ON vd.venta_id = v.id 
                       WHERE DATE(v.fecha_venta) = ? 
                       GROUP BY p.id 
                       ORDER BY total_vendido DESC 
                       LIMIT 5");
$stmt->execute([$hoy]);
$top_productos = $stmt->fetchAll();
?>

<style>
    .dashboard-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
        gap: 20px;
        margin-bottom: 30px;
    }
    .card {
        background: white;
        padding: 20px;
        border-radius: 12px;
        text-align: center;
        box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    }
    .card h1 { font-size: 48px; margin: 10px 0; color: #D4AF37; }
    .chart-container {
        background: white;
        padding: 20px;
        border-radius: 12px;
        margin-bottom: 20px;
    }
    .btn-excel {
        background: #28a745;
        color: white;
        padding: 10px 20px;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        margin-bottom: 20px;
    }
    @media (max-width: 768px) {
        .card h1 { font-size: 32px; }
        .dashboard-grid { gap: 10px; }
    }
</style>

<div style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; margin-bottom: 20px;">
    <h2>📊 Dashboard de Ventas</h2>
    <button onclick="exportarExcel()" class="btn-excel">📎 Exportar a Excel</button>
</div>

<div class="dashboard-grid">
    <div class="card">
        <h3>💰 Ventas Hoy</h3>
        <h1><?php echo number_format($ventas_hoy['monto_total'] ?? 0, 2); ?> BOB</h1>
        <small><?php echo $ventas_hoy['total_ventas'] ?? 0; ?> transacciones</small>
    </div>
    <div class="card">
        <h3>🛒 Ticket Promedio</h3>
        <h1><?php echo number_format(($ventas_hoy['monto_total'] ?? 0) / max(1, ($ventas_hoy['total_ventas'] ?? 1)), 2); ?> BOB</h1>
        <small>por venta</small>
    </div>
    <div class="card">
        <h3>📈 Mejor Producto</h3>
        <h1 style="font-size: 24px;"><?php echo htmlspecialchars($top_productos[0]['nombre'] ?? 'N/A'); ?></h1>
        <small><?php echo $top_productos[0]['total_vendido'] ?? 0; ?> unidades hoy</small>
    </div>
</div>

<div class="chart-container">
    <h3>📅 Ventas Últimos 7 Días</h3>
    <canvas id="ventasChart" style="max-height: 300px; width: 100%;"></canvas>
</div>

<div class="chart-container">
    <h3>🏆 Top 5 Productos del Día</h3>
    <canvas id="productosChart" style="max-height: 300px; width: 100%;"></canvas>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
// Gráfico de ventas semanales
const ctx1 = document.getElementById('ventasChart').getContext('2d');
new Chart(ctx1, {
    type: 'line',
    data: {
        labels: <?php echo json_encode(array_reverse(array_column($ventas_semana, 'fecha'))); ?>,
        datasets: [{
            label: 'Ventas (BOB)',
            data: <?php echo json_encode(array_reverse(array_column($ventas_semana, 'total'))); ?>,
            borderColor: '#D4AF37',
            backgroundColor: 'rgba(212, 175, 55, 0.1)',
            tension: 0.4,
            fill: true
        }]
    },
    options: { responsive: true, maintainAspectRatio: true }
});

// Gráfico de top productos
const ctx2 = document.getElementById('productosChart').getContext('2d');
new Chart(ctx2, {
    type: 'bar',
    data: {
        labels: <?php echo json_encode(array_column($top_productos, 'nombre')); ?>,
        datasets: [{
            label: 'Unidades Vendidas',
            data: <?php echo json_encode(array_column($top_productos, 'total_vendido')); ?>,
            backgroundColor: '#D4AF37',
            borderRadius: 5
        }]
    },
    options: { responsive: true, maintainAspectRatio: true, indexAxis: 'y' }
});

function exportarExcel() {
    window.location.href = 'exportar_excel.php';
}
</script>