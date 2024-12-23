function p_decisions = COMPETITION_CATIE_schedule_choice_probability(rewards_1, rewards_2, is_choice_1, k)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%% parameters

pHeuristic= 0.29;
epsilon= 0.3;
pIner= 0.71;

%% constants
nTrials = 100;

%% preallocation and initializations
contingency_counts_2 = zeros(4^k,2,'double');
contingency_counts_1 = zeros(4^k,2,'double');
pays = NaN(nTrials,1); 
surprise = NaN(nTrials,1); % holds levels of surprise in each trial
totalSurprise = 0; % holds sum of surprises thus far
reward_vec = NaN(nTrials,1); % holds observed history (0 = alternative 2, no reward, 1 = alternative 2, with reward, 
                                                     % 2 = alternative 1, no reward, 3 = alternative 1, with reward)
observed_SD = zeros(1,2); % holds the observed SD from payoffs in both options
reward_mean_2 = 0; % grand mean from alternative 2 (initialized to belief of zero)
reward_mean_1 = 0; % grand mean from alternative 1 (initialized to belief of zero)
expected_reward = zeros(1,2); % holds the payoff expectations for next trial in each alterrnative. Initialized by 0
reward_sum_2 = 0; % Holds sum of payoffs obtained from A 
sum_reward_squared_2 = 0; %Holds sum of squares for payoffs from A
num_choices_2 = 0; % Holds number of alternative 2 choices made
reward_sum_1 = 0; % Holds sum of payoffs obtained from alternative 1 
sum_reward_squared_1 = 0; %Holds sum of squares for payoffs from B
num_choices_1 = 0; % Holds number of alternative 1 choices made

