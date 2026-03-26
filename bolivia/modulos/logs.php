<?php
include 'config.php';

// Traemos los logs y el nombre del usuario que lo hizo
$sql = "SELECT l.*, u.usuario as nick 
        FROM logs_actividad l 
        LEFT JOIN usuarios u ON l.usuario_id = u.id 
        ORDER BY l.created_at DESC LIMIT 100";
$logs = $pdo->query($sql)->fetchAll();
?>

<div style="background:#fff; padding:20px; border-radius:8px; border:1px solid #eee;">
    <h2 style="margin-top:0; color:#333;">📜 Historial de Actividad</h2>
    <table style="width:100%; border-collapse: collapse; font-size:14px;">
        <thead>
            <tr style="background:#000; color:#D4AF37; text-align:left;">
                <th style="padding:12px;">Fecha/Hora</th>
                <th>Usuario</th>
                <th>Acción</th>
                <th>Detalle</th>
                <th>IP</th>
            </tr>
        </thead>
        <tbody>
            <?php foreach ($logs as $l): ?>
            <tr style="border-bottom: 1px solid #eee;">
                <td style="padding:10px; color:#888;"><?php echo $l['created_at']; ?></td>
                <td><strong><?php echo $l['nick'] ?? 'Sistema'; ?></strong></td>
                <td>
                    <span style="font-weight:bold; color: <?php 
                        echo (strpos($l['accion'], 'ELIMINAR') !== false) ? 'red' : 'green'; 
                    ?>">
                        <?php echo $l['accion']; ?>
                    </span>
                </td>
                <td><?php echo $l['detalle']; ?></td>
                <td style="font-family:monospace; color:#aaa;"><?php echo $l['ip_address']; ?></td>
            </tr>
            <?php endforeach; ?>
        </tbody>
    </table>
</div>