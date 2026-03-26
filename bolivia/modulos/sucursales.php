<?php
include 'config.php';

// --- 1. LÓGICA DE PROCESAMIENTO ---

// A. GUARDAR (NUEVO O EDITAR)
if (isset($_POST['btn_guardar_suc'])) {
    $id = $_POST['id_sucursal'] ?? '';
    $nombre = $_POST['nombre'];
    $pais = $_POST['pais'];
    $direccion = $_POST['direccion'];
    $lat = $_POST['latitud'];
    $lng = $_POST['longitud'];
    $h_ape = $_POST['hora_apertura'];
    $h_cie = $_POST['hora_cierre'];

    if (empty($id)) {
        $sql = "INSERT INTO sucursales (nombre, pais, direccion, latitud, longitud, hora_apertura, hora_cierre, estado) 
                VALUES (?, ?, ?, ?, ?, ?, ?, 1)";
        $stmt = $pdo->prepare($sql);
        $stmt->execute([$nombre, $pais, $direccion, $lat, $lng, $h_ape, $h_cie]);
        $id = $pdo->lastInsertId();
        registrarLog($pdo, "INSERTAR_SUCURSAL", "Se creó la sucursal: $nombre");
    } else {
        $sql = "UPDATE sucursales SET nombre=?, pais=?, direccion=?, latitud=?, longitud=?, hora_apertura=?, hora_cierre=? WHERE id=?";
        $pdo->prepare($sql)->execute([$nombre, $pais, $direccion, $lat, $lng, $h_ape, $h_cie, $id]);
        registrarLog($pdo, "EDITAR_SUCURSAL", "Se actualizaron los datos de: $nombre (ID: $id)");

    }

    // --- MANEJO DE FOTOS ---
    if (!empty($_FILES['fotos']['name'][0])) {
        if (!is_dir('uploads/sucursales')) { mkdir('uploads/sucursales', 0777, true); }
        
        foreach ($_FILES['fotos']['tmp_name'] as $key => $tmp_name) {
            // Validación de lado del servidor por seguridad
            if ($_FILES['fotos']['size'][$key] <= 8 * 1024 * 1024) { 
                $filename = time() . "_" . $_FILES['fotos']['name'][$key];
                $ruta_destino = "uploads/sucursales/" . $filename;

                if (move_uploaded_file($tmp_name, $ruta_destino)) {
                    $sql_foto = "INSERT INTO sucursal_fotos (sucursal_id, ruta_foto, estado) VALUES (?, ?, 1)";
                    $pdo->prepare($sql_foto)->execute([$id, $ruta_destino]);
                }
            }
        }
    }
    echo "<script>window.location='admin.php?mod=sucursales';</script>";
}

// B. SOFT DELETE SUCURSAL
if (isset($_GET['del'])) {
    $pdo->prepare("UPDATE sucursales SET estado = 0 WHERE id = ?")->execute([$_GET['del']]);
    echo "<script>window.location='admin.php?mod=sucursales';</script>";
    registrarLog($pdo, "ELIMINAR_SUCURSAL", "Se eliminó la sucursal: $nombre (ID: ".$_GET['del'].")");
}

// C. ELIMINAR FOTO ESPECÍFICA
if (isset($_GET['del_foto'])) {
    $pdo->prepare("UPDATE sucursal_fotos SET estado = 0 WHERE id = ?")->execute([$_GET['del_foto']]);
    echo "<script>window.location='admin.php?mod=sucursales&edit=".$_GET['suc_id']."';</script>";
    registrarLog($pdo, "ELIMINAR_FOTO_SUCURSAL", "Se eliminó la foto de la sucursal: $nombre (ID: ".$_GET['suc_id'].")");
}

// D. DATOS PARA EDITAR
$s_edit = null;
$fotos_edit = [];
if (isset($_GET['edit'])) {
    $stmt = $pdo->prepare("SELECT * FROM sucursales WHERE id = ?");
    $stmt->execute([$_GET['edit']]);
    $s_edit = $stmt->fetch();

    $stmt_f = $pdo->prepare("SELECT * FROM sucursal_fotos WHERE sucursal_id = ? AND estado = 1");
    $stmt_f->execute([$_GET['edit']]);
    $fotos_edit = $stmt_f->fetchAll();
}

$sucursales = $pdo->query("SELECT * FROM sucursales WHERE estado = 1 ORDER BY id DESC")->fetchAll();
?>

<div style="background:#fff; padding:25px; border-radius:8px; border:1px solid #eee; margin-bottom:30px;">
    <h3><?php echo $s_edit ? "Editar Sucursal" : "Registrar Sucursal"; ?></h3>
    
    <div style="background: #fff8e1; padding: 10px; border-left: 4px solid #D4AF37; margin-bottom: 20px; font-size: 0.85em; color: #856404;">
        <strong>Información:</strong> Formatos permitidos: JPG, PNG. Tamaño máximo por foto: 8MB.
    </div>

    <form method="POST" enctype="multipart/form-data">
        <input type="hidden" name="id_sucursal" value="<?php echo $s_edit['id'] ?? ''; ?>">
        
        <div style="display:grid; grid-template-columns: 1fr 1fr 1fr; gap:15px;">
            <div>
                <label>Nombre</label>
                <input type="text" name="nombre" required value="<?php echo $s_edit['nombre'] ?? ''; ?>" style="width:100%; padding:8px;">
            </div>
            <div>
                <label>País</label>
                <select name="pais" style="width:100%; padding:8px;">
                    <option value="Bolivia" <?php echo (isset($s_edit['pais']) && $s_edit['pais'] == 'Bolivia') ? 'selected' : ''; ?>>Bolivia</option>
                    <option value="Paraguay" <?php echo (isset($s_edit['pais']) && $s_edit['pais'] == 'Paraguay') ? 'selected' : ''; ?>>Paraguay</option>
                    <option value="Brasil" <?php echo (isset($s_edit['pais']) && $s_edit['pais'] == 'Brasil') ? 'selected' : ''; ?>>Brasil</option>
                </select>
            </div>
            <div>
                <label>Dirección</label>
                <input type="text" name="direccion" value="<?php echo $s_edit['direccion'] ?? ''; ?>" style="width:100%; padding:8px;">
            </div>
            <div>
                <label>Latitud</label>
                <input type="text" name="latitud" placeholder="-17.7833" value="<?php echo $s_edit['latitud'] ?? ''; ?>" style="width:100%; padding:8px;">
            </div>
            <div>
                <label>Longitud</label>
                <input type="text" name="longitud" placeholder="-63.1821" value="<?php echo $s_edit['longitud'] ?? ''; ?>" style="width:100%; padding:8px;">
            </div>
            <div>
                <label>Horarios (Abre / Cierra)</label>
                <div style="display:flex; gap:5px;">
                    <input type="time" name="hora_apertura" value="<?php echo $s_edit['hora_apertura'] ?? ''; ?>" style="width:50%; padding:8px;">
                    <input type="time" name="hora_cierre" value="<?php echo $s_edit['hora_cierre'] ?? ''; ?>" style="width:50%; padding:8px;">
                </div>
            </div>
        </div>

        <div style="margin-top:20px; border: 2px dashed #D4AF37; padding: 20px; text-align: center; border-radius: 8px; background: #fafafa;">
            <label style="cursor:pointer; color: #000; font-weight: bold; display: block;">
                📷 Seleccionar Fotos
                <input type="file" id="input-fotos" name="fotos[]" multiple accept="image/jpeg, image/png" style="display:none;">
            </label>
            <div id="preview-nuevas" style="display:grid; grid-template-columns: repeat(auto-fill, minmax(100px, 1fr)); gap:10px; margin-top:15px;">
                </div>
        </div>

        <?php if($s_edit && !empty($fotos_edit)): ?>
            <p style="margin-top:20px; font-weight:bold;">Fotos actuales:</p>
            <div style="display:flex; gap:10px; flex-wrap: wrap;">
                <?php foreach($fotos_edit as $f): ?>
                    <div style="position:relative; border: 1px solid #ddd; padding: 2px; border-radius: 4px;">
                        <img src="<?php echo $f['ruta_foto']; ?>" width="80" height="60" style="object-fit:cover; border-radius: 2px;">
                        <a href="admin.php?mod=sucursales&del_foto=<?php echo $f['id']; ?>&suc_id=<?php echo $s_edit['id']; ?>" 
                           onclick="return confirm('¿Borrar foto definitivamente?')"
                           style="position:absolute; top:-8px; right:-8px; background:red; color:white; border-radius:50%; width:20px; height:20px; text-align:center; text-decoration:none; font-size:14px; line-height:20px; font-weight:bold;">×</a>
                    </div>
                <?php endforeach; ?>
            </div>
        <?php endif; ?>

        <div style="margin-top:30px;">
            <button type="submit" name="btn_guardar_suc" style="background:#000; color:#D4AF37; border:none; padding:12px 30px; border-radius:4px; cursor:pointer; font-weight:bold;">
                <?php echo $s_edit ? "ACTUALIZAR SUCURSAL" : "GUARDAR SUCURSAL"; ?>
            </button>
        </div>
    </form>
</div>

<table style="width:100%; border-collapse: collapse;">
    <thead>
        <tr style="background:#1a1a1a; color:#fff;">
            <th style="padding:12px;">Sucursal</th>
            <th>País</th>
            <th>Ubicación</th>
            <th>Horario</th>
            <th>Acciones</th>
        </tr>
    </thead>
    <tbody>
        <?php foreach ($sucursales as $s): ?>
        <tr style="border-bottom: 1px solid #eee;">
            <td style="padding:12px;"><strong><?php echo $s['nombre']; ?></strong></td>
            <td><?php echo $s['pais']; ?></td>
            <td style="font-size:12px; color:#666;"><?php echo $s['direccion']; ?></td>
            <td><?php echo $s['hora_apertura'] . " - " . $s['hora_cierre']; ?></td>
            <td>
                <a href="admin.php?mod=sucursales&edit=<?php echo $s['id']; ?>" style="background:#e3f2fd; color:#0d47a1; padding:5px 12px; border-radius:4px; text-decoration:none; font-size:12px; font-weight:bold; margin-right:5px;">Editar</a>
                <a href="admin.php?mod=sucursales&del=<?php echo $s['id']; ?>" onclick="return confirm('¿Eliminar sucursal?')" style="background:#ffebee; color:#c62828; padding:5px 12px; border-radius:4px; text-decoration:none; font-size:12px; font-weight:bold;">Borrar</a>
            </td>
        </tr>
        <?php endforeach; ?>
    </tbody>
</table>

<script>
document.getElementById('input-fotos').addEventListener('change', function() {
    const container = document.getElementById('preview-nuevas');
    const files = this.files;
    const maxSize = 8 * 1024 * 1024; // 8MB

    container.innerHTML = ''; // Limpiar previsualizaciones anteriores

    Array.from(files).forEach(file => {
        // Validar formato
        if (!['image/jpeg', 'image/png'].includes(file.type)) {
            alert(`El archivo ${file.name} no es válido. Solo se permiten JPG y PNG.`);
            return;
        }
        // Validar tamaño
        if (file.size > maxSize) {
            alert(`El archivo ${file.name} pesa más de 2MB.`);
            return;
        }

        // Crear previsualización
        const reader = new FileReader();
        reader.onload = function(e) {
            const div = document.createElement('div');
            div.style.cssText = "position:relative; border:1px solid #D4AF37; border-radius:4px; overflow:hidden; height:80px;";
            div.innerHTML = `
                <img src="${e.target.result}" style="width:100%; height:100%; object-fit:cover;">
                <div style="position:absolute; top:0; background:rgba(212,175,55,0.8); color:black; font-size:9px; padding:2px; font-weight:bold;">NUEVA</div>
            `;
            container.appendChild(div);
        }
        reader.readAsDataURL(file);
    });
});
</script>