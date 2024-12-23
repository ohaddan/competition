function report = COMPETITION_compare_model_biases_permutation_test(data1, data2, data1_id, data2_id)
% Input:
% - data1: first data sample
% - data2: second data sample
% - data1_id: identifier for data1 (e.g., 'Group 1')
% - data2_id: identifier for data2 (e.g., 'Group 2')

% Combine both datasets into a single vector
combined_data = [data1 data2];
n1 = length(data1);
n2 = length(data2);

% Calculate the observed difference in means
observed_diff = mean(data1) - mean(data2);

% Perform permutation test with 10,000 iterations
num_permutations = 10000;
count_greater = 0;

% Store permuted differences for CI computation
permuted_diffs = zeros(1, num_permutations);

for i = 1:num_permutations
    % Shuffle the combined data
    shuffled_data = combined_data(randperm(length(combined_data)));

    % Split the shuffled data into two groups
    permuted_data1 = shuffled_data(1:n1);
    permuted_data2 = shuffled_data(n1+1:end);

    % Calculate the mean difference for this permutation
    permuted_diff = mean(permuted_data1) - mean(permuted_data2);
    permuted_diffs(i) = permuted_diff;

    % Check if the permuted difference is greater than or equal to the observed difference
    if abs(permuted_diff) >= abs(observed_diff)
        count_greater = count_greater + 1;
    end
end

% Calculate the p-value
p_value = count_greater / num_permutations;

% Calculate effect size (Cohen's d)
pooled_std = sqrt(((n1-1)*var(data1) + (n2-1)*var(data2)) / (n1 + n2 - 2));
effect_size = observed_diff / pooled_std;

% Perform bootstrap for 95% Confidence Interval
bootstrap_diffs = zeros(1, num_permutations);
for i = 1:num_permutations
    % Resample with replacement from data1 and data2 using datasample
    bootstrap_sample1 = datasample(data1, n1);
    bootstrap_sample2 = datasample(data2, n2);

    % Calculate the difference in means for the bootstrap sample
    bootstrap_diffs(i) = mean(bootstrap_sample1) - mean(bootstrap_sample2);
end

% Calculate the 95% CI using bootstrap distribution
lower_ci = prctile(bootstrap_diffs, 2.5);
upper_ci = prctile(bootstrap_diffs, 97.5);

% Generate the report
report = sprintf('%s vs %s: Observed Mean Difference = %.3f (Mean1 = %.3f, Mean2 = %.3f), Effect Size (Cohen''s d) = %.3f, p-value = %.3f, 95%% CI = [%.3f, %.3f] (%d permutations)', ...
    data1_id, data2_id, observed_diff, mean(data1), mean(data2), effect_size, p_value, lower_ci, upper_ci, num_permutations);

% Display the report as a single line
fprintf('%s\n', report);
end


% function report = COMPETITION_compare_model_biases_permutation_test(data1, data2, data1_id, data2_id)
%     % Input:
%     % - data1: first data sample
%     % - data2: second data sample
%     % - data1_id: identifier for data1 (e.g., 'Group 1')
%     % - data2_id: identifier for data2 (e.g., 'Group 2')
%
%     % Combine both datasets into a single vector
%     combined_data = [data1 data2];
%     n1 = length(data1);
%     n2 = length(data2);
%
%     % Calculate the observed difference in means
%     observed_diff = mean(data1) - mean(data2);
%
%     % Perform permutation test with 10,000 iterations
%     num_permutations = 10000;
%     count_greater = 0;
%
%     for i = 1:num_permutations
%         % Shuffle the combined data
%         shuffled_data = combined_data(randperm(length(combined_data)));
%
%         % Split the shuffled data into two groups
%         permuted_data1 = shuffled_data(1:n1);
%         permuted_data2 = shuffled_data(n1+1:end);
%
%         % Calculate the mean difference for this permutation
%         permuted_diff = mean(permuted_data1) - mean(permuted_data2);
%
%         % Check if the permuted difference is greater than or equal to the observed difference
%         if abs(permuted_diff) >= abs(observed_diff)
%             count_greater = count_greater + 1;
%         end
%     end
%
%     % Calculate the p-value
%     p_value = count_greater / num_permutations;
%
%     % Calculate effect size (Cohen's d)
%     pooled_std = sqrt(((n1-1)*var(data1) + (n2-1)*var(data2)) / (n1 + n2 - 2));
%     effect_size = observed_diff / pooled_std;
%
%     % Generate the report
%     % report = sprintf('%s vs %s: Observed Mean Difference = %.3f, Effect Size (Cohen''s d) = %.3f, p-value = %.5f (%d permutations)', ...
%     %                  data1_id, data2_id, observed_diff, effect_size, p_value, num_permutations);
%
%     report = sprintf('%s vs %s: Observed Mean Difference = %.3f (Mean1 = %.3f, Mean2 = %.3f), Effect Size (Cohen''s d) = %.3f, p-value = %.5f (%d permutations)\n', ...
%         data1_id, data2_id, observed_diff, mean(data1), mean(data2), effect_size, p_value, num_permutations);
%
%     % Display the report as a single line
%     fprintf('%s\n', report);
% end
