function catie_biases = COMPETITION_all_schedules_CATIE_biases_distribution(all_schedules)
%COMPETITION_ALL_SCHEDULES_BIASES Summary of this function goes here
%   Detailed explanation goes here

SAVED_CALCULATION_PATH = 'CATIE/CATIE_saved_computations/CATIE_all_schedules_biases_distribution.mat';
if exist(SAVED_CALCULATION_PATH, 'file') == 2
    % If it exists, load the result variable
    load(SAVED_CALCULATION_PATH, 'catie_biases');
else
    REPETITIONS = 1e4;
    N_SCHEDULES = 12;
    % CATIE biases
    catie_biases = cell(1, N_SCHEDULES);
    for ii=1:N_SCHEDULES
        schedule_id = ii-1;
        catie_biases{ii} = CATIE_schedule_score(all_schedules(schedule_id).reward_schedule_1, all_schedules(schedule_id).reward_schedule_2, REPETITIONS);
    end
    save(SAVED_CALCULATION_PATH, 'catie_biases');
end
end