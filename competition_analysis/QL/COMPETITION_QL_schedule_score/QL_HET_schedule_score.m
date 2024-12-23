% This function implements the Q-learning algorithm for two alternative
% forced choice tasks with constant reward probabilities. It evaluates
% the bias towards the first alternative for a given pair of reward
% probabilities.
%
% INPUTS:
%   - rewards_1: a vector of length N that defines the reward probability for
%       the first alternative on each trial. It should contain only 0's or 1's.
%   - rewards_2: a vector of length N that defines the reward probability for
%       the second alternative on each trial. It should contain only 0's or 1's.
%   - ETA: a scalar that defines the learning rate. It should be between 0 and 1.
%   - BETA: a scalar that defines the inverse temperature. It should be positive.
%   - EPSILON: a scalar that defines the probability of choosing a random action
%       instead of the optimal one. It should be between 0 and 1.
%   - REPETITIONS: a scalar that defines the number of repetitions. It should be
%       a positive integer.
%
% OUTPUTS:
%   - biases: a vector of length REPETITIONS that contains the bias towards
%       the first alternative for each repetition.

function biases = QL_HET_schedule_score(rewards_1, rewards_2, ETA, BETA, EPSILON, REPETITIONS)

% Get the length of the rewards vectors
N = length(rewards_1);
N_params = length(ETA); % Number of "sub agents"

% Initialize the biases vector
biases = zeros(1, REPETITIONS);

% Run the Q-learning algorithm for each repetition
for repetition = 1:REPETITIONS
    % Each sub agent has its own q-value
    q1 = NaN(1, N_params);
    q2 = NaN(1, N_params);
    all_agents_p1 = NaN(1, N_params); % The probability of choosing alternative 1
    
    % In the first two trials, the agent chooses the two alternatives in
    % random order, then applies "reset of initial conditions"
    if rand<0.5
        q1(:) = rewards_1(1); q2(:) = rewards_2(2);
    else
        q1(:) = rewards_1(2); q2(:) = rewards_2(1);
    end
    
    % Initialize the count of choices for alternative 1 to 1
    alternative_1_choices = 1;
    
    % Run the Q-learning algorithm for each trial
    for trial=3:N
        
        % Compute the probability of choosing alternative 1 using an epsilon-
        % softmax rule
        for agent_id=1:N_params
            all_agents_p1(agent_id) = epsilon_softmax_p_choice_1(q1(agent_id), q2(agent_id), EPSILON(agent_id), BETA(agent_id));
        end
        
        p1 = mean(all_agents_p1);
        % Choose an action using the computed probability
        if p1>rand()
            % The agent chose alternative 1
            alternative_1_choices = alternative_1_choices + 1;
            % Update the Q-value for alternative 1
            q1 = q1 + ETA.*(rewards_1(trial) - q1);
        else
            % The agent chose alternative 2
            % Update the Q-value for alternative 2
            q2 = q2 + ETA.*(rewards_2(trial) - q2);
        end
    end
    
    % Store the bias towards alternative 1 for this repetition
    biases(repetition) = alternative_1_choices;
    
end
end
