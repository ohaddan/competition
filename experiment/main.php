<?php
session_start();
//**********************************************************************************************************************
// This is the main file which runs the experiment, it also initiates and defines the parameters of the game
//**********************************************************************************************************************

// Assign worker ID in some way (here: currentTime_randNumber
$_SESSION['user_id'] = strval(time()) . "_" . strval(rand(1, 100));

// Rewards and choices loggers
$_SESSION['is_bias_choice'] = array();
$_SESSION['bias_rewards'] = array();
$_SESSION['unbias_rewards'] = array();

// Choose reward assignment type
$TYPE_DYNAMIC = "DYNAMIC";
$TYPE_STATIC = "STATIC";
$_SESSION['schedule_type'] = $TYPE_STATIC;

// Choose specific sequence (from the "sequences" folder)
$_SESSION['schedule_name'] = "random_0";

// Choose Right/Left buttons as biased/anti-biased side
if (rand(1,2)==1){
    $_SESSION[$biased_side] = "LEFT";
    $_SESSION[$unbiased_side] = "RIGHT";
}
else{
    $_SESSION[$biased_side] = "RIGHT";
    $_SESSION[$unbiased_side] = "LEFT";
}

// Init game
$_SESSION['trial_number'] = 0;
$_SESSION["total_reward"] = 0;

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
    <link rel="stylesheet" href="style/style.css">
    <script src="scripts/backend_interaction.js"></script>
    <script src="scripts/code.js"></script>

</head>
<body onload="init_page()">

<nav class="navbar navbar-inverse">
    <div class="container-fluid">
        <div class="navbar-header">
            <span class="navbar-brand">Repeated choice</span>
        </div>
        <div class="collapse navbar-collapse" id="myNavbar">
            <ul class="nav navbar-nav">
                <li class="inactive_nav">(1) Instructions</li>
                <li class="active_nav">(2) Task</li>
                <li class="inactive_nav">(3) Collect payment</li>
                <li id="filler">(4) filler </li>
            </ul>
            <ul class="nav navbar-nav navbar-right">
            </ul>
        </div>
    </div>
</nav>

<div class="container-fluid text-center">
    <div class="row content">
        <div class="col-sm-2 sidenav justify_text" id="please_choose_text">
            <br>
            <p>
                Please choose between the two buttons.
            </p>
            <p>
                Your goal is to collect as many smiley faces as possible.
            </p>
        </div>
        <div class="col-sm-8 text-center centered_content" id="button_table">
            <table style="width:80%">
                <tr>
                    <th></th>
                    <th></th>
                    <th></th>
                </tr>

                <tr> <!--Here the image is displayed-->
                    <th>
                        <button type="button" class="btn btn-default button_left" id="button_left" onclick="left_button_clicked()"></button>
                    </th>
                    <!--Seperator-->
                    <th id="feedback_placeholder"> </th>
                    <th>
                        <button type="button" class="btn btn-default button_right" id="button_right" onclick="right_button_clicked()"></button>
                    </th>
                </tr>

                <tr >
                </tr>
                <tr class="counter">
                    <th> </th>
                    <th>
                        <p>Total reward collected:</p><div id="total_reward">0</div>
                    </th>
                    <th> </th>
            </table>
        </div>
        <div class="col-sm-2 sidenav" id="reward_holder">

        </div>
    </div>
</div>

<footer class="container-fluid text-center" id="text_left">
    <!--<p>Footer Text</p>-->
    <p>
        <div id="trials_left"></div> trials left.
    </p>
</footer>

</body>
</html>