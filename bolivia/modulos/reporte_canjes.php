<?php
if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

// Verificar permisos
if (!isset($_SESSION['user_id'])) {
    header('Location: login.php');
    exit;
}

// Incluir configuración
if (!isset($pdo)) {
    require_once __DIR__ . '/../config.php';
}

// Variables para los filtros
$fecha_desde = '';
$fecha_hasta = '';
$tipo_cupon = '';
$estado = '';
$canjes = [];
$stats = null;
$tipos = [];

// SOLO EJECUTAR CONSULTA SI SE PRESIONÓ EL BOTÓN FILTRAR
$filtrado = isset($_GET['btn_filtrar']);

if ($filtrado) {
    // Obtener filtros
    $fecha_desde = $_GET['fecha_desde'] ?? '';
    $fecha_hasta = $_GET['fecha_hasta'] ?? '';
    $tipo_cupon = $_GET['tipo_cupon'] ?? '';
    $estado = $_GET['estado'] ?? '';

    // Construir consulta
    $where = [];
    $params = [];

    if ($fecha_desde && $fecha_hasta) {
        $where[] = "DATE(u.fecha_uso) BETWEEN ? AND ?";
        $params[] = $fecha_desde;
        $params[] = $fecha_hasta;
    }

    if ($tipo_cupon) {
        $where[] = "c.tipo_cupon_id = ?";
        $params[] = $tipo_cupon;
    }

    if ($estado !== '') {
        if ($estado == '1') {
            $where[] = "c.estado = 1";
        } else {
            $where[] = "c.estado = 0";
        }
    }

    $where_clause = !empty($where) ? "WHERE " . implode(" AND ", $where) : "";

    // Consulta principal
    $sql = "SELECT u.*, c.codigo, c.descripcion as cupon_descripcion, 
            tc.nombre as tipo_cupon_nombre,
            u.cliente_nombre, u.cliente_ci, u.fecha_uso,
            u.observaciones
            FROM cupon_uso u
            LEFT JOIN cupones c ON u.cupon_id = c.id
            LEFT JOIN tipo_cupon tc ON c.tipo_cupon_id = tc.id
            {$where_clause}
            ORDER BY u.fecha_uso DESC";

    $stmt = $pdo->prepare($sql);
    $stmt->execute($params);
    $canjes = $stmt->fetchAll(PDO::FETCH_ASSOC);

    // Estadísticas
    $sql_stats = "SELECT 
        COUNT(*) as total_canjes,
        COUNT(DISTINCT u.cliente_id) as total_clientes,
        SUM(CASE WHEN tc.nombre LIKE '%vale%' OR tc.nombre LIKE '%producto%' THEN 1 ELSE 0 END) as vales,
        SUM(CASE WHEN tc.nombre LIKE '%gift%' OR tc.nombre LIKE '%regalo%' THEN 1 ELSE 0 END) as giftcards,
        SUM(CASE WHEN tc.nombre LIKE '%descuento%' OR tc.nombre LIKE '%off%' THEN 1 ELSE 0 END) as descuentos
        FROM cupon_uso u
        LEFT JOIN cupones c ON u.cupon_id = c.id
        LEFT JOIN tipo_cupon tc ON c.tipo_cupon_id = tc.id
        {$where_clause}";
    $stmt_stats = $pdo->prepare($sql_stats);
    $stmt_stats->execute($params);
    $stats = $stmt_stats->fetch(PDO::FETCH_ASSOC);
}

// Obtener tipos de cupón para filtro (siempre se cargan porque son pocos)
$tipos = $pdo->query("SELECT id, nombre FROM tipo_cupon WHERE estado = 1 ORDER BY nombre")->fetchAll(PDO::FETCH_ASSOC);
?>

