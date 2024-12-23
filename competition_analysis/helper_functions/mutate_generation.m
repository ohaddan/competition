function mutated_generation = mutate_generation(best_schedule, GENERATION_SIZE)
% mutate_generation - generates a mutated generation of schedules from a given best schedule
%
% Syntax:
%   mutated_generation = mutate_generation(best_schedule, GENERATION_SIZE)
%
% Inputs:
%   best_schedule - a row vector representing the best schedule found so far
%   GENERATION_SIZE - the number of mutated schedules to generate
%
% Outputs:
%   mutated_generation - a matrix where each row represents a mutated schedule
%

% Set parameters
n = length(best_schedule); % n is the number of trials per experiment
N_ELEMENTS_RESHUFFLE = 2; % number of elements to reshuffle to generate a new schedule

% Initialize output
mutated_generation = zeros(GENERATION_SIZE, n);

% Generate mutated schedules
for ii = 1:GENERATION_SIZE-1
    % Randomly select N_ELEMENTS_RESHUFFLE indices to reshuffle
    reshuffle_indices = randperm(n, N_ELEMENTS_RESHUFFLE);
    
    % If reshuffling the selected elements does not generate a new schedule, select new indices
    while isequal(best_schedule(reshuffle_indices), best_schedule(circshift(reshuffle_indices,1)))
        reshuffle_indices = randperm(n, N_ELEMENTS_RESHUFFLE);
    end

    % Mutate the best schedule by reshuffling the selected indices
    mutate_best_schedule = best_schedule;
    mutate_best_schedule(reshuffle_indices) = mutate_best_schedule(circshift(reshuffle_indices, 1));
    mutated_generation(ii, :) = mutate_best_schedule;
end

% Add the best schedule to the end of the mutated generation
mutated_generation(end, :) = best_schedule;
end
