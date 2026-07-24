{* Smarty *}
{* Custom Login – Gobo Tecnología *}
{* Reemplaza: layouts/v7/modules/Users/Login.tpl *}

<!DOCTYPE html>
<html>
<head>
    <title>{$MODULE} - {$COMPANY_DETAILS.companyname|default:'Gobo Tecnología'}</title>
    <link REL="SHORTCUT ICON" href="layouts/v7/skins/images/favicon.ico">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link type="text/css" rel="stylesheet" href="layouts/v7/lib/todc/css/bootstrap.min.css">
    <link type="text/css" rel="stylesheet" href="layouts/v7/lib/todc/css/todc-bootstrap.min.css">
    <link type="text/css" rel="stylesheet" href="layouts/v7/lib/font-awesome/css/font-awesome.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, #0a1628 0%, #1a365d 40%, #2d5a87 70%, #4a90b8 100%);
            background-attachment: fixed;
        }

        .login-wrapper {
            display: flex;
            align-items: center;
            justify-content: center;
            flex: 1;
            width: 100%;
            padding: 40px 20px;
        }

        .login-card {
            background: rgba(255, 255, 255, 0.97);
            border-radius: 16px;
            padding: 48px 40px 36px;
            width: 100%;
            max-width: 420px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3), 0 0 0 1px rgba(255, 255, 255, 0.1);
        }

        .login-logo {
            text-align: center;
            margin-bottom: 32px;
        }

        .login-logo img {
            max-height: 60px;
            width: auto;
        }

        .login-logo h2 {
            color: #1a365d;
            font-size: 18px;
            font-weight: 600;
            margin-top: 12px;
            letter-spacing: 0.5px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            color: #4a5568;
            font-size: 13px;
            font-weight: 500;
            margin-bottom: 6px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .form-group input {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid #e2e8f0;
            border-radius: 8px;
            font-size: 15px;
            transition: all 0.2s ease;
            outline: none;
            color: #2d3748;
        }

        .form-group input:focus {
            border-color: #2d5a87;
            box-shadow: 0 0 0 3px rgba(45, 90, 135, 0.15);
        }

        .btn-login {
            width: 100%;
            padding: 13px;
            background: linear-gradient(135deg, #1a365d, #2d5a87);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s ease;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-top: 8px;
        }

        .btn-login:hover {
            background: linear-gradient(135deg, #2d5a87, #4a90b8);
            box-shadow: 0 4px 15px rgba(45, 90, 135, 0.4);
            transform: translateY(-1px);
        }

        .forgot-password {
            text-align: center;
            margin-top: 16px;
        }

        .forgot-password a {
            color: #718096;
            font-size: 13px;
            text-decoration: none;
        }

        .forgot-password a:hover {
            color: #2d5a87;
        }

        .login-error {
            background: #fed7d7;
            color: #9b2c2c;
            padding: 10px 16px;
            border-radius: 8px;
            font-size: 13px;
            margin-bottom: 20px;
            text-align: center;
            display: none;
        }

        .login-footer {
            text-align: center;
            padding: 20px;
            color: rgba(255, 255, 255, 0.6);
            font-size: 12px;
            line-height: 1.8;
        }

        .login-footer a {
            color: rgba(255, 255, 255, 0.8);
            text-decoration: none;
        }

        .login-footer a:hover {
            color: #ffffff;
            text-decoration: underline;
        }

        .login-footer .powered {
            color: rgba(255, 255, 255, 0.4);
            font-size: 11px;
        }

        @media (max-width: 480px) {
            .login-card {
                padding: 36px 24px 28px;
                margin: 0 16px;
            }
        }
    </style>
</head>
<body>

    <div class="login-wrapper">
        <div class="login-card">
            <div class="login-logo">
                <img src="layouts/v7/skins/images/logo_gobo.png" alt="Gobo Tecnología"
                     onerror="this.src='layouts/v7/skins/images/logo.png'">
                <h2>Software a medida</h2>
            </div>

            <div class="login-error" id="loginError">
                {if $ERROR}
                    <script>document.getElementById('loginError').style.display='block';</script>
                    {$ERROR}
                {/if}
            </div>

            <form action="index.php" method="POST" id="loginForm">
                <input type="hidden" name="module" value="Users">
                <input type="hidden" name="action" value="Login">
                <input type="hidden" name="return_module" value="Users">
                <input type="hidden" name="return_action" value="Login">

                <div class="form-group">
                    <label for="username">Usuario</label>
                    <input type="text" id="username" name="user_name"
                           placeholder="Ingrese su usuario" autocomplete="username" required>
                </div>

                <div class="form-group">
                    <label for="password">Contraseña</label>
                    <input type="password" id="password" name="user_password"
                           placeholder="Ingrese su contraseña" autocomplete="current-password" required>
                </div>

                <button type="submit" class="btn-login">Iniciar Sesión</button>

                <div class="forgot-password">
                    <a href="index.php?module=Users&view=ForgotPassword">¿Olvidó su contraseña?</a>
                </div>
            </form>
        </div>
    </div>

    <footer class="login-footer">
        Software a medida por <a href="https://www.gobo.com.co/" target="_blank"><strong>Gobo Tecnología</strong></a>
        <br>
        <span class="powered">Powered by vtiger CRM 8.4.0 &copy; 2004 - 2026</span>
        &nbsp;|&nbsp;
        <a href="https://www.gobo.com.co/" target="_blank">Política de Privacidad</a>
    </footer>

    <script>
        document.getElementById('username').focus();
    </script>
</body>
</html>
