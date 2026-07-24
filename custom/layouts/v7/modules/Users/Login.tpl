<!DOCTYPE html>
<html>
<head>
    <title>Gobo Tecnología - Software a medida</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
            background: linear-gradient(135deg, #0f2027, #203a43, #2c5364);
            color: #fff;
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
        }
        .login-container {
            background: rgba(255, 255, 255, 0.1);
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 8px 32px 0 rgba(0, 0, 0, 0.37);
            backdrop-filter: blur(8.5px);
            -webkit-backdrop-filter: blur(8.5px);
            border: 1px solid rgba(255, 255, 255, 0.18);
            width: 100%;
            max-width: 400px;
            text-align: center;
            box-sizing: border-box;
        }
        .logo {
            max-width: 150px;
            margin-bottom: 20px;
        }
        .title {
            font-size: 24px;
            margin-bottom: 30px;
            font-weight: 300;
        }
        .form-group {
            margin-bottom: 20px;
            text-align: left;
        }
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-size: 14px;
        }
        .form-group input {
            width: 100%;
            padding: 12px;
            border: none;
            border-radius: 5px;
            background: rgba(255, 255, 255, 0.2);
            color: #fff;
            outline: none;
            box-sizing: border-box;
        }
        .form-group input::placeholder {
            color: #ddd;
        }
        .btn-login {
            width: 100%;
            padding: 12px;
            border: none;
            border-radius: 5px;
            background: #007bff;
            color: #fff;
            font-size: 16px;
            cursor: pointer;
            transition: background 0.3s ease;
        }
        .btn-login:hover {
            background: #0056b3;
        }
        .footer {
            margin-top: 30px;
            font-size: 12px;
            color: #ccc;
            line-height: 1.5;
        }
        .footer a {
            color: #fff;
            text-decoration: none;
        }
        .footer a:hover {
            text-decoration: underline;
        }
        .error-message {
            background: rgba(255, 0, 0, 0.5);
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 20px;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <!-- Logo con fallback -->
        <img src="layouts/v7/skins/images/logo_gobo.png" alt="Gobo Logo" class="logo" onerror="this.onerror=null; this.src='layouts/v7/skins/images/logo.png';">
        
        <div class="title">Software a medida</div>
        
        {if $ERROR}
            <div class="error-message">{$ERROR}</div>
        {/if}
        
        <form method="post" action="index.php?module=Users&action=Login">
            <div class="form-group">
                <label for="username">Usuario</label>
                <input type="text" id="username" name="username" placeholder="Usuario" required autofocus>
            </div>
            <div class="form-group">
                <label for="password">Contraseña</label>
                <input type="password" id="password" name="password" placeholder="Contraseña" required>
            </div>
            <button type="submit" class="btn-login">Iniciar Sesión</button>
        </form>
        
        <div class="footer">
            Software a medida por <a href="https://gobo.com.co" target="_blank">Gobo Tecnología</a> | Powered by vtiger CRM 8.4.0 &copy; 2004 - 2026 | <a href="https://gobo.com.co" target="_blank">Política de Privacidad</a>
        </div>
    </div>
</body>
</html>
