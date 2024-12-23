function biases = COMPETITION_QL_HOM_ONLINE_schedule_score(rewards_1, rewards_2, REPETITIONS)
%COMPETITION_QL_HOM_LAB Summary of this function goes here
%   Detailed explanation goes here

QL_PARAM = QL_parameters_constants();
biases = QL_HOM_schedule_score(rewards_1, rewards_2,...
    QL_PARAM.HOM.ONLINE.ETA, QL_PARAM.HOM.ONLINE.BETA, QL_PARAM.HOM.ONLINE.EPSILON, ...
    REPETITIONS);

end

