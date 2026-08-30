{strip}
{literal}
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@tabler/icons-webfont@3/dist/tabler-icons.min.css">
<style>
* { margin: 0; padding: 0; box-sizing: border-box; -webkit-font-smoothing: antialiased; -moz-osx-font-smoothing: grayscale; }
html, body {
    height: 100vh !important;
    height: 100dvh !important;
    width: 100vw !important;
    font-family: "Segoe UI", system-ui, -apple-system, "Helvetica Neue", Roboto, Arial, sans-serif;
    background-color: #ffffff;
    overflow: hidden !important;
    margin: 0 !important;
    padding: 0 !important;
}
.split-container {
    display: flex;
    height: 100vh;
    height: 100dvh;
    width: 100vw;
    position: fixed;
    top: 0;
    left: 0;
    z-index: 999999;
    background: #ffffff;
    overflow: hidden;
}
.left-panel {
    width: 45%;
    max-width: 520px;
    height: 100vh;
    height: 100dvh;
    background: #ffffff;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    padding: clamp(24px, 5vw, 40px) clamp(20px, 6vw, 55px);
    z-index: 10;
    box-shadow: 10px 0 30px rgba(0, 0, 0, 0.03);
    overflow-y: auto;
}
.login-card { width: 100%; max-width: 360px; }
.logo-container { margin-bottom: 38px; text-align: center; display: flex; justify-content: center; align-items: center; }
.logo-container img { max-width: 340px; max-height: 150px; width: auto; height: auto; display: block; margin: 0 auto; }
.form-group { margin-bottom: 20px; text-align: left; }
.form-group label { display: block; font-size: 13px; font-weight: 600; color: #64748b; margin-bottom: 6px; }
.form-group input { font-size: 14px; padding: 10px 2px; display: block; width: 100%; border: none; border-bottom: 2px solid #e2e8f0; border-radius: 0; outline: none; color: #1e293b; background: transparent; transition: all 0.25s ease; }
.form-group input:focus { border-bottom-color: #62b330; background: transparent; box-shadow: none; }
.btn-login { width: 100%; padding: 14px; background-color: #62b330; color: #ffffff; border: none; border-radius: 10px; font-size: 15px; font-weight: 600; cursor: pointer; transition: all 0.2s ease; margin-top: 10px; box-shadow: 0 4px 14px rgba(98, 179, 48, 0.28); }
.btn-login:hover { background-color: #529828; transform: translateY(-1px); box-shadow: 0 6px 18px rgba(98, 179, 48, 0.35); }
.forgot-link { display: block; text-align: center; margin-top: 18px; font-size: 13px; color: #62b330; text-decoration: none; font-weight: 600; cursor: pointer; }
.forgot-link:hover { text-decoration: underline; }
.failureMessage { background-color: #fef2f2; color: #dc2626; border: 1px solid #fecaca; padding: 10px; border-radius: 8px; font-size: 13px; margin-bottom: 20px; display: block; text-align: center; }
.form-title { font-size: 25px; font-weight: 700; color: #0f172a; margin-bottom: 24px; text-align: center; }

#gobo-custom-footer {
    position: absolute;
    bottom: 18px;
    left: 0;
    right: 0;
    width: 100%;
    text-align: center;
    color: #64748b;
    font-size: 12px;
    line-height: 1.6;
    z-index: 20;
    pointer-events: auto;
}
#gobo-custom-footer strong { color: #334155; font-weight: bold; }
#gobo-custom-footer a { color: #62b330; text-decoration: none; font-weight: 600; margin: 0 4px; }
#gobo-custom-footer a:hover { text-decoration: underline; }

.right-panel {
    flex: 1;
    height: 100vh;
    background: linear-gradient(160deg, #ffffff 0%, #fdfefc 45%, #f6faf3 100%);
    position: relative;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    padding: 40px;
    overflow: hidden;
}

/* Zona de decoracion con relacion de aspecto fija: todo dentro (circulos, badges,
   logo) se posiciona en % de esta caja, asi la composicion se mantiene identica
   en cualquier resolucion, solo escala. */
.decoration-scope {
    position: relative;
    width: 100%;
    max-width: 900px;
    aspect-ratio: 900 / 580;
    margin: 0 auto;
}

.floating-circle { position: absolute; border-radius: 50%; pointer-events: none; z-index: 1; animation: floatAnim 8s ease-in-out infinite alternate; }
.bg-green { background-color: #62b330; }
.bg-dark { background-color: #1a1a1a; }

/* Badges con tamano fluido (clamp) para que nunca se toquen entre si,
   incluso cuando la zona de decoracion se achica en pantallas medianas */
.badge-icon {
    position: absolute;
    width: clamp(38px, 6vw, 62px);
    height: clamp(38px, 6vw, 62px);
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    pointer-events: none;
    z-index: 1;
    box-shadow: 0 6px 14px rgba(0,0,0,0.08);
    animation: floatAnim 10s ease-in-out infinite alternate-reverse;
}
.badge-icon i { color: #ffffff; font-size: clamp(16px, 2.6vw, 26px); }

@keyframes floatAnim { 0% { transform: translateY(0px); } 100% { transform: translateY(-12px); } }

.right-content {
    text-align: center;
    max-width: 460px;
    width: 100%;
    margin: 0 auto;
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    z-index: 5;
    background: transparent;
    padding: 0;
}
.gobo-logo { max-width: min(300px, 32vw); max-height: 160px; width: auto; height: auto; display: block; margin: 0 auto; padding: 18px 26px; background: radial-gradient(circle, rgba(255,255,255,0.55) 0%, rgba(255,255,255,0) 70%); filter: drop-shadow(0 8px 16px rgba(15, 23, 42, 0.10)); animation: goboFadeIn 0.8s ease forwards; }
.gobo-accent-line {
    width: 36px;
    height: 3px;
    background: #62b330;
    border-radius: 2px;
    margin: 14px auto 16px;
    animation: goboFadeIn 0.8s ease 0.1s forwards;
    opacity: 0;
}
.gobo-tagline {
    font-size: 14px;
    line-height: 1.7;
    color: #64748b;
    text-align: center;
    max-width: 380px;
    margin: 0 auto;
    animation: goboFadeIn 0.8s ease 0.2s forwards;
    opacity: 0;
}
.gobo-tagline strong { color: #3B6D11; font-weight: 600; }
.hide { display: none !important; }

@keyframes goboFadeIn { from { opacity: 0; transform: scale(0.95); } to { opacity: 1; transform: scale(1); } }
footer, .footer, .vt-footer, div.footer, span.app-nav, hr, .app-footer { display: none !important; }

/* Tablet / laptop chico: reducimos un poco mas los badges */
@media (max-width: 1200px) {
    .badge-icon { width: clamp(34px, 5.2vw, 52px); height: clamp(34px, 5.2vw, 52px); }
    .badge-icon i { font-size: clamp(14px, 2.2vw, 22px); }
}

/* Tablets en general: el panel izquierdo puede necesitar mas ancho relativo */
@media (max-width: 1024px) and (min-width: 901px) {
    .left-panel { width: 50%; max-width: 460px; }
}

/* Movil: se oculta el panel derecho, solo el formulario, a pantalla completa */
@media (max-width: 900px) {
    .right-panel { display: none; }
    .left-panel {
        width: 100%;
        max-width: 100%;
        box-shadow: none;
        padding-left: max(24px, env(safe-area-inset-left));
        padding-right: max(24px, env(safe-area-inset-right));
        padding-top: max(24px, env(safe-area-inset-top));
        padding-bottom: max(24px, env(safe-area-inset-bottom));
    }
}

/* Moviles muy angostos (iPhone SE, gama baja Android) */
@media (max-width: 380px) {
    .logo-container img { max-width: 220px; max-height: 100px; }
    .form-title { font-size: 21px; }
    .btn-login { padding: 12px; font-size: 14px; }
}

/* Pantallas bajas en altura (landscape en movil, notebooks chicos) */
@media (max-height: 620px) {
    .logo-container { margin-bottom: 18px; }
    .logo-container img { max-height: 80px; }
    .form-group { margin-bottom: 12px; }
}

/* Pantallas grandes / 4K: limitamos el crecimiento maximo */
@media (min-width: 1800px) {
    .decoration-scope { max-width: 1000px; }
}
</style>
{/literal}

<div class="split-container">
    <div class="left-panel">
        <div class="login-card">
            <div class="logo-container">
                <img src="layouts/v7/resources/Images/tecnosalud.png" alt="Tecnosalud" onerror="this.style.display='none';">
            </div>
            {if isset($LOGIN_FAIL)}
                <div class="failureMessage">{$LOGIN_FAIL.message}</div>
            {/if}
            <div id="loginFormDiv">
                <form method="POST" action="index.php">
                    <input type="hidden" name="module" value="Users"/>
                    <input type="hidden" name="action" value="Login"/>
                    <div class="form-group">
                        <label for="username">Usuario</label>
                        <input id="username" type="text" name="username" placeholder="Ingresa tu usuario" required autocomplete="username">
                    </div>
                    <div class="form-group">
                        <label for="password">Contraseña</label>
                        <input id="password" type="password" name="password" placeholder="Ingresa tu contraseña" required autocomplete="current-password">
                    </div>
                    <button type="submit" class="btn-login">Ingresar</button>
                    <a id="toForgotPassword" class="forgot-link">¿Olvidaste tu contraseña?</a>
                </form>
            </div>
            <div id="forgotPasswordDiv" class="hide">
                <h2 class="form-title">Restablecer contraseña</h2>
                <form action="forgotPassword.php" method="POST">
                    <div class="form-group">
                        <label for="fusername">Usuario</label>
                        <input id="fusername" type="text" name="username" placeholder="Ingresa tu usuario" required>
                    </div>
                    <div class="form-group">
                        <label for="email">Correo electrónico</label>
                        <input id="email" type="email" name="emailId" placeholder="Ingresa tu correo registrado" required>
                    </div>
                    <button type="submit" class="btn-login">Enviar instrucciones</button>
                    <a id="toLogin" class="forgot-link">Volver al inicio de sesión</a>
                </form>
            </div>
        </div>
    </div>

    <div class="right-panel">
        <div class="decoration-scope">
            <!-- Circulos decorativos: cada uno junto a un badge pero desplazado hacia afuera,
                 nunca sobre el mismo punto que otro circulo o badge -->
            <div class="floating-circle" style="width:4.4%; height:6.8%; background:rgba(98,179,48,0.55); top:0%; left:2%;"></div>
            <div class="floating-circle" style="width:3%; height:4.6%; background:rgba(26,26,26,0.3); top:17%; left:18%;"></div>
            <div class="floating-circle" style="width:5.2%; height:8%; background:rgba(98,179,48,0.25); top:-2%; left:34%;"></div>
            <div class="floating-circle" style="width:3.4%; height:5.2%; background:rgba(98,179,48,0.5); top:-1%; right:32%;"></div>
            <div class="floating-circle" style="width:4.2%; height:6.5%; background:rgba(26,26,26,0.15); top:17%; right:0%;"></div>
            <div class="floating-circle" style="width:5.6%; height:8.6%; background:rgba(98,179,48,0.18); bottom:22%; left:0%;"></div>
            <div class="floating-circle" style="width:3%; height:4.6%; background:rgba(26,26,26,0.3); bottom:-2%; left:18%;"></div>
            <div class="floating-circle" style="width:3.6%; height:5.6%; background:rgba(98,179,48,0.5); bottom:17%; right:18%;"></div>
            <div class="floating-circle" style="width:4.2%; height:6.5%; background:rgba(26,26,26,0.15); bottom:-2%; right:0%;"></div>

            <!-- 8 badges con Tabler Icons, en anillo alrededor del logo, todos fuera de la franja central 32%-68% -->
            <div class="badge-icon bg-green" style="top:10%; left:8%;">
                <i class="ti ti-chart-bar"></i>
            </div>
            <div class="badge-icon bg-dark" style="top:2%; left:26%;">
                <i class="ti ti-trending-up"></i>
            </div>
            <div class="badge-icon bg-green" style="top:2%; right:26%;">
                <i class="ti ti-headset"></i>
            </div>
            <div class="badge-icon bg-dark" style="top:10%; right:8%;">
                <i class="ti ti-shield-check"></i>
            </div>
            <div class="badge-icon bg-dark" style="bottom:10%; left:8%;">
                <i class="ti ti-database"></i>
            </div>
            <div class="badge-icon bg-green" style="bottom:2%; left:26%;">
                <i class="ti ti-mail"></i>
            </div>
            <div class="badge-icon bg-dark" style="bottom:2%; right:26%;">
                <i class="ti ti-users"></i>
            </div>
            <div class="badge-icon bg-green" style="bottom:10%; right:8%;">
                <i class="ti ti-refresh"></i>
            </div>

            <div class="right-content">
                <img src="layouts/v7/resources/Images/logo-color-v3.png" alt="Gobo Tecnologia" class="gobo-logo" onerror="this.onerror=null; this.src='layouts/v7/resources/Images/LOGO_GOBO_COLOR_FONDO_NEGRO.png';">
                <div class="gobo-accent-line"></div>
                <p class="gobo-tagline"><strong>CRM inteligente</strong>, desarrollo web y soporte técnico confiable para que tu empresa crezca y opere sin interrupciones.</p>
            </div>
        </div>

        <div id="gobo-custom-footer">
            Software a medida por <strong>Gobo Tecnologia</strong> &mdash; Powered by vtiger CRM 8.4.0 &copy; 2004 - 2026
            <a href="https://www.gobo.com.co/" target="_blank">Gobo Tecnologia</a> |
            <a href="https://www.gobo.com.co/" target="_blank">Privacy Policy</a>
        </div>
    </div>
</div>

{literal}
<script type="text/javascript">
document.addEventListener("DOMContentLoaded", function() {
    var toForgot = document.getElementById('toForgotPassword');
    var toLog    = document.getElementById('toLogin');
    if (toForgot) {
        toForgot.addEventListener('click', function() {
            document.getElementById('loginFormDiv').classList.add('hide');
            document.getElementById('forgotPasswordDiv').classList.remove('hide');
        });
    }
    if (toLog) {
        toLog.addEventListener('click', function() {
            document.getElementById('forgotPasswordDiv').classList.add('hide');
            document.getElementById('loginFormDiv').classList.remove('hide');
        });
    }
});
</script>
{/literal}
{/strip}
