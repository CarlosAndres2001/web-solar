<?php include 'navbar.php'; ?>
<title>Home | Pollo El Solar</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" href="styles.css">

<!-- HERO -->
<section class="hero">
    <div class="hero-content">
        <h1>El sabor que realmente <span>CRUJE</span></h1>
        <p>Pollo broaster cruceño, dorado, jugoso y lleno de tradición.</p>
        <a href="#" class="btn-primary">Ver Menú</a>
    </div>
</section>

<!-- MÉTRICAS -->
<section class="metrics">
    <div class="metric">
        <h2 class="counter" data-target="15000">0</h2>
        <p>Clientes felices</p>
    </div>
    <div class="metric">
        <h2 class="counter" data-target="8">0</h2>
        <p>Sucursales</p>
    </div>
    <div class="metric">
        <h2 class="counter" data-target="12">0</h2>
        <p>Años de experiencia</p>
    </div>
</section>

<!-- PRODUCTOS -->
<section class="container">
    <h2 class="section-title">🔥 Nuestros Favoritos</h2>

    <div class="grid-products">

        <div class="product-card">
            <div class="badge">Top 🔥</div>
            <img src="img/pollo1.jpg">
            <div class="product-info">
                <h3>Cuarto de Pollo</h3>
                <p>Papas crocantes + arroz con queso.</p>
                <span>Bs. 35</span>
            </div>
        </div>

        <div class="product-card">
            <img src="img/pollo2.jpg">
            <div class="product-info">
                <h3>Alitas Picantes</h3>
                <p>Para los que aguantan el verdadero picante.</p>
                <span>Bs. 40</span>
            </div>
        </div>

        <div class="product-card">
            <img src="img/pollo3.jpg">
            <div class="product-info">
                <h3>Económico Solar</h3>
                <p>Rico, rápido y barato.</p>
                <span>Bs. 20</span>
            </div>
        </div>

    </div>
</section>

<!-- PROMO -->
<section class="promo">
    <div class="promo-content">
        <h2>🔥 Promo del Mes</h2>
        <p>Prueba nuestra <strong>Yuca Frita Especial</strong> GRATIS en combos familiares.</p>
        <a href="#" class="btn-secondary">Aprovechar Oferta</a>
    </div>
</section>

<!-- MERCH -->
<section class="container">
    <h2 class="section-title">El Solar Style</h2>

    <div class="grid-merch">
        <div class="merch-item">
            <img src="img/gorra.jpg">
            <h4>Gorra Solar</h4>
        </div>
        <div class="merch-item">
            <img src="img/polera.jpg">
            <h4>Polera Oficial</h4>
        </div>
    </div>
</section>

<!-- POR QUÉ ELEGIRNOS -->
<section class="why">
    <div class="container">
        <h2 class="section-title">¿Por qué elegirnos?</h2>

        <div class="why-grid">
            <div class="why-item">
                <h3>🍗 Sabor único</h3>
                <p>Receta secreta que engancha.</p>
            </div>
            <div class="why-item">
                <h3>👨‍👩‍👧 Familiar</h3>
                <p>Ambiente cómodo y acogedor.</p>
            </div>
            <div class="why-item">
                <h3>⚡ Rápido</h3>
                <p>Te atendemos en minutos.</p>
            </div>
        </div>
    </div>
</section>

<script>
const counters = document.querySelectorAll('.counter');

counters.forEach(counter => {
    const updateCount = () => {
        const target = +counter.getAttribute('data-target');
        const count = +counter.innerText;
        const increment = target / 150;

        if (count < target) {
            counter.innerText = Math.ceil(count + increment);
            setTimeout(updateCount, 10);
        } else {
            counter.innerText = target;
        }
    };
    updateCount();
});
</script>

<?php include 'footer.php'; ?>