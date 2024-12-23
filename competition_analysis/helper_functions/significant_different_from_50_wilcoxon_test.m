function report = significant_different_from_50_wilcoxon_test(data)
    % Null hypothesis median
    median_value = 50;
    
    % Perform the Wilcoxon signed-rank test
    [p_value, h, stats] = signrank(data, median_value);
    
    % Number of non-zero differences
    N = sum(data ~= median_value);
    
    % Extract the Wilcoxon statistic (signed rank sum)
    W = stats.signedrank;
    
    % Calculate effect size r
    effect_size = stats.zval / sqrt(N);
    
    % Determine significance
    if h == 1
        significance = 'significant';
    else
        significance = 'not significant';
    end
    
    % Calculate bootstrap confidence interval for the median
    num_bootstraps = 10000;
    bootstrapped_medians = zeros(1, num_bootstraps);
    for i = 1:num_bootstraps
        resampled_data = datasample(data, numel(data), 'Replace', true);
        bootstrapped_medians(i) = median(resampled_data);
    end
    ci_lower = prctile(bootstrapped_medians, 2.5);
    ci_upper = prctile(bootstrapped_medians, 97.5);
    
    % Generate the final report
    report = sprintf(... 
        ['Wilcoxon signed-rank test: W(%.0f) = %.3f, p = %.3f, r = %.3f. ', ...
         'The result is %s. Bootstrap 95%% CI for the median: [%.2f, %.2f].'], ...
        N, W, p_value, effect_size, significance, ci_lower, ci_upper);
    
    % Display the result
    fprintf('%s\n', report);
end

% function report = significant_different_from_50_wilcoxon_test(data)
%     % Null hypothesis median
%     median_value = 50;
% 
%     % Perform the Wilcoxon signed-rank test
%     [p_value, h, stats] = signrank(data, median_value);
% 
%     % Number of non-zero differences
%     N = sum(data ~= median_value);
% 
%     % Extract the Wilcoxon statistic (signed rank sum)
%     W = stats.signedrank;
% 
%     % Calculate effect size r
%     effect_size = stats.zval / sqrt(N);
% 
%     % Determine significance
%     if h == 1
%         significance = 'significant';
%     else
%         significance = 'not significant';
%     end
% 
%     % Generate the final report
%     report = sprintf(...
%         'Wilcoxon signed-rank test: W(%.0f) = %.3f, p = %.3f, r = %.3f. The result is %s.', ...
%         N, W, p_value, effect_size, significance);
% 
%     % Display the result
%     fprintf('%s\n', report);
% end
