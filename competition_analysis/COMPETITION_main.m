addpath("participants_data_analysis/");
addpath("helper_functions/");
addpath("COMPETITION_reward_schedule/");
addpath("COMPETITION_plot_figures/");
addpath('CATIE/');
addpath('CATIE/CATIE_implementation_helpers/');
addpath('QL');
addpath('QL/COMPETITION_QL_schedule_choice_probabilities/');
addpath('QL/COMPETITION_QL_schedule_score/');

SAVED_CALCULATION_PATH = 'participants_data_analysis/CALCULATION_RESULT_model_biases.mat';
[schedules_empirical_biases, model_n_invalid_5_95] = COMPETITION_get_all_participants_biases(SAVED_CALCULATION_PATH, 5, 95);
all_schedules = COMPETITION_construct_all_schedules(schedules_empirical_biases);
%% Number of unique schedule
unique_schedules_n = nchoosek(100, 25).^2;
disp(['Number of unique schedules: ' num2str(unique_schedules_n , 1)]);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% - Ideal Engineer - 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Optimized schedule for QL-agent
QL_PARAM = QL_parameters_constants();

% define the path to saved computation folder
QL_SAVED_COMPUTATION_PATH = 'QL/QL_saved_computations/';
QL_most_recent_optimization_results = get_most_recent_file_path(QL_SAVED_COMPUTATION_PATH, 'optimized_QL_HOM_LAB');
load(QL_most_recent_optimization_results, 'optimized_1', 'optimized_2');

% if there are files in the folder
if ~isnan(QL_most_recent_optimization_results)
    load(QL_most_recent_optimization_results, 'optimized_1', 'optimized_2');
    QL_HOM_LAB_optimized_1 = optimized_1;
    QL_HOM_LAB_optimized_2 = optimized_2;
else
    % if no file exists, run the optimization code
    OPTIMIZATION_TRIALS = 500;
    intial_rewards_1 = [ones(1, 25) zeros(1, 75)];
    intial_rewards_2 = [zeros(1, 75) ones(1, 25)];
    schedule_save_path = 'QL/QL_saved_computations/optimized_QL_HOM_LAB';
    [QL_HOM_LAB_optimized_1, QL_HOM_LAB_optimized_2] = optimize_schedule_ql(OPTIMIZATION_TRIALS, intial_rewards_1, intial_rewards_2, QL_PARAM.HOM.LAB.ETA, QL_PARAM.HOM.LAB.BETA, QL_PARAM.HOM.LAB.EPSILON, schedule_save_path);
end

QL_HOM_LAB_biases = QL_HOM_schedule_score(QL_HOM_LAB_optimized_1, QL_HOM_LAB_optimized_2, QL_PARAM.HOM.LAB.ETA, QL_PARAM.HOM.LAB.BETA, QL_PARAM.HOM.LAB.EPSILON, 1e4);

report_biases(QL_HOM_LAB_biases, 'QL homogeneous, LAB')
% For QL_HOM_LAB, The mean of the biases is 67.0 with a standard error of the mean of 0.1.

%% Optimized schedule for CATIE-agent

CATIE_SAVED_COMPUTATION_PATH = 'CATIE/CATIE_saved_computations/';
CATIE_most_recent_optimization_results = get_most_recent_file_path(CATIE_SAVED_COMPUTATION_PATH, 'optimized_CATIE');
if ~isnan(CATIE_most_recent_optimization_results)
   load(CATIE_most_recent_optimization_results, 'CATIE_optimized_1', 'CATIE_optimized_2');
else
    OPTIMIZATION_TRIALS = 500;
    intial_rewards_1 = [ones(1, 25) zeros(1, 75)];
    intial_rewards_2 = [zeros(1, 75) ones(1, 25)];
    schedule_save_path = 'CATIE/CATIE_saved_computations/optimized_CATIE';
    [CATIE_optimized_1, CATIE_optimized_2] = optimize_schedule_CATIE(OPTIMIZATION_TRIALS, intial_rewards_1, intial_rewards_2, schedule_save_path);
