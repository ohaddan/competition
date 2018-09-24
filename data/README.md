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
	- `is_biased_choice` - 
	- `side_choice` - 
	- `side_choice` - 
	- `RT` - 
	- `observed_reward` - 
	- `unobserved_reward` - 
	- `biased_reward` - 
	- `unbiased_reward` - 
