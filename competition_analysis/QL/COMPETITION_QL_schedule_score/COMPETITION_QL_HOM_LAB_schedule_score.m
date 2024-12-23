function biases = COMPETITION_QL_HOM_LAB_schedule_score(rewards_1, rewards_2, REPETITIONS)
%COMPETITION_QL_HOM_LAB Summary of this function goes here
%   Detailed explanation goes here

QL_PARAM = QL_parameters_constants();
biases = QL_HOM_schedule_score(rewards_1, rewards_2,...
    QL_PARAM.HOM.LAB.ETA, QL_PARAM.HOM.LAB.BETA, QL_PARAM.HOM.LAB.EPSILON, ...
    REPETITIONS);

end

