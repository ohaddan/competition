function COMPETITION_compare_biases_to_chance(biases)
    % Check assumptions: normality using Lilliefors test
    [h_norm, p_norm] = lillietest(biases); % Lilliefors test for normality
    normality_met = ~h_norm; % If h_norm is 0, normality is met
    
    % Calculate the mean and standard error of the mean (SEM) of biases
    mean_bias = mean(biases);
    sem_biases = std(biases) / sqrt(length(biases));
    
    % One-sample t-test against chance (50%)
    [~, p] = ttest(biases, 50);
    
    % Manually calculate the t-statistic and degrees of freedom
    t_stat = (mean_bias - 50) / sem_biases;
    df = length(biases) - 1;
    
    % Calculate Cohen's d for effect size
    cohen_d = (mean_bias - 50) / std(biases);
    
    % Calculate 95% Confidence Intervals
    ci = mean_bias + [-1, 1] * tinv(0.975, df) * sem_biases;
    
    % Display the output in the desired format
    fprintf('Assumptions check: Normality %s (Lilliefors test p=%.3f)\n', ...
            ternary(normality_met, 'met', 'not met'), p_norm);
    fprintf('t(%d) = %.2f, p = %.3f, Cohen''s d = %.2f, 95%% CI = [%.2f, %.2f]\n', ...
            df, t_stat, p, cohen_d, ci(1), ci(2));
end

% Ternary operator function for cleaner conditional display
function out = ternary(cond, valTrue, valFalse)
    if cond
        out = valTrue;
    else
        out = valFalse;
    end
end


%%% Simple version ttest
% function COMPETITION_compare_biases_to_chance(biases)
%     % Calculate the mean and standard deviation of the biases
%     mean_bias = mean(biases);
%     sem_biases = sem(biases);
% 
%     % Calculate the p-value for a one-sample t-test against chance (50%)
%     [~, p] = ttest(biases, 50);
% 
%     % Display the output in the desired format
%     fprintf('Mean bias +/-sem: %.1f%%+/- %.1f%%, different from chance: p=%.3f\n', mean_bias, sem_biases, p);
% end
