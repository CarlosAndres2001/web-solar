<link rel="stylesheet" href="assets/css/footer.css">
<style>
.footer {
    background: #111;
    color: #ccc;
    padding: 50px 40px 20px;
}

.footer-grid {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 40px;
}

.footer h2 {
    color: var(--secondary);
}

.footer h4 {
    color: white;
    margin-bottom: 10px;
}

.footer a {
    display: block;
    text-decoration: none;
    color: #bbb;
    margin-bottom: 6px;
}

.footer a:hover {
    color: var(--secondary);
}

.footer-bottom {
    text-align: center;
    margin-top: 30px;
    border-top: 1px solid #333;
    padding-top: 10px;
}

/* MOBILE */
@media (max-width: 768px) {
    .footer-grid {
        grid-template-columns: 1fr;
        text-align: center;
    }
}
</style>
<footer class="footer">
    <div class="footer-grid">

        <div>
            <h2>🍗 Pollo El Solar</h2>
            <p>El mejor pollo broaster de Bolivia, hecho con amor para tu familia.</p>
        </div>

        <div>
            <h4>Explorar</h4>
            <a href="#">Inicio</a>
            <a href="#">Menú</a>
            <a href="#">Promos</a>
        </div>

        <div>
            <h4>Contacto</h4>
            <p>📍 Santa Cruz</p>
            <p>📞 70000000</p>
        </div>

    </div>

    <div class="footer-bottom">
        © <?php echo date('Y'); ?> Pollo El Solar
    </div>
</footer>