end
REPETITIONS_FOR_SCORE = 1e5;
catie_schedule_biases = CATIE_schedule_score(CATIE_optimized_1, CATIE_optimized_2, REPETITIONS_FOR_SCORE);
report_biases(catie_schedule_biases, 'CATIE')
% For CATIE, The mean of the biases is 72.7 with a standard error of the mean of 0.0.

%% Get all empirical biases
SAVED_CALCULATION_PATH = 'participants_data_analysis/CALCULATION_RESULT_model_biases.mat';
[schedules_empirical_biases, model_n_invalid_5_95] = COMPETITION_get_all_participants_biases(SAVED_CALCULATION_PATH, 5, 95);
all_schedules = COMPETITION_construct_all_schedules(schedules_empirical_biases);

SAVED_CALCULATION_PATH = 'participants_data_analysis/CALCULATION_RESULT_model_biases_no_bias_constraint.mat';
[schedules_empirical_biases_no_constrain, model_n_invalid_no_constrain] = COMPETITION_get_all_participants_biases(SAVED_CALCULATION_PATH, 0, 100);
all_schedules_no_constraint = COMPETITION_construct_all_schedules(schedules_empirical_biases_no_constrain);

%% Empirical bias - experimental iterative optimization
report_biases(all_schedules(0).biases, 'Empirical Engineer')

%% Report all biases
COMPETITION_all_schedules_biases(all_schedules);
% schedule_id    n_biases    mean_biases    std_biases
% ___________    ________    ___________    __________
%      0           549            69           0.5    
%      1           595          64.3           0.5    
%      2           538          64.1           0.6    
%      3           607          62.7           0.6    
%      4           201          61.2           1.2    
%      5           176          60.8             1    
%      6           144          60.4           1.3    
%      7           119          57.4           1.8    
%      8           116          55.2           1.2    
%      9           107          55.2           1.5    
%     10            93          51.4           1.5    
%     11            87          50.7           1.8   
%% Report exclusion
COMPETITION_report_exclusion(all_schedules, all_schedules_no_constraint);
% Overall percentage of invalid entries: 1.6%
% Overall number of invalid participants: 54
% Total n with exclusion: 3332
% Total n without exclusion: 3386

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% - Choice engineering in the competition -
%   Summary of experimental participants
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Total number of participants in the competition 
% (without ideal architect)
n_participants = 0;
for schedule_id=1:11
    n_participants = n_participants + numel(all_schedules(schedule_id).biases);
end
fprintf('Toatl number of participants in the competition (without ideal architect): %d\n', n_participants);
% Toatl number of participants in the competition (without ideal architect): 2783

%% Compare the bias of least effetive schedule to chance
IS_USE_TTEST = false;
if IS_USE_TTEST
    COMPETITION_compare_biases_to_chance(all_schedules(11).biases);
end
% Mean bias +/-sem: 50.7%+/- 1.8%, different from chance: p=0.719
significant_different_from_50_wilcoxon_test(all_schedules(11).biases)
%% Compare the competition winner to "maximially attainable" bias (schedule 0)
COMPETITION_compare_model_biases_permutation_test(all_schedules(0).biases, all_schedules(1).biases, '0', '1');

%% Compare the competition winner to chance
if IS_USE_TTEST
    COMPETITION_compare_biases_to_chance(all_schedules(1).biases);
end
% Mean bias +/-sem: 64.3%+/- 0.5%, different from chance: p=0.000
significant_different_from_50_wilcoxon_test(all_schedules(1).biases)
%% Compare first and second place
COMPETITION_compare_model_biases_permutation_test(all_schedules(1).biases, all_schedules(2).biases, '1', '2');
%% Compare first and third place
COMPETITION_compare_model_biases_permutation_test(all_schedules(1).biases, all_schedules(3).biases,'1', '3');
%% Compare first and fourth..end places
only_p_values = true;
for schedule_id=4:11
    COMPETITION_compare_model_biases_permutation_test(all_schedules(1).biases, all_schedules(schedule_id).biases, '1', num2str(schedule_id));
