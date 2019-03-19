function get_current_trial_rewards(side_chosen) {
    var xmlHttp = new XMLHttpRequest();
    xmlHttp.onreadystatechange = function() {
        if (xmlHttp.readyState == 4 && xmlHttp.status == 200)
            rewards_arrived(xmlHttp.responseText);
    }
    xmlHttp.open("GET", "scripts/backend.php?side="+side_chosen+"&RT="+RT, true); // true for asynchronous
    xmlHttp.send();

}

function rewards_arrived(reward){
    show_feedback(Number(reward));
}