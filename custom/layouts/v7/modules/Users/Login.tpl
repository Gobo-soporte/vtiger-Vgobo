{* Smarty *}
{* Custom Login - Gobo Tecnologia *}
<!DOCTYPE html>
<html>
<head>
    <title>CRM - {$COMPANY_DETAILS.companyname|default:'CRM'}</title>
    <link REL="SHORTCUT ICON" href="layouts/v7/skins/images/favicon.ico">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <script type="text/javascript" src="libraries/csrf-magic/csrf-magic.js"></script>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; min-height: 100vh; display: flex; flex-direction: column; align-items: center; justify-content: center; background: linear-gradient(135deg, #0a2810 0%, #145a28 40%, #1e8a3e 70%, #28b550 100%); }
        .login-wrapper { display: flex; align-items: center; justify-content: center; flex: 1; width: 100%; padding: 40px 20px; }
        .login-card { background: rgba(255,255,255,0.96); border-radius: 12px; padding: 48px 44px 36px; width: 100%; max-width: 420px; box-shadow: 0 20px 60px rgba(0,0,0,0.3); text-align: center; }
        .login-logo img { max-height: 80px; width: auto; margin-bottom: 8px; }
        .company-name { font-size: 14px; font-weight: 500; margin-bottom: 32px; color: #718096; }
        .form-group { margin-bottom: 24px; text-align: left; }
        .form-group input { width: 100%; padding: 14px 0; border: none; border-bottom: 2px solid #e2e8f0; font-size: 15px; outline: none; color: #2d3748; background: transparent; }
        .form-group input::placeholder { color: #a0aec0; }
        .form-group input:focus { border-bottom-color: #1e8a3e; }
        .btn-login { width: 100%; padding: 14px; background: #1e8a3e; color: white; border: none; border-radius: 6px; font-size: 15px; font-weight: 600; cursor: pointer; margin-top: 8px; }
        .btn-login:hover { background: #28b550; box-shadow: 0 4px 15px rgba(30,138,62,0.4); }
        .forgot-password { text-align: left; margin-top: 16px; }
        .forgot-password a { color: #1e8a3e; font-size: 13px; text-decoration: none; }
        .forgot-password a:hover { text-decoration: underline; }
        .login-error { background: #fed7d7; color: #9b2c2c; padding: 10px 16px; border-radius: 6px; font-size: 13px; margin-bottom: 20px; }
        .login-footer { text-align: center; padding: 20px; color: rgba(255,255,255,0.7); font-size: 11px; line-height: 2; }
        .login-footer a { color: rgba(255,255,255,0.9); text-decoration: none; }
        .login-footer a:hover { text-decoration: underline; }
        @media (max-width: 480px) { .login-card { padding: 36px 24px 28px; margin: 0 16px; } }
    </style>
</head>
<body>
    <div class="login-wrapper">
        <div class="login-card">
            <div class="login-logo">
                {if $COMPANY_DETAILS.logoname}
                    <img src="storage/Logo/{$COMPANY_DETAILS.logoname}" alt="{$COMPANY_DETAILS.companyname}">
                {else}
                    <img src="layouts/v7/skins/images/logo.png" alt="CRM">
                {/if}
            </div>
            <div class="company-name">{$COMPANY_DETAILS.companyname|default:''}</div>
            {if $ERROR}<div class="login-error">{$ERROR}</div>{/if}
            <form action="index.php" method="POST">
                <input type="hidden" name="module" value="Users">
                <input type="hidden" name="action" value="Login">
                <input type="hidden" name="return_module" value="Users">
                <input type="hidden" name="return_action" value="Login">
                <div class="form-group"><input type="text" name="user_name" id="username" placeholder="Usuario" autocomplete="username" required></div>
                <div class="form-group"><input type="password" name="user_password" placeholder="Contrasena" autocomplete="current-password" required></div>
                <button type="submit" class="btn-login">Iniciar sesion</button>
                <div class="forgot-password"><a href="index.php?module=Users&view=ForgotPassword">Olvidaste tu contrasena?</a></div>
            </form>
        </div>
    </div>
    <footer class="login-footer">
        Software a medida por <a href="https://www.gobo.com.co/" target="_blank"><strong>Gobo Tecnologia</strong></a><br>
        Powered by vtiger CRM 8.4.0 &copy; 2004 - 2026 | <a href="https://www.gobo.com.co/" target="_blank">Gobo Tecnologia</a>
    </footer>
    <script>document.getElementById('username').focus();</script>
</body>
</html>