<style>
    .reporte-container {
        background: white;
        border-radius: 10px;
        overflow: hidden;
        padding: 20px;
    }
    
    .filtros-section {
        background: #f8f9fa;
        padding: 20px;
        border-radius: 10px;
        margin-bottom: 25px;
    }
    
    .filtros-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
        gap: 15px;
        margin-bottom: 15px;
    }
    
    .filtro-group {
        display: flex;
        flex-direction: column;
    }
    
    .filtro-group label {
        font-size: 12px;
        font-weight: 600;
        color: #555;
        margin-bottom: 5px;
    }
    
    .filtro-group label.required {
        color: #c62828;
    }
    
    .filtro-group label.required::after {
        content: " *";
    }
    
    .filtro-group input,
    .filtro-group select {
        padding: 10px;
        border: 1px solid #ddd;
        border-radius: 6px;
        font-size: 14px;
    }
    
    .btn-filtrar {
        background: #D4AF37;
        color: #000;
        border: none;
        padding: 10px 25px;
        border-radius: 6px;
        cursor: pointer;
        font-weight: bold;
        margin-top: 24px;
        transition: 0.3s;
    }
    
    .btn-filtrar:hover {
        background: #b8941e;
    }
    
    .btn-limpiar {
        background: #6c757d;
        color: white;
        border: none;
        padding: 10px 25px;
        border-radius: 6px;
        cursor: pointer;
        font-weight: bold;
        margin-top: 24px;
        transition: 0.3s;
    }
    
    .btn-limpiar:hover {
        background: #5a6268;
    }
    
    .btn-excel {
        background: #28a745;
        color: white;
        border: none;
        padding: 10px 20px;
        border-radius: 5px;
        cursor: pointer;
        font-weight: bold;
    }
    
    .btn-excel:hover {
        background: #218838;
    }
    
    .stats-cards {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        gap: 20px;
        margin-bottom: 25px;
    }
    
    .stat-card {
        color: white;
        padding: 20px;
        border-radius: 10px;
        text-align: center;
    }
    
    .stat-card .number {
        font-size: 28px;
        font-weight: bold;
        margin: 10px 0;
    }
    
    .stat-card .label {
        font-size: 12px;
        opacity: 0.9;
    }
    
    .stat-card-verde {
        background: linear-gradient(135deg, #11998e, #38ef7d);
    }
    
    .stat-card-dorado {
        background: linear-gradient(135deg, #D4AF37, #f1c40f);
        color: #000;
    }
    
    .stat-card-azul {
        background: linear-gradient(135deg, #667eea, #764ba2);
    }
    
    .stat-card-naranja {
        background: linear-gradient(135deg, #f093fb, #f5576c);
    }
    
    .stat-card-cian {
        background: linear-gradient(135deg, #4facfe, #00f2fe);
        color: #000;
    }
    
    .table-responsive {
        overflow-x: auto;
    }
    
    .canjes-table {
        width: 100%;
        border-collapse: collapse;
    }
    
    .canjes-table th {
        background: #f8f9fa;
        padding: 12px;
        text-align: left;
        font-size: 12px;
        font-weight: 600;
        color: #555;
        border-bottom: 2px solid #dee2e6;
    }
    
    .canjes-table td {
        padding: 12px;
        border-bottom: 1px solid #eee;
        font-size: 13px;
    }
    
    .canjes-table tr:hover {
        background: #f8f9fa;
    }
    
    .codigo-cell {
        font-family: 'Courier New', monospace;
        font-weight: bold;
        font-size: 12px;
    }
    
    .badge {
        display: inline-block;
        padding: 3px 12px;
        border-radius: 12px;
        font-size: 11px;
        font-weight: bold;
    }
    
    .badge-vale {
        background: #e3f2fd;
        color: #0d47a1;
    }
    
    .badge-giftcard {
        background: #fce4ec;
        color: #880e4f;
    }
    
    .badge-descuento {
        background: #fff3e0;
        color: #e65100;
    }
    
    .btn-ver-template {
        background: #D4AF37;
        color: #000;
        border: none;
        padding: 5px 12px;
        border-radius: 4px;
        cursor: pointer;
        font-size: 11px;
        font-weight: bold;
    }
    
    .btn-ver-template:hover {
        background: #b8941e;
    }
    
    .alerta-filtros {
        background: #fff3cd;
        border: 1px solid #ffeeba;
        color: #856404;
        padding: 40px;
        border-radius: 10px;
        text-align: center;
        margin: 20px 0;
    }
    
    .alerta-filtros h3 {
        margin: 10px 0;
    }
    
    .alerta-filtros .icono-grande {
        font-size: 48px;
    }
    
    @media (max-width: 768px) {
        .filtros-grid {
            grid-template-columns: 1fr;
        }
        .stats-cards {
            grid-template-columns: 1fr;
        }
        .canjes-table {
            min-width: 800px;
        }
        .btn-filtrar, .btn-limpiar {
            width: 100%;
        }
    }
</style>

<div class="reporte-container">
    <h2 style="margin-top:0; color:#333; border-bottom: 2px solid #D4AF37; padding-bottom: 10px;">📊 Reporte de Canjes</h2>
    <p style="color:#666; margin-bottom:20px;">Selecciona fechas y aplica filtros para ver los resultados</p>
    
    <!-- Filtros -->
    <div class="filtros-section">
        <form method="GET" id="filtrosForm">
            <input type="hidden" name="mod" value="reporte_canjes">
            <div class="filtros-grid">
                <div class="filtro-group">
                    <label class="required">📅 Fecha Desde</label>
                    <input type="date" name="fecha_desde" value="<?php echo $fecha_desde; ?>">
                </div>
                <div class="filtro-group">
                    <label class="required">📅 Fecha Hasta</label>
                    <input type="date" name="fecha_hasta" value="<?php echo $fecha_hasta; ?>">
                </div>
                <div class="filtro-group">
                    <label>🏷️ Tipo de Cupón</label>
                    <select name="tipo_cupon">
                        <option value="">Todos</option>
                        <?php foreach ($tipos as $t): ?>
                            <option value="<?php echo $t['id']; ?>" <?php echo ($tipo_cupon == $t['id']) ? 'selected' : ''; ?>>
                                <?php echo htmlspecialchars($t['nombre']); ?>
                            </option>
                        <?php endforeach; ?>
                    </select>
                </div>
                <div class="filtro-group">
                    <label>📌 Estado</label>
                    <select name="estado">
                        <option value="">Todos</option>
                        <option value="1" <?php echo ($estado == '1') ? 'selected' : ''; ?>>Activos</option>
                        <option value="0" <?php echo ($estado == '0') ? 'selected' : ''; ?>>Anulados</option>
                    </select>
                </div>
                <div class="filtro-group" style="flex-direction: row; gap: 10px; align-items: end;">
                    <button type="submit" name="btn_filtrar" value="1" class="btn-filtrar">🔍 FILTRAR</button>
                    <a href="admin.php?mod=reporte_canjes" class="btn-limpiar">🔄 LIMPIAR</a>
                </div>
            </div>
        </form>
    </div>

    <?php if (!$filtrado): ?>
        <!-- Mensaje cuando no hay filtros -->
        <div class="alerta-filtros">
            <span class="icono-grande">🔍</span>
            <h3>Aplica filtros para ver los resultados</h3>
            <p>Selecciona una fecha de inicio y fecha fin para generar el reporte de canjes.</p>
        </div>
    <?php elseif (count($canjes) === 0): ?>
        <!-- Sin resultados -->
        <div class="alerta-filtros">
            <span class="icono-grande">📭</span>
            <h3>No hay canjes con los filtros seleccionados</h3>
            <p>Prueba con otros rangos de fecha o diferentes filtros.</p>
        </div>
    <?php else: ?>
        <!-- Estadísticas -->
        <div class="stats-cards">
            <div class="stat-card stat-card-verde">
                <div class="label">🎫 TOTAL CANJES</div>
                <div class="number"><?php echo number_format($stats['total_canjes'] ?? 0); ?></div>
            </div>
            <div class="stat-card stat-card-dorado">
                <div class="label">👥 CLIENTES ATENDIDOS</div>
                <div class="number"><?php echo number_format($stats['total_clientes'] ?? 0); ?></div>
            </div>
            <div class="stat-card stat-card-azul">
                <div class="label">🎁 VALES PRODUCTO</div>
                <div class="number"><?php echo number_format($stats['vales'] ?? 0); ?></div>
            </div>
            <div class="stat-card stat-card-naranja">
                <div class="label">💳 GIFT CARDS</div>
                <div class="number"><?php echo number_format($stats['giftcards'] ?? 0); ?></div>
            </div>
            <div class="stat-card stat-card-cian">
                <div class="label">🏷️ CUPONES DESCUENTO</div>
                <div class="number"><?php echo number_format($stats['descuentos'] ?? 0); ?></div>
            </div>
        </div>
        
        <!-- Botón Exportar Excel -->
        <div style="text-align: right; margin-bottom: 15px;">
            <button type="button" class="btn-excel" onclick="exportarExcel()">📊 EXPORTAR A EXCEL</button>
        </div>
        
        <!-- Tabla de Canjes -->
        <div class="table-responsive">
            <table class="canjes-table">
                <thead>
                    <tr>
                        <th>FECHA/HORA</th>
                        <th>CÓDIGO</th>
                        <th>TIPO</th>
                        <th>CLIENTE</th>
                        <th>CI</th>
                        <th>DESCRIPCIÓN</th>
                        <th>ACCIONES</th>
                    </tr>
                </thead>
                <tbody>
                    <?php foreach ($canjes as $canje): ?>
                        <tr>
                            <td><?php echo date('d/m/Y H:i', strtotime($canje['fecha_uso'])); ?></td>
                            <td class="codigo-cell"><?php echo $canje['codigo']; ?></td>
                            <td>
                                <span class="badge badge-vale">
                                    <?php echo $canje['tipo_cupon_nombre'] ?? 'N/A'; ?>
                                </span>
                            </td>
                            <td><strong><?php echo htmlspecialchars($canje['cliente_nombre']); ?></strong></td>
                            <td><?php echo $canje['cliente_ci']; ?></td>
                            <td style="font-size: 12px; max-width: 150px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
                                <?php echo $canje['cupon_descripcion'] ?: '-'; ?>
                            </td>
                            <td>
                                <button class="btn-ver-template" onclick="verTemplate(<?php echo $canje['cupon_id']; ?>)">
                                    👁️ VER VALE
                                </button>
                            </td>
                        </tr>
                    <?php endforeach; ?>
                </tbody>
            </table>
        </div>
    <?php endif; ?>
</div>

<script>
function verTemplate(cupon_id) {
    window.open('templates_cupones/ver_template.php?cupon_id=' + cupon_id + '&tipo=vale&modo=real', '_blank', 'width=400,height=650');
}

function exportarExcel() {
    const form = document.getElementById('filtrosForm');
    const inputs = form.querySelectorAll('input, select');
    let url = 'modulos/exportar_excel_canjes.php?';
    
    inputs.forEach(input => {
        if (input.name && input.value) {
            url += input.name + '=' + encodeURIComponent(input.value) + '&';
        }
    });
    url += 'exportar_excel=1';
    window.location.href = url;
}
</script>