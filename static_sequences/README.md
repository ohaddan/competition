#Static sequences

Each of the python files in this directory describes one of the random sequences applied to a group of subjects in the experiment of the Choice Engineering Competition (more details on how and why these sequences were generated [here](https://sites.google.com/view/cec19/Data)). 

Each of the Python scripts contains two lines: 
The first line defines "bias_target", a list of rewards assigned to the target alternative.
The second line defines "anti_target", a list of rewards assigned to the other (anti-target) alternative.  
Each of the lines contains a list (sequence of comma separated numbers in square brackets) which represent the allocation of rewards to the two alternatives. A "1" at index i of one of the lists symbolizes that a choice of that alternative in the i'th trial will grant the experiment's subject an additional reward. Similarly, a "0" at index i of one of the lists symbolizes that no reward will be granted to the experiment's subject if that alternative will be chosen in the i'th trial.