end
disp('')
%% Plot figure 2
COMPETITION_plot_figure_2(all_schedules);
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - The CATIE model and the competition - 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Winner performance
report_biases(all_schedules(1).biases, 'Competition winner');
% For Competition winner, The mean of the biases is 64.3 with a standard error of the mean of 0.5, tested on 595 participants.

%% Simulating the winning schedule on CATIE model
winner_schedule_catie_simulated_biases = CATIE_schedule_score(all_schedules(1).reward_schedule_1, all_schedules(1).reward_schedule_2, 1e4);
report_biases(winner_schedule_catie_simulated_biases, 'Winner schedule, simulated bias on CATIE')
% For Winner schedule, simulated bias on CATIE, The mean of the biases is 71.7 with a standard error of the mean of 0.1, tested on 10000 participants.

%% Standard deviation of the bias for participant in the winning (CATIE) schedule
catie_empirical_biases_n = length(all_schedules(1).biases);
catie_empirical_std = std(all_schedules(1).biases);
REPETITIONS = 1e2;
resampled_empirical_catie_std = zeros(1, REPETITIONS);
for ii=1:REPETITIONS
    resampled_empirical_catie_std(ii) = std(datasample(all_schedules(1).biases, catie_empirical_biases_n));
end
fprintf('The empirical standard deviation of participants bias in the winning scheudle is %.1f%%+/-%.2f%%\n', catie_empirical_std, std(resampled_empirical_catie_std));
% The empirical standard deviation of participants bias in the winnind scheudle is 11.2%+/-0.04%

%% Standard deviation of the bias for simulated CATIE participant in the winning (CATIE) schedule
REPETITIONS = 1e2;
simulated_catie_std = zeros(1, REPETITIONS);
for ii=1:REPETITIONS
    simulated_catie_std(ii) = std(CATIE_schedule_score(all_schedules(1).reward_schedule_1, all_schedules(1).reward_schedule_2, 1e3));
end
fprintf('The standard deviation of the bias from CATIE simulation on the winning schedule is %.1f%%+/-%.2f%%\n', mean(simulated_catie_std), sem(simulated_catie_std));
% The standard deviation of the bias from CATIE simulation on the winning schedule is 10.0%+/-0.02%

%% Plot figure 3
COMPETITION_plot_figure_3(all_schedules);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - Choice engineering and standard methods of model comparison - 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
COMPETITION_plot_figure_4(all_schedules);
COMPETITION_plot_distribution_of_p_and_log_p(all_schedules);
%%
[ql_hom_lab_probabilities, ql_hom_online_probabilities, ...
    ql_het_lab_probabilities, ql_het_online_probabilities, ...
    catie_probabilities] = ...
    COMPETITION_empirical_decisions_probabilities();

