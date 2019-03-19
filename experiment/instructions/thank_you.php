<?php
session_start();
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Repeated choice</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <link rel="stylesheet" href="../style/style.css">
    <script>
        function set_payment_code(){
            var code_element = document.getElementById("payment_id");
            code_element.innerHTML = Math.round(Math.random()*1000000).toString() + "317" + <?php echo $_SESSION["total_reward"]?> ;
        }
    </script>
</head>
<body onload="set_payment_code()">

<nav class="navbar navbar-inverse">
    <div class="container-fluid">
        <div class="navbar-header">
            <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#myNavbar">
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            <a class="navbar-brand" href="">Repeated choice</a>
        </div>
        <div class="collapse navbar-collapse" id="myNavbar">
            <ul class="nav navbar-nav">
                <li class="inactive_nav">(1) Instructions</li>
                <li class="inactive_nav">(2) Task</li>
                <li class="active_nav">(3) Collect payment</li>
                <li id="filler">(4) filler </li>
            </ul>
            <ul class="nav navbar-nav navbar-right">
            </ul>
        </div>
    </div>
</nav>

<div class="container-fluid text-center">
    <div class="row content">
        <!--sidebar on the left-->
        <div class="col-sm-2 sidenav">
            <!--<p><a href="#">Link</a></p>-->
            <!--<p><a href="#">Link</a></p>-->
            <!--<p><a href="#">Link</a></p>-->
        </div>
        <div class="col-sm-8 text-left">
            <h1>Thank you for your participation</h1>
            <hr>
            <p>
                Insert the following code to collect your payment at Amazon Mechanical Turk:
            </p>
            <br>
            <h3 id="payment_id"></h3>
            <p>
                You can close this window now.
            </p>
        </div>
        <div class="col-sm-2 sidenav">
            <!--<div class="well">-->
            <!--<p>ADS</p>-->
            <!--</div>-->
            <!--<div class="well">-->
            <!--<p>ADS</p>-->
            <!--</div>-->
        </div>
    </div>
</div>

<footer class="container-fluid text-center">
    <!--<p>Footer Text</p>-->
    <p> </p>
</footer>


</body>
</html>