p_decisions = zeros(1, nTrials);
POSITIVE_REWARD = 1;
%% Calculate decision probabilities
for trial = 1:nTrials
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Choice probability under contingency mode, beofre observing the
    % reward of current trial.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if k == 0 % CAB-0
        expected_reward(1) = reward_mean_1;
        expected_reward(2) = reward_mean_2;
        if reward_mean_1 == reward_mean_2
            p_choice_1_contingency_mode = 0.5;  %    IF ESTIMATED VALUES ARE EQUAL, CHOOSE RANDOMLY
        else
            p_choice_1_contingency_mode = reward_mean_1 > reward_mean_2;
        end
    elseif (trial-1) > k && trial < nTrials % CAB-k, k>0; trial-1, because in current trial reward was not observed yet
        last_k_trials_indices = (trial-k):(trial-1);
        current_k_contingency = (reward_vec(last_k_trials_indices))'; 
        rowDecide = base2dec(4, current_k_contingency)+1; % current contingency       
        % rowDecide = base2dec(4,(reward_vec((trial-k+1):(trial))'))+1; % current contingency       
        if contingency_counts_2(rowDecide,2) > 0 % If current contingency exists
           CA_2 = contingency_counts_2(rowDecide,1) / contingency_counts_2(rowDecide,2);
        else
            existing_contingencies_indices = contingency_counts_2(:,2) > 0;
            if sum(existing_contingencies_indices) > 0 % If any other contingency exists
                % ConfusionCont = datasample(contingency_counts_2(existing_contingencies_indices,:),1,1);
                % CAa = ConfusionCont(1)/ConfusionCont(2); 
                CA_2 = contingency_counts_2(existing_contingencies_indices, 1)./contingency_counts_2(existing_contingencies_indices, 2);
            else % No contingency exists, consider the simple reward mean
                CA_2 = reward_mean_2;
            end
        end        
        if contingency_counts_1(rowDecide,2) > 0  % If current contingency exists   
           CA_1 = contingency_counts_1(rowDecide,1) / contingency_counts_1(rowDecide,2); 
        else
            existing_contingencies_indices = contingency_counts_1(:,2) > 0; % If any other contingency exists
            if sum(existing_contingencies_indices) > 0
                % ConfusionCont = datasample(contingency_counts_1(existing_contingencies_indices,:),1,1);
                % CA_1 = ConfusionCont(1)/ConfusionCont(2); 
                CA_1 = contingency_counts_1(existing_contingencies_indices, 1)./contingency_counts_1(existing_contingencies_indices, 2);
            else  % No contingency exists, consider the simple reward mean
                CA_1 = reward_mean_1;
            end
        end
        % CA_1, and CA_2 may be a single value, or if the current
        % contingency does not exist, with uniform distribution the value 
        % of one past contingency is drawn. In that case, the probability
        % of choosing alternative 1 is the probability of choosing each of
        % the combinations of past contingencies, and then whether that
        % contingent average is greater or smaller than that of alternative
        % 2 (if they are equal, than choice is at random).
        [CA_1_values, CA_2_values] = meshgrid(CA_1, CA_2);
        mean_contingencies_1_greater_than_2 = mean(CA_1_values(:)>CA_2_values(:));
        mean_contingencies_1_equal_2 = mean(CA_1_values(:)==CA_2_values(:));
        p_choice_1_contingency_mode = mean_contingencies_1_greater_than_2 + 0.5*mean_contingencies_1_equal_2;
        
        expected_reward(2) = mean(CA_2);
        expected_reward(1) = mean(CA_1);
    
    else %if k>0 and not enough experience to use CAB-k
        if reward_mean_1 == reward_mean_2
            p_choice_1_contingency_mode = 0.5;
        else
            p_choice_1_contingency_mode = reward_mean_1 > reward_mean_2;
        end    
    end 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Calculate decision probability in current trial
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if trial==1
        p_decisions(1) = 0.5;
    else
        % Heuristic mode
        is_test_trend = (trial>2) && (is_choice_1(trial-1) == is_choice_1(trial-2)) && ((pays(trial-1) ~= pays(trial-2)));
        if is_test_trend
            if ((is_choice_1(trial-1) && (pays(trial) > pays(trial-1))) ||... % Last choice in 1 and positive trend
                    (~is_choice_1(trial) && (pays(trial) < pays(trial-1))))   % Last choice in 2 and negative trend
                p_choose_1_heuristic_mode = pHeuristic;
            else
                p_choose_1_heuristic_mode = 0;
            end
            p_try_explore = 1-pHeuristic;
        else
            p_try_explore = 1;
            p_choose_1_heuristic_mode = 0;
        end
        
        % exploration mode
        p_explore = getExploreProb(epsilon, surprise(trial-1), mean_surprise);
        p_enter_explore_mode = p_try_explore * p_explore;
        p_choose_1_exploration_mode = 0.5*p_enter_explore_mode;
        
        % Inertia mode
        % p_try_inertia_mode = p_try_explore * (1-p_enter_explore_mode);
        p_try_inertia_mode = p_try_explore * (1-p_explore);
        p_enter_inertia_mode = p_try_inertia_mode*pIner;
        p_choose_1_inertia_mode = is_choice_1(trial-1)*p_enter_inertia_mode;
        
        % Contingent average/exploitation mode
        p_enter_ca_mode = p_try_inertia_mode*(1-pIner);
        p_choose_1_ca_mode = p_enter_ca_mode*p_choice_1_contingency_mode;
        
        current_p_choice_1 = p_choose_1_heuristic_mode + p_choose_1_exploration_mode + p_choose_1_inertia_mode + p_choose_1_ca_mode;
        if is_choice_1(trial)
            p_decisions(trial) = current_p_choice_1;
        else
            p_decisions(trial) = 1-current_p_choice_1;
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Update internal parameters given curren choice and its observed
    % outcome
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if is_choice_1(trial) % Chose alternative 1
        pays(trial) = rewards_1(trial);
        if pays(trial) == POSITIVE_REWARD
            reward_vec(trial) = 3;
        else
            reward_vec(trial) = 2;
        end   
        % compute current SD
        reward_sum_1 = reward_sum_1 + pays(trial);
        num_choices_1 = num_choices_1 + 1;
        sum_reward_squared_1 = sum_reward_squared_1 + (pays(trial)).^2;
        var_reward_1 = (1/(num_choices_1-1)) * (sum_reward_squared_1 - ((reward_sum_1^2)/num_choices_1));
        if isnan(var_reward_1) || var_reward_1 < 0
            var_reward_1 = 0;
        end
        observed_SD(1) = sqrt(var_reward_1);
    else % Chose alternative 2
        pays(trial) = rewards_2(trial);
        if pays(trial) == POSITIVE_REWARD
            reward_vec(trial) = 1;
        else
            reward_vec(trial) = 0;
        end   
        % compute current SD
        reward_sum_2 = reward_sum_2 + pays(trial);
        num_choices_2 = num_choices_2 + 1;
        sum_reward_squared_2 = sum_reward_squared_2 + (pays(trial)).^2;
        var_reward_2 = (1/(num_choices_2-1)) * (sum_reward_squared_2 - ((reward_sum_2^2)/num_choices_2));
        if isnan(var_reward_2) || var_reward_2 < 0
            var_reward_2 = 0;
        end
        observed_SD(2) = sqrt(var_reward_2);        
    end
    
    % update surprise resulting from observed payoff
    chosen_alternative = (1-is_choice_1(trial)) + 1; % 1-->1; 0-->2
    if observed_SD(chosen_alternative) > 0.0001  % SURPRISE FUNCTION (DEPENDENT ON EXPECTATIONS & SDs)
        expected_vs_received_reward_abs_diff = abs(expected_reward(chosen_alternative) - pays(trial));
        surprise(trial) =  expected_vs_received_reward_abs_diff/(observed_SD(chosen_alternative) + expected_vs_received_reward_abs_diff); % surprise function
    else % no variability observed in the chosen button
        surprise(trial) = 0;
    end
    totalSurprise = totalSurprise + surprise(trial);
    mean_surprise = totalSurprise / trial; % the mean surprise observed in this game

    % update contingency beliefs 
    if k > 0 && trial > k 
        rowUpdate = base2dec(4,(reward_vec((trial-k):(trial-1))'))+1;
        if is_choice_1(trial) %decs_b(trial) == 0    
            % update contingent sum
            contingency_counts_1(rowUpdate,1) = contingency_counts_1(rowUpdate,1) + pays(trial);
            % update that contingent number encountered
            contingency_counts_1(rowUpdate,2) = contingency_counts_1(rowUpdate,2) + 1;
        else
            % update contingent sum
            contingency_counts_2(rowUpdate,1) = contingency_counts_2(rowUpdate,1) + pays(trial);
            % update that contingent number encountered
            contingency_counts_2(rowUpdate,2) = contingency_counts_2(rowUpdate,2) + 1;
        end
    end
    
    if is_choice_1(trial) % update General Mean
        reward_mean_1 = reward_sum_1/num_choices_1;
    else
        reward_mean_2 = reward_sum_2/num_choices_2;
    end    

end
end