clc
disp('E[p]')
% E[p]
permutation_test_and_bootstrap(catie_probabilities, ql_het_online_probabilities) % Scheudule 6
permutation_test_and_bootstrap(catie_probabilities, ql_hom_lab_probabilities) % Scheudule 7
permutation_test_and_bootstrap(catie_probabilities, ql_hom_online_probabilities) % Scheudule 9
permutation_test_and_bootstrap(catie_probabilities, ql_het_lab_probabilities) % Scheudule 10
% Observed Mean Difference = 0.031 (Mean1 = 0.619, Mean2 = 0.588), Effect Size (Cohen's d) = 0.129, p-value = 0.000, 95% CI = [0.030, 0.033] (1000 permutations)
% Observed Mean Difference = 0.027 (Mean1 = 0.619, Mean2 = 0.592), Effect Size (Cohen's d) = 0.095, p-value = 0.000, 95% CI = [0.026, 0.028] (1000 permutations)
% Observed Mean Difference = 0.001 (Mean1 = 0.619, Mean2 = 0.618), Effect Size (Cohen's d) = 0.005, p-value = 0.065, 95% CI = [-0.000, 0.003] (1000 permutations)
% Observed Mean Difference = 0.016 (Mean1 = 0.619, Mean2 = 0.603), Effect Size (Cohen's d) = 0.063, p-value = 0.000, 95% CI = [0.015, 0.017] (1000 permutations)


disp('E[log(p)]')
permutation_test_and_bootstrap(log(ql_het_lab_probabilities), log(catie_probabilities)) % Scheudule 1
permutation_test_and_bootstrap(log(ql_het_lab_probabilities), log(ql_het_online_probabilities)) % Scheudule 6
permutation_test_and_bootstrap(log(ql_het_lab_probabilities), log(ql_hom_lab_probabilities)) % Scheudule 7
permutation_test_and_bootstrap(log(ql_het_lab_probabilities), log(ql_hom_online_probabilities)) % Scheudule 9
% Observed Mean Difference = 0.109 (Mean1 = -0.569, Mean2 = -0.678), Effect Size (Cohen's d) = 0.186, p-value = 0.000, 95% CI = [0.106, 0.112] (1000 permutations)
% Observed Mean Difference = 0.019 (Mean1 = -0.569, Mean2 = -0.588), Effect Size (Cohen's d) = 0.050, p-value = 0.000, 95% CI = [0.017, 0.021] (1000 permutations)
% Observed Mean Difference = 0.107 (Mean1 = -0.569, Mean2 = -0.676), Effect Size (Cohen's d) = 0.210, p-value = 0.000, 95% CI = [0.105, 0.110] (1000 permutations)
% Observed Mean Difference = 0.209 (Mean1 = -0.569, Mean2 = -0.778), Effect Size (Cohen's d) = 0.296, p-value = 0.000, 95% CI = [0.206, 0.213] (1000 permutations)

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - Dynamic results - 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Dynamic results excluding participants that have not chosen each alternative at least five times')
COMPETITION_dynamic_biases(5, 95);
% Dynamic results excluding participants that have not chosen each alternative at least five times
% dynamic_schedule_1, n = 125, mean bias=69.9 (+- 1.4) (invalid biases: 5)
% dynamic_schedule_2, n = 128, mean bias=69.4 (+- 1.4) (invalid biases: 3)
% dynamic_schedule_3, n = 140, mean bias=61.9 (+- 1.2) (invalid biases: 3)
% dynamic_schedule_4, n = 142, mean bias=60.2 (+- 1.1) (invalid biases: 2)
% dynamic_schedule_5, n = 79, mean bias=57.0 (+- 1.3) (invalid biases: 1)
% dynamic_schedule_6, n = 62, mean bias=56.1 (+- 1.8) (invalid biases: 1)
% Valid schedules n = 676
% Total invalid_bias = 15 /691 (2.2%)

disp('Dynamic results with no exclusion')
COMPETITION_dynamic_biases(0, 100);
% dynamic_schedule_1, n = 130, mean bias=70.2 (+- 1.5) (invalid biases: 0)
% dynamic_schedule_2, n = 131, mean bias=69.3 (+- 1.5) (invalid biases: 0)
% dynamic_schedule_3, n = 143, mean bias=62.6 (+- 1.2) (invalid biases: 0)
% dynamic_schedule_4, n = 144, mean bias=60.7 (+- 1.2) (invalid biases: 0)
% dynamic_schedule_5, n = 80, mean bias=57.5 (+- 1.3) (invalid biases: 0)
% dynamic_schedule_6, n = 63, mean bias=56.7 (+- 1.9) (invalid biases: 0)
% Valid schedules n = 691
% Total invalid_bias = 0 /691 (0.0%)