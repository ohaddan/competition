# Choice Engineering Competition - Data
Each of the folders **random_*i*** (*i ∈ {0..19}*) contains the response of at least 20 subjects to the respective reward sequence found in the [static_sequences](https://github.com/ohaddan/competition/tree/master/static_sequences) folder. 

 - **File name** has no particular meaning. CSV and JSON files baring the same name have the same data (in different format).
 - **Each file represent the choices of s single subject** to a single reward schedule with 100 trials. Included
   - Incomplete experiments (when subjects leave the experiment prior to completing the 100 trials) are also included in these data folder (but such data will _not_ be included in the analysis of the competition).
- **Files structure** - each line in the data files represent a single trial. The available data (columns\headers)  for each trial are:
	- `trial_number`- Trial's ordinal. First trial is numbered 0.
	- `time` - time of making the choice  (GMT‎+3).
	- `schedule_type` - either 'STATIC' or 'DYNAMIC'
	- `schedule_name` - corresponds to the name of the  [reward schedule](https://github.com/ohaddan/competition/tree/master/static_sequences) folder.
	- `is_biased_choice` - Was current choice of the bias-target side (represented by a ‘true’ value) or not (represented by ‘false’)
	- `side_choice` - Which of two buttons on the screen were chosen (‘RIGHT’ or ‘LEFT’). In each experiment, independently, the side (left or right) for the bias-target is randomly chosen. 
	- `RT` - Reaction time in millisecond. The time between the previous and current choice. After making a choice, the buttons are “deactivated” for 1.5 second, which impose a minimal RT.
	- `observed_reward` - Whether current choice yielded a reward (represented by a value of ‘1’) or not (0).
	- `unobserved_reward` - Whether a choice in the unchosen alternative would have yielded a reward (represented by a value of ‘1’) or not (0). Unlike the `observed_reward` which is conveyed to the subject by presentation of a happy or sad smiley (representing the existence or inexistence of reward to their current choice) the unobserved reward is not conveyed  to the user (a partial feedback paradigm).
	- `biased_reward` - Whether a choice in the bias-target alternative in current trial yields a reward (represented by a value of ‘1’) or not (0). These are the values assigned by the design of a static reward schedule. These values are redundant, in the sense that they may be inferred from the values in `is_biased_choice` and `observed_reward` or `unobserved_reward` columns.
	- `unbiased_reward` - like `biased_reward` for the other (anti-target) alternative.
