_Competition website [here](https://sites.google.com/view/cec19/home?authuser=0)_

#Experiment flow
1. [instructions/welcome.html](http://decision-making-lab.com/visual_experiment/cmptn_remote/instructions/welcome.html) -
Gives subject the instructions for the experiment.   
1. [main.php](http://decision-making-lab.com/visual_experiment/cmptn_remote/main.php) - The main page which
manages the experiment. The page defines:
    - PHP session parameters:
        - User Id
        - Presented reward schedule
        - User choices, rewards and trials arrays
        - Random allocation of sides (which is the "biased target")
        - Trials
    - The structure of the page (e.g. buttons) with hooks to the logic initiated when either of the buttons 
    is chosen.
1.  [scripts/code.js]() - manages the game. The flow of the experiment is as follows:
    
    - `left_button_clicked()` or `right_button_clicked()` are triggered by the respective buttons from [main.php]().
        1. Call `button_clicked()` which:
            - Registers reaction time (RT)
            - Hides the choice-buttons for a specific time (_`FEEDBACK_TIME = 1500ms`_), after which a button 
            (named the "enabler" in the code) is displayed in the middle of the screen and it must be pressed 
            to make the choice buttons reappear (to force subjects to come to a neutral position at the beginning 
            of each trial).
            -   Updates the trial counter on screen.
        1. Call `get_current_trial_rewards(side_chosen)` from [backend_interaction.js]() (see below).
1.  [scripts/backend_interaction.js]() - manages writing the data of current trial to backend and receiving back 
the reward associated with current choice.  
