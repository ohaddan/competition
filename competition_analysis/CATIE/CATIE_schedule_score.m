function biases = CATIE_schedule_score(rewards_1, rewards_2, REPETITIONS)
% This function calculates the biases of the CATIE algorithm for given
% reward schedules for two options
% Input:
% rewards_1: a vector of rewards for alternative 1
% rewards_2: a vector of rewards for alternative 2
% REPETITIONS: the number of repetitions for which to run the algorithm
% Output:
% biases: a vector containing the biases for each repetition

% Initialize the biases vector
biases = zeros(1, REPETITIONS);

% Run the CATIE algorithm for each repetition
for repetition = 1:REPETITIONS
    [decs_b, pays] = CATIE_single_schedule_score(rewards_1, rewards_2, 1);
    biases(repetition) = sum(~decs_b);
end
end

