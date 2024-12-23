function [p_choice] = COMPETITION_QL_HOM_schedule_choice_probabilities(rewards_1, rewards_2, is_choice_1, ETA, BETA, EPSILON)
%COMPETITION_QL_HOM_SCHEDULE_CHOICE_PROBABILITIES Summary of this function goes here
%   Detailed explanation goes here
% Get the length of the rewards vectors
N = length(rewards_1);
p_choice = zeros(1, N);

UNDEFINED = NaN;
q1 = UNDEFINED; q2 = UNDEFINED;
% Run the Q-learning algorithm for each trial
for trial=1:N

    if trial==1
        p1 = 0.5;
    elseif isnan(q1)
        p1 = EPSILON; % alternative 1 may be explore with probability epsilon
    elseif isnan(q2)
        p1 = 1 - EPSILON; % alternative 2 may be explored with probability epsilon
    else
        % Compute the probability of choosing alternative 1 using an epsilon-
        % softmax rule
        p1 = epsilon_softmax_p_choice_1(q1, q2, EPSILON, BETA);
    end

    if is_choice_1(trial)
        % The agent chose alternative 1
        p_choice(trial) = p1;
        if isnan(q1)
            % Reset of initial conditions
            q1 = rewards_1(trial);
        else
            % Update the Q-value for alternative 1
            q1 = q1 + ETA*(rewards_1(trial) - q1);
        end
    else
        % The agent chose alternative 2
        p_choice(trial) = 1-p1;
        if isnan(q2)
            q2 = rewards_2(trial);
        else
            % Update the Q-value for alternative 2
            q2 = q2 + ETA*(rewards_2(trial) - q2);
        end
    end
end
end

