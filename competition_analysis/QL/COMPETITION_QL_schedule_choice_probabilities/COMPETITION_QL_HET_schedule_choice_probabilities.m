% Function Name: COMPETITION_QL_HET_schedule_choice_probabilities
% Inputs:
% - rewards_1: vector of length N representing the rewards for alternative 1 at each trial
% - rewards_2: vector of length N representing the rewards for alternative 2 at each trial
% - is_choice_1: binary vector of length N indicating whether alternative 1 was chosen at each trial (1 = alternative 1, 0 = alternative 2)
% - ETA: vector of length M representing the learning rate parameter for each sub-agent
% - BETA: vector of length M representing the inverse temperature parameter for each sub-agent
% - EPSILON: vector of length M representing the exploration probability parameter for each sub-agent
%
% Outputs:
% - p_choice: vector of length N representing the probability of choosing alternative 1 at each trial, estimated using a
% competition model with multiple sub-agents, each with different parameter values.
%
% This function computes the choice probabilities for a model with multiple Q-learning sub-agents with
% heterogeneous parameter values, given the rewards and choices made at each trial. For each sub-agent, the function calls
% the COMPETITION_QL_HOM_schedule_choice_probabilities function, which computes the choice probabilities using a Q-learning
% model with homogenous parameter values, and aggregates the resulting likelihoods to compute the choice probabilities for
% the competition model. The likelihoods of each sub-agent are cumulated and normalized, and the resulting probabilities
% are weighted by the choice probabilities of each sub-agent, to obtain the final estimate of the choice probabilities.
function p_choice = COMPETITION_QL_HET_schedule_choice_probabilities(rewards_1, rewards_2, is_choice_1, ETA, BETA, EPSILON)
% Define the number of sub-agents and the number of decisions in the task.
n_sub_agents = length(ETA);
n_decisions = length(is_choice_1);

% Pre-allocate a matrix to store the choice probabilities of each sub-agent for each decision.
agents_choice_probabilities = zeros(n_sub_agents , n_decisions);

% Loop over all sub-agents and compute their choice probabilities for each decision using the COMPETITION_QL_HOM_schedule_choice_probabilities function.
for agent_index=1:n_sub_agents
    agents_choice_probabilities(agent_index,:) = COMPETITION_QL_HOM_schedule_choice_probabilities(rewards_1, rewards_2, is_choice_1, ...
        ETA(agent_index), BETA(agent_index), EPSILON(agent_index));
end

% Compute the likelihood of each sub-agent given the observed choices of all sub-agents, for each decision.
agents_likelihoods_in_each_trial = cumprod([ones(n_sub_agents, 1), agents_choice_probabilities], 2);
normalized_agents_lielihoods_in_each_trial = agents_likelihoods_in_each_trial./sum(agents_likelihoods_in_each_trial);
normalized_agents_lielihoods_in_all_but_last_trial = normalized_agents_lielihoods_in_each_trial(:, 1:end-1);

% Compute the average choice probabilities across all sub-agents, weighted by their likelihoods.
p_choice = mean(agents_choice_probabilities' * normalized_agents_lielihoods_in_all_but_last_trial,2);
% p_choice = sum(agents_choice_probabilities .* normalized_agents_lielihoods_in_all_but_last_trial);
end


