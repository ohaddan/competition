% optimize_schedule_ql: a function that uses a genetic algorithm to optimize the
% rewards of two agents playing a game modeled as a Q-learning problem
%
% INPUTS:
% - OPTIMIZTION_TRIALS: number of optimization trials to perform
% - intial_rewards_1: initial reward vector for bias-target alternative
% - intial_rewards_2: initial reward vector for ANTI bias-target alternative
%
% OUTPUTS:
% - optimized_1: optimized rewards for bias-target alternative
% - optimized_2: optimized rewards for ANTI bias-target alternative
function [optimized_1, optimized_2] = optimize_schedule_ql(OPTIMIZATION_TRIALS, intial_rewards_1, intial_rewards_2, ETA, BETA, EPSILON, schedule_save_path)

sem = @(v) std(v)./sqrt(length(v)-1);
% Default parameters
if nargin<1
    OPTIMIZATION_TRIALS = 500;
end
if nargin<3
    intial_rewards_1 = [ones(1, 25) zeros(1, 75)];
    intial_rewards_2 = [zeros(1, 75) ones(1, 25)];
end

if nargin<6
    QL_PARAM = QL_parameters_constants();
    ETA = QL_PARAM.HOM.LAB.ETA;
    BETA = QL_PARAM.HOM.LAB.BETA;
    EPSILON = QL_PARAM.HOM.LAB.EPSILON;
    schedule_save_path = 'QL/QL_saved_computations/optimized_QL_HOM_LAB';
end

% Initialize variables
GENERATION_SIZE = 10;
generation_rewards_1 = repmat(intial_rewards_1, GENERATION_SIZE, 1);
generation_rewards_2 = repmat(intial_rewards_2, GENERATION_SIZE, 1);
schedule_repetitions_base = 100; %5000
max_scores = zeros(1, OPTIMIZATION_TRIALS);
sem_scores = zeros(1, OPTIMIZATION_TRIALS);

% Set up timer for printing elapsed time
tic;
% Set up progress bar
h_waitbar = waitbar(0, 'Optimizing QL Schedule');

for optimization_repetition=1:OPTIMIZATION_TRIALS
    schedule_repetitions = schedule_repetitions_base + 5*optimization_repetition;
    generation_mean_biases = zeros(1, GENERATION_SIZE);
    generation_sem_biases = zeros(1, GENERATION_SIZE);
    for generation_id=1:GENERATION_SIZE
        generation_biases = QL_HOM_schedule_score(generation_rewards_1(generation_id,:), generation_rewards_2(generation_id,:), ETA, BETA, EPSILON, schedule_repetitions);
        generation_mean_biases(generation_id) = mean(generation_biases);
        generation_sem_biases(generation_id) = sem(generation_biases);
    end
    [max_scores(optimization_repetition), best_index] = max(generation_mean_biases);
    sem_scores(optimization_repetition) = generation_sem_biases(best_index);

    % Plot the progress
    errorbar(1:optimization_repetition, max_scores(1:optimization_repetition), sem_scores(1:optimization_repetition));
    xlabel('Trial');
    ylabel('Maximal Bias');
    drawnow;


    % Generate next generation
    optimized_1 = generation_rewards_1(best_index,:);
    optimized_2 = generation_rewards_2(best_index,:);
    generation_rewards_1 = mutate_generation(optimized_1 , GENERATION_SIZE);
    generation_rewards_2 = mutate_generation(optimized_2, GENERATION_SIZE);

    % Update progress bar
    % completed_percentage = optimization_repetition/OPTIMIZATION_TRIALS;
    % waitbar(completed_percentage, h, sprintf('Optimizing QL Schedule (%d%% complete)', round(completed_percentage*100)));
    
    % Update waitbar with elapsed time and remaining iterations
    elapsed_time = toc;
    remaining_time = (OPTIMIZATION_TRIALS - optimization_repetition) * (elapsed_time / optimization_repetition);
    remaining_iterations = (OPTIMIZATION_TRIALS - optimization_repetition) * (elapsed_time / optimization_repetition);
    % waitbar(optimization_repetition / OPTIMIZATION_TRIALS, h_waitbar, sprintf('Elapsed time: %.2f sec, Remaining time: %.2f sec', elapsed_time, remaining_time));
    waitbar(optimization_repetition / OPTIMIZATION_TRIALS, h_waitbar, sprintf('Elapsed time: %.2f sec, Remaining iteration: %.2f sec', elapsed_time, OPTIMIZATION_TRIALS-optimization_repetition));


    % Every 20 iterations
    if mod(optimization_repetition, 20) == 0
         % Save the best schedule so far
        current_date = datestr(now,'yyyy-mm-dd');
        filename = sprintf([schedule_save_path '_%s.mat'], current_date);
        save(filename, 'optimized_1', 'optimized_2');
    end

end
% Close progress bar
close(h_waitbar);