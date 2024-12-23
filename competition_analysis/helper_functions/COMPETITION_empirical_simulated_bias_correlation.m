function [all_models_empirical_and_simulated_bias_correlation,  ...
    models_order]...
    = COMPETITION_empirical_simulated_bias_correlation(all_schedules, REPETITIONS)
%COMPETITION_EMPIRICAL_SIMULATED_BIAS_CORRELATION Summary of this function goes here
%   Detailed explanation goes here
addpath('QL\');
addpath('CATIE\');
models_order = {'empiriacal_biases', ...
    'catie_biases', ...schedule_id=1
    'ql_het_online_biases', ...schedule_id=6
    'ql_hom_lab_biases', ...schedule_id=7
    'ql_hom_online_biases', ...schedule_id=9
    'ql_het_lab_biases',... schedule_id=10
    };

%% Calcualte the correlation of each model with the empirical bias (for 4.a)

% Define constants
N_SCHEDULES = 12;

% Initialize bias arrays for each model
catie_biases = zeros(1, N_SCHEDULES);
ql_hom_lab_biases = zeros(1, N_SCHEDULES);
ql_hom_online_biases = zeros(1, N_SCHEDULES);
ql_het_lab_biases = zeros(1, N_SCHEDULES);
ql_het_online_biases = zeros(1, N_SCHEDULES);

% Compute biases for each schedule
for ii = 1:N_SCHEDULES
    schedule_id = ii-1;
    rewards_1 = all_schedules(schedule_id).reward_schedule_1;
    rewards_2 = all_schedules(schedule_id).reward_schedule_2;
    catie_biases(ii) =            mean(CATIE_schedule_score(rewards_1, rewards_2, REPETITIONS));
    ql_hom_lab_biases(ii) =       mean(COMPETITION_QL_HOM_LAB_schedule_score(rewards_1, rewards_2, REPETITIONS));
    ql_hom_online_biases(ii) =    mean(COMPETITION_QL_HOM_ONLINE_schedule_score(rewards_1, rewards_2, REPETITIONS));
    ql_het_lab_biases(ii) =       mean(COMPETITION_QL_HET_LAB_schedule_score(rewards_1, rewards_2, REPETITIONS));
    ql_het_online_biases(ii) =    mean(COMPETITION_QL_HET_ONLINE_schedule_score(rewards_1, rewards_2, REPETITIONS));
end

% Compute correlations
empiriacal_biases = COMPETITION_all_schedules_biases(all_schedules);
all_models_biases = [empiriacal_biases; catie_biases; ql_het_online_biases; ql_hom_lab_biases; ql_hom_online_biases; ql_het_lab_biases];
all_models_correlation = corr(all_models_biases');

% Extract empirical and simulated bias correlation
all_models_empirical_and_simulated_bias_correlation = all_models_correlation(1, 2:end);
end