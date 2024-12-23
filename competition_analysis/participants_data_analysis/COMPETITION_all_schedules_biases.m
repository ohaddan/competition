function empiriacal_biases = COMPETITION_all_schedules_biases(all_schedules)
%COMPETITION_ALL_SCHEDULES_BIASES Summary of this function goes here
%   Detailed explanation goes here

SAVED_CALCULATION_PATH = 'participants_data_analysis/COMPETITION_participants_data_analysis_saved_calculation/all_schedules_biases.mat';
if exist(SAVED_CALCULATION_PATH, 'file') == 2
    % If it exists, load the result variable
    load(SAVED_CALCULATION_PATH, 'empiriacal_biases');
else

    N_SCHEDULES = 12;
    % Empirical biases
    empiriacal_biases = zeros(1, N_SCHEDULES);
    for ii=1:N_SCHEDULES
        schedule_id = ii-1;
        empiriacal_biases(ii) = mean(all_schedules(schedule_id).biases);
    end
    save(SAVED_CALCULATION_PATH, 'empiriacal_biases');
end
end