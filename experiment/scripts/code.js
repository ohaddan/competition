////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Global variables and constants- used across the page\execution
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
var SHOW_ELEMENT_CLASS = "show_element";
var HIDE_ELEMENT_CLASS = "hide_element";
var FEEDBACK_TIME = 1500;

var trial_number = 0;

var RIGHT = 'RIGHT';
var LEFT = 'LEFT';

var NUMBER_OF_TRIALS = 100;

var choice_intervals = [];
var prev_click_time;
var current_click_time;

var total_rewards = 0;
var RT; //Reaction time
prev_click_time = Date.now();

var IMG_HEIGHT = "50%";
var IMG_WIDTH = "30%";
var IMG_HEIGHT = "50px";
var IMG_WIDTH = "50px";

var should_feedback_displayed_now = false;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Helper functions
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/** Helper functions -- start**/

var FEEDBACK_IMG_ID = "feedback_image";
function import_jQuery(){
    /**
     * Import JQuery
     */
    var script = document.createElement('script');
    script.src = 'http://code.jquery.com/jquery-1.11.0.min.js';
    script.type = 'text/javascript';
    document.getElementsByTagName('head')[0].appendChild(script);
}
import_jQuery();


function create_image_node(image_url) {
    /**
     * Return a new DOM image node containing the image specified by image_url
     * @type {HTMLElement}
     */
    var node = document.createElement("IMG");
    node.setAttribute("src", image_url);
    node.setAttribute("width", IMG_WIDTH);
    node.setAttribute("height", IMG_HEIGHT);
    node.setAttribute("id", FEEDBACK_IMG_ID);
    return node;
}
function create_enabler_button(){
    /**
     * Enabler button at the bottom of the screen, on which subjects should click to move forward between trials.
     */
    var btn = document.createElement("BUTTON");
    btn.setAttribute("class", "btn btn-default");
    btn.setAttribute("onclick", "show_two_buttons()");
    btn.setAttribute("id", "enabler_button");
    var text_node_press_to = document.createTextNode("Press to");
    var break_node = document.createElement("br");
    var text_node_cont = document.createTextNode("continue");
    btn.appendChild(text_node_press_to);
    btn.appendChild(break_node);
    btn.appendChild(text_node_cont);
    return btn;
}

function set_counter_text(n){
    /**
     * Set the text of the "tiral counter" at the bottom of the screen
     */
    var trials_node = document.getElementById("trials_left");
    trials_node.textContent = n;
}

function add_class_to_node(node, class_to_add) {
    /**
     * Add class_to_add to the classes of input ndoe
     */
    var classes = node.className;
    var classes_added = classes + " " + class_to_add;
    node.className = classes_added;
}

function add_class_to_node_whose_class(node_class, class_to_add){
    /**
     * Add class_to_add to the list of classes of all the elements whose current classes include node_class
     * @type {NodeList}
     */
    var nodes_list_of_class = document.getElementsByClassName(node_class);
    for (var i = 0; i < nodes_list_of_class.length; i++) {
        add_class_to_node(nodes_list_of_class[i], class_to_add);
    }
}

function remove_class_from_node(node, class_to_remove){
    var classes = node.className;
    var classes_removed = classes.replace(new RegExp(class_to_remove,'g'),''); // g - for global, replace all occurrences
    node.className = classes_removed;
}

function remove_class_from_node_whose_class(node_class, class_to_remove){
    /**
     * Add class_to_add to the list of classes to all elements whose current classes include node_class
     * @type {NodeList}
     */
    var nodes_list_of_class = document.getElementsByClassName(node_class);
    for (var i = 0; i < nodes_list_of_class.length; i++) {
        remove_class_from_node(nodes_list_of_class[i], class_to_remove);
    }
}

function get_array_of_n_values(n, value) {
    /**
     * Helper function - return a list with n items whose values are all the input value
     * @type {Array}
     */

    var arr = [];
    for(var i=0; i<n; i++){
        arr.push(value);
    }
    return arr;
}
/** Helper functions -- end**/


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Initialize page - a list of function that should be executed when the page is loaded:
//      1. Choose color for buttons on left and right
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/** Init page -- start**/
function init_page(){
    /**
     * Call a list of functions that should be executed when the page is loaded.
     */
    color_buttons_differently();
    hide_all_buttons();
    feedback_display_father = document.getElementById("feedback_placeholder");
    show_two_buttons();
    set_counter_text(NUMBER_OF_TRIALS);
}
/** Init page -- start**/

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Set the color of either the left or right buttons on random to some color
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/** Set color -- start**/
var RIGHT_BUTTON_CLASS = "button_right";
var LEFT_BUTTON_CLASS = "button_right";

function color_buttons_differently() {
    /**
     * This function randomly sets the color of both buttons.
     */
    if (Math.random() > 0.5){
        add_class_to_node_whose_class("button_right", "blue_border");
        add_class_to_node_whose_class("button_left", "red_border");
    }
    else{
        add_class_to_node_whose_class("button_left", "blue_border");
        add_class_to_node_whose_class("button_right", "red_border");
    }
}

/** Set color -- end**/

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// When either of the buttons are pressed, both should disappear and reaper after a specific time
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/** Button control -- start**/

function hide_all_buttons(){
    /**
     * Hide both buttons
     */
    remove_class_from_node_whose_class("btn", SHOW_ELEMENT_CLASS);
    add_class_to_node_whose_class("btn", HIDE_ELEMENT_CLASS);
}

function show_two_buttons() {
    /**
     * Assumes buttons are now hidden.
     */
    if (feedback_display_father.contains(enabler_button)){
        feedback_display_father.removeChild(enabler_button);
    }

    var show_items_ids = ["button_left", "button_right"];
    for(var i=0; i<show_items_ids.length;i++){
        var node = document.getElementById(show_items_ids[i]);
        remove_class_from_node(node, HIDE_ELEMENT_CLASS);
        add_class_to_node(node, SHOW_ELEMENT_CLASS);
    }
}

function show_middle_enabler_button(){
    feedback_display_father.appendChild(enabler_button);
}

function button_clicked(){
    /**
     * Procedures to execute each time either of the buttons is pressed
     */
    should_feedback_displayed_now = true;
    current_click_time = Date.now();
    RT = current_click_time - prev_click_time;
    choice_intervals.push(current_click_time - prev_click_time);
    prev_click_time = current_click_time;
    if (trial_number==NUMBER_OF_TRIALS){ //-1 because trial_number is advanced after this function
        show_goodbye_message();
    }
    else {
        hide_all_buttons();
        setTimeout(hide_feedback, FEEDBACK_TIME);
        setTimeout(show_middle_enabler_button, FEEDBACK_TIME);
    }
    set_counter_text(NUMBER_OF_TRIALS-trial_number-1); //-1 because first trial is 0
    trial_number++;
}

function left_button_clicked(){
    /**
     * Procedures to execute each time the left button is is pressed
     */
    button_clicked();
    get_current_trial_rewards("LEFT");

}

function right_button_clicked(){
    /**
     * Procedures to execute each time the right button is is pressed
     */
    button_clicked();
    get_current_trial_rewards("RIGHT");
}

/** Button control -- end**/
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Feedback management - following every choice a feedback should be displayed, visualizing the reward
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/** Feedback management -- start**/

var feedback_yes_img = create_image_node('media/positive_feedback.png');
var feedback_no_img = create_image_node('media/negative_feedback.png');
var feedback_display_father;
var display_image; // The image that will be currently displayed.
var enabler_button = create_enabler_button();

function show_total_rewards(){
    /**
     * Update the reward counter on screen
     */
    var total_reward_node = document.getElementById("total_reward");
    total_reward_node.textContent = total_rewards;
}

function add_smiley_to_screen(){
    /**
     * Present a smiley on the screen
     */
    var reward_holder = document.getElementById("reward_holder");
    var smiley_img = create_image_node('media/positive_feedback.png')
    smiley_img.setAttribute("width", "40px");
    smiley_img.setAttribute("height", "40px");
    reward_holder.appendChild(smiley_img);
}

function show_feedback(current_feedback){
    /**
     * Show the feedback according to current trial number and input side.
     */
    if(current_feedback){
        display_image = feedback_yes_img;
        total_rewards += 1;
        show_total_rewards();
        add_smiley_to_screen();
    }
    else{
        display_image = feedback_no_img;
    }
    if (should_feedback_displayed_now) {
        feedback_display_father.appendChild(display_image);
    }
//    display_image.style.visibility = "visible";
}

function hide_feedback(){
    /**
     * Remove current smiley
     */
    should_feedback_displayed_now = false;
    // display_image.style.visibility = "hidden";
    if (feedback_display_father.contains(display_image)){
        feedback_display_father.removeChild(display_image);
    }
    else{ //To synchronize elements, if presentation was not updated yet, wait for it 20ms and try again.
        setTimeout(20, hide_feedback);
    }
}
/** Feedback management -- end**/

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Report results
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function show_goodbye_message(){
    /**
     * Display a message informing the game has ended (before response comes
     * back from the server and the page navigates to the thank_you.php page
     */
    let instructions_text_div = document.getElementById("please_choose_text");
    instructions_text_div.innerHTML = "The game has ended. <br> You will shortly be moved to the next page.";
}

function go_to_goodbye_page(){
    /**
     * On last trial - finish the experiment.
     * @type {string}
     */
    window.location.href = 'instructions/thank_you.php';
}
