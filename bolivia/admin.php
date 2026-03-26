<?php
// Iniciamos sesión (importante para un panel admin)
session_start();
// include 'config.php'; // Descomenta esto cuando tengas la conexión lista
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Admin | Pollo El Solar</title>
    <style>
        :root { --sidebar-width: 250px; --gold: #D4AF37; --dark: #1a1a1a; }
        body { margin: 0; display: flex; font-family: 'Segoe UI', sans-serif; background: #f4f4f4; color: #333; }
        
        /* Sidebar */
        .sidebar { width: var(--sidebar-width); background: var(--dark); height: 100vh; color: #fff; position: fixed; box-shadow: 2px 0 5px rgba(0,0,0,0.1); }
        .sidebar h3 { padding: 30px 20px; text-align: center; border-bottom: 1px solid #333; color: var(--gold); margin: 0; font-size: 1.2em; letter-spacing: 1px; }
        .sidebar a { display: block; color: #bbb; padding: 15px 25px; text-decoration: none; transition: 0.3s; font-size: 0.95em; }
        .sidebar a:hover { background: #333; color: var(--gold); padding-left: 35px; }
        .sidebar a.active { background: #222; color: #fff; border-left: 4px solid var(--gold); }
        
        /* Contenido Principal */
        .main-content { margin-left: var(--sidebar-width); padding: 40px; width: calc(100% - var(--sidebar-width)); min-height: 100vh; box-sizing: border-box; }
        
        /* Tarjeta Blanca donde carga el CRUD */
        .table-card { background: #fff; padding: 30px; border-radius: 8px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); }
        
        /* Estilos generales para las tablas que carguen dentro */
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { text-align: left; padding: 15px; border-bottom: 1px solid #eee; }
        th { background: #fcfcfc; color: #666; text-transform: uppercase; font-size: 0.8em; }
        tr:hover { background: #f9f9f9; }
        
        .btn-add { background: #000; color: #fff; padding: 10px 20px; text-decoration: none; border-radius: 4px; font-size: 0.9em; display: inline-block; margin-bottom: 20px; transition: 0.3s; }
        .btn-add:hover { background: var(--gold); color: #000; }
    </style>
</head>
<body>

<div class="sidebar">
    <img src="../fotos/logito.png" alt="logo solar" style="display:block; margin:20px auto; width:150px;">
    <a href="?mod=productos">🍗 Productos</a>
    <a href="?mod=categorias">📂 Categorías</a>
    <a href="?mod=sucursales">📍 Sucursales</a>
    <a href="?mod=usuarios">👥 Usuarios</a>
    <a href="?mod=logs">📜 Logs de Actividad</a>
    <a href="logout.php" style="margin-top: 50px; color: #ff6b6b; border-top: 1px solid #333;">Cerrar Sesión</a>
</div>

<div class="main-content">
    <div class="table-card">
        <?php
        // 1. Detectamos el módulo desde la URL (?mod=nombre)
        $modulo = $_GET['mod'] ?? 'usuarios'; // Por defecto muestra usuarios
        
        // 2. Título dinámico
        echo "<h2 style='margin-top:0;'>Gestión de " . ucfirst($modulo) . "</h2>";
        echo "<hr style='border: 0; border-top: 1px solid #eee; margin-bottom: 25px;'>";

        // 3. Incluimos el archivo del CRUD
        $archivo = "modulos/" . $modulo . ".php";
        
        if (file_exists($archivo)) {
            include $archivo;
        } else {
            echo "<div style='padding:20px; background:#fff3cd; color:#856404; border-radius:5px;'>
                    ⚠️ El archivo <b>$archivo</b> no ha sido creado todavía.
                  </div>";
        }
        ?>
    </div>
</div>

</body>
</html>