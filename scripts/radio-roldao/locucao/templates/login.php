<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <link rel="stylesheet" type="text/css" media="all"  href="<?php print $baseUrl; ?>/css/cascade/development/build-full.css" />
        <link rel="stylesheet" type="text/css" media="all"  href="<?php print $baseUrl; ?>/css/azul/jquery-ui.css" />
        <link rel="stylesheet" type="text/css" media="all"  href="<?php print $baseUrl; ?>/css/azul/jquery-ui.structure.css" />
        <link rel="stylesheet" type="text/css" media="all"  href="<?php print $baseUrl; ?>/css/azul/jquery-ui.structure.css" />
        <link rel="stylesheet" type="text/css" media="all"  href="<?php print $baseUrl; ?>/css/azul/jquery-ui.theme.css" />
        <link rel="stylesheet" type="text/css" media="all"  href="<?php print $baseUrl; ?>/css/jquery-ui-timepicker-addon.css" />
        <link rel="stylesheet" type="text/css" media="all"  href="<?php print $baseUrl; ?>/css/tooltipster.css" />
        <link rel="stylesheet" type="text/css" media="all"  href="<?php print $baseUrl; ?>/css/themes/tooltipster-shadow.css" />
        <link rel="stylesheet" type="text/css" media="all"  href="<?php print $baseUrl; ?>/css/select2.css" />
        <link rel="stylesheet" type="text/css" media="all"  href="<?php print $baseUrl; ?>/css/css2.css<?php print $cacheControl; ?>" />

        <!--[if lt IE 8]><link rel="stylesheet" href="<?php print $baseUrl; ?>/css/cascade/production/icons-ie7.min.css"><![endif]-->
        <!--[if lt IE 9]><script src="<?php print $baseUrl; ?>/js/shim/iehtmlshiv.js"></script><![endif]-->
        <title>Sistema</title>
        <meta name="description" content="Professional Frontend framework that makes building websites easier than ever.">
        <link rel="shortcut icon" href="<?php print $baseUrl; ?>/img/favicon.ico" type="image/x-icon" />
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <?php if(isset($data['reload'])): ?>
        <meta http-equiv="refresh" content="<?php print $data['reload']; ?>">
        <?php endif; ?>

    </head>
    <body class="page-login">

      <div class="site-center">


          <div class="cell login">
            <form accept-charset="UTF-8" action="<?php print $data['baseUrl']; ?>/login" method="POST" class="form-horizontal form-signin">    
                <div class="control-group">
                  <img src="<?php print $baseUrl; ?>/img/site/logo_login.png" />
                </div>
                <!-- username field -->
                <div class="control-group">
                  <div class="controls username">
                    <label class="control-label" for="username"><span class="icon icon-user"></span></label>
                    <input type="text" id="username" value="" name="username" placeholder="Login">
                  </div>
                </div>
                <!-- password field -->
                <div class="control-group">
                  <div class="controls password">
                    <label class="control-label" for="password"><span class="icon icon-lock"></label>
                    <input type="password" id="password" name="password" placeholder="Senha">
                  </div>
                  <!-- check for login errors flash var -->
                </div>
                <!-- submit button -->
                <div class="control-group">
                  
                  <div class="controls">
                    <button type="submit" class="btn">ACESSAR</button>      </div>
                </div>
                <p class="text-error"><?php print $flash['erro-senha']; ?></p>

            </form>
            <div class="login-bar"></div>
          </div>

        <?php include('footer-contato.php'); ?>
      </div>

    </body>
</html>