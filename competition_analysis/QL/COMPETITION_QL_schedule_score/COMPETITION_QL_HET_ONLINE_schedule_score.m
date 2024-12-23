function biases = COMPETITION_QL_HET_ONLINE_schedule_score(rewards_1, rewards_2, REPETITIONS)
%COMPETITION_QL_HOM_LAB Summary of this function goes here
%   Detailed explanation goes here

QL_PARAM = QL_parameters_constants();
biases = QL_HET_schedule_score(rewards_1, rewards_2,...
    QL_PARAM.HET.ONLINE.ETA, QL_PARAM.HET.ONLINE.BETA, QL_PARAM.HET.ONLINE.EPSILON, ...
    REPETITIONS);

end

