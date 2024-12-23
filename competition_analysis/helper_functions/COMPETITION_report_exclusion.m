function COMPETITION_report_exclusion(all_schedules, all_schedules_no_constraint)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% Initialize variables for the table
n_with_exclusion = zeros(12, 1);
mean_bias_with_exclusion = zeros(12, 1);
num_no_exclusion = zeros(12, 1);
mean_bias_no_exclusion = zeros(12, 1);
num_invalid = zeros(12, 1);

% Iterate over the schedules
for ii = 0:11
    n_with_exclusion(ii+1) = length(all_schedules(ii).biases);
    mean_bias_with_exclusion(ii+1) = round(mean(all_schedules(ii).biases), 3);
    num_no_exclusion(ii+1) = length(all_schedules_no_constraint(ii).biases);
    mean_bias_no_exclusion(ii+1) = round(mean(all_schedules_no_constraint(ii).biases),3);
    num_invalid(ii+1) = length(all_schedules_no_constraint(ii).biases) - length(all_schedules(ii).biases);
end

% Calculate the percentage of invalid entries
percentage_invalid = sum(num_invalid) / sum(num_no_exclusion) * 100;

% Create the table
T = table(n_with_exclusion, num_no_exclusion, num_invalid, mean_bias_with_exclusion,  mean_bias_no_exclusion);
T.Properties.VariableNames = {'n_with_exclusion', 'n_no_exclusion', 'n_invalid', 'mean_bias_with_exclusion', 'mean_bias_no_exclusion'};
disp(T);

% Print the overall percentage of invalid entries
disp(['Overall percentage of invalid entries: ' num2str(percentage_invalid, 2) '%']);

% Print the overall number of invalid participants, total n_with_exclusion, and total n_no_exclusion
total_invalid = sum(num_invalid);
total_n_with_exclusion = sum(n_with_exclusion);
total_n_no_exclusion = sum(num_no_exclusion);

disp(['Overall number of invalid participants: ' num2str(total_invalid)]);
disp(['Total n with exclusion: ' num2str(total_n_with_exclusion)]);
disp(['Total n without exclusion: ' num2str(total_n_no_exclusion)]);

end




