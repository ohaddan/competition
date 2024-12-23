clc
sem = @(v) std(v)./sqrt(length(v)-1);
reward = 1;
OPTIMIZTION_TRIALS = 10; %1000
max_scores = zeros(1, OPTIMIZTION_TRIALS);
sem_scores = zeros(1, OPTIMIZTION_TRIALS);
GENERATION_SIZE = 10;
generation_a = repmat(payoffs_a, GENERATION_SIZE, 1);
generation_b = repmat(payoffs_b, GENERATION_SIZE, 1);
schedule_repetitions_base = 100; %5000
tic
for optimization_repetition=1:OPTIMIZTION_TRIALS
    schedule_repetitions = schedule_repetitions_base + 5*optimization_repetition;
    biases = zeros(GENERATION_SIZE, schedule_repetitions);
    for ii=1:GENERATION_SIZE
        for jj=1:(schedule_repetitions)
            [decs_b, pays] = CATIE_choice_engineering_competition(generation_a(ii,:), generation_b(ii,:), reward);
            biases(ii, jj) = sum(~decs_b);
        end
    end
    mean_bias = mean(biases, 2)';
    [max_scores(optimization_repetition), best_index] = max(mean_bias);
    sem_scores(optimization_repetition) = sem(biases(best_index,:));
    % Plot
    errorbar(1:optimization_repetition, max_scores(1:optimization_repetition), sem_scores(1:optimization_repetition)); xlabel('Trial'); ylabel('Maximal Bias'); drawnow;
%     uitable(gcf,"Data",[generation_a(best_index,:); generation_b(best_index,:)]);
    % Generate next generation
    generation_a = mtuate_generation(generation_a(best_index,:), GENERATION_SIZE);
    generation_b = mtuate_generation(generation_b(best_index,:), GENERATION_SIZE);
    if mod(ii,30)==0
        A = generation_a(best_index,:)
        B = generation_b(best_index,:)
    end
end