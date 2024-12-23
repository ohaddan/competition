function p_choice = COMPETITION_QL_HOM_lab_schedule_choice_probabilities(rewards_1, rewards_2, is_choice_1)
%COMPETITION_QL_HOM_SCHEDULE_CHOICE_PROBABILITIES Summary of this function goes here
%   Detailed explanation goes here
% Get the length of the rewards vectors
QL_PARAM = QL_parameters_constants();

p_choice = COMPETITION_QL_HOM_schedule_choice_probabilities(rewards_1, rewards_2, is_choice_1, ...
    QL_PARAM.HOM.LAB.ETA, QL_PARAM.HOM.LAB.BETA, QL_PARAM.HOM.LAB.EPSILON);
end

