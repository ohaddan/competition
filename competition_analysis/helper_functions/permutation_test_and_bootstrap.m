function permutation_test_and_bootstrap(data1, data2)
    % Flatten the matrices into vectors
    data1 = data1(:);
    data2 = data2(:);
    
    % Calculate observed difference in means
    observed_diff = mean(data1) - mean(data2);
    n1 = length(data1);
    n2 = length(data2);
    
    % Combine data
    combined_data = [data1; data2];
    
    % Number of permutations
    num_permutations = 1000;
    count_greater = 0;
    permuted_diffs = zeros(1, num_permutations);
    
    % Permutation test
    for i = 1:num_permutations
        % Shuffle combined data
        shuffled_data = combined_data(randperm(length(combined_data)));
        
        % Split into two groups
        permuted_data1 = shuffled_data(1:n1);
        permuted_data2 = shuffled_data(n1+1:end);
        
        % Calculate permuted mean difference
        permuted_diff = mean(permuted_data1) - mean(permuted_data2);
        permuted_diffs(i) = permuted_diff;
        
        % Count if permuted difference is as extreme as observed
        if abs(permuted_diff) >= abs(observed_diff)
            count_greater = count_greater + 1;
        end
    end
    
    % Calculate p-value
    p_value = count_greater / num_permutations;
    
    % Calculate effect size (Cohen's d)
    pooled_std = sqrt(((n1-1)*var(data1) + (n2-1)*var(data2)) / (n1 + n2 - 2));
    effect_size = observed_diff / pooled_std;
    
    % Bootstrap for confidence intervals
    bootstrap_diffs = zeros(1, num_permutations);
    for i = 1:num_permutations
        % Resample with replacement
        bootstrap_sample1 = datasample(data1, n1);
        bootstrap_sample2 = datasample(data2, n2);
        
        % Calculate bootstrap mean difference
        bootstrap_diffs(i) = mean(bootstrap_sample1) - mean(bootstrap_sample2);
    end
    
    % Calculate 95% confidence interval
    lower_ci = prctile(bootstrap_diffs, 2.5);
    upper_ci = prctile(bootstrap_diffs, 97.5);
    
    % Generate report
    report = sprintf('Observed Mean Difference = %.3f (Mean1 = %.3f, Mean2 = %.3f), Effect Size (Cohen''s d) = %.3f, p-value = %.3f, 95%% CI = [%.3f, %.3f] (%d permutations)', ...
        observed_diff, mean(data1), mean(data2), effect_size, p_value, lower_ci, upper_ci, num_permutations);
    
    % Display report
    fprintf('%s\n', report);
end
