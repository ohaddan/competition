function biases = COMPETITION_QL_HET_LAB_schedule_score(rewards_1, rewards_2, REPETITIONS)
%COMPETITION_QL_HOM_LAB Summary of this function goes here
%   Detailed explanation goes here

QL_PARAM = QL_parameters_constants();
biases = QL_HET_schedule_score(rewards_1, rewards_2,...
    QL_PARAM.HET.LAB.ETA, QL_PARAM.HET.LAB.BETA, QL_PARAM.HET.LAB.EPSILON, ...
    REPETITIONS);
end

