<style>
:root {
    --primary: #c62828;
    --secondary: #ffcc00;
    --dark: #1a1a1a;
    --light: #ffffff;
}

/* HEADER */
.header {
    position: sticky;
    top: 0;
    background: var(--light);
    box-shadow: 0 3px 12px rgba(0,0,0,0.08);
    z-index: 1000;
}

.nav-wrapper {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 15px 40px;
}

/* LOGO */
.logo {
    display: flex;
    align-items: center;
    gap: 10px;
    font-weight: bold;
    color: var(--primary);
    font-size: 20px;
}

.logo img {
    height: 45px;
}

/* MENU */
.nav-menu {
    display: flex;
    gap: 30px;
}

.nav-menu a {
    text-decoration: none;
    color: var(--dark);
    font-weight: 500;
    position: relative;
}

/* EFECTO SUBRAYADO */
.nav-menu a::after {
    content: "";
    position: absolute;
    bottom: -5px;
    left: 0;
    width: 0%;
    height: 3px;
    background: var(--secondary);
    transition: 0.3s;
}

.nav-menu a:hover::after {
    width: 100%;
}

/* BOTON PEDIR */
.btn-order {
    background: var(--primary);
    color: white;
    padding: 10px 18px;
    border-radius: 25px;
    text-decoration: none;
    font-weight: bold;
    transition: 0.3s;
}

.btn-order:hover {
    background: #a81e1e;
}

/* MENU MOBILE */
.menu-toggle {
    display: none;
    font-size: 22px;
    cursor: pointer;
}

/* RESPONSIVE */
@media (max-width: 768px) {

    .nav-menu {
        position: absolute;
        top: 70px;
        right: 0;
        background: white;
        width: 220px;
        flex-direction: column;
        padding: 20px;
        display: none;
        box-shadow: 0 5px 15px rgba(0,0,0,0.2);
    }

    .nav-menu.active {
        display: flex;
    }

    .menu-toggle {
        display: block;
    }

    .btn-order {
        display: none;
    }
}
</style>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<header class="header">
    <div class="nav-wrapper">

        <!-- LOGO -->
        <div class="logo">
            <img src="img/logito.png" alt="Pollo El Solar">
            <span></span>
        </div>

        <!-- MENU -->
        <nav class="nav-menu" id="navMenu">
            <a href="indexbo.php">Inicio</a>
            <a href="menu.php">Menú</a>
            <a href="sucursal.php">Sucursales</a>
            <a href="promos.php">Promos</a>
            <a href="contacto.php">Contacto</a>
        </nav>

        <!-- CTA -->
        <a href="#" class="btn-order">
            <i class="fas fa-shopping-cart"></i> Pedir ahora
        </a>

        <!-- HAMBURGUESA -->
        <div class="menu-toggle" onclick="toggleMenu()">
            <i class="fas fa-bars"></i>
        </div>

    </div>
</header>

<script>
function toggleMenu() {
    document.getElementById('navMenu').classList.toggle('active');
}
</script>