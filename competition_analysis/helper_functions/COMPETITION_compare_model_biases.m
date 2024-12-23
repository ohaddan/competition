function COMPETITION_compare_model_biases(biases_1, biases_2, only_p_value)
    % Set only_p_value to false if not provided
    if nargin == 2
        only_p_value = false;
    end

    % Check assumptions: normality using Lilliefors test
    [h_norm1, p_norm1] = lillietest(biases_1); % Normality test for biases_1
    [h_norm2, p_norm2] = lillietest(biases_2); % Normality test for biases_2
    normality_met_1 = ~h_norm1; % True if normality is met for biases_1
    normality_met_2 = ~h_norm2; % True if normality is met for biases_2

    % Perform independent two-sample t-test
    [h, p, ci, stats] = ttest2(biases_1, biases_2);
    t_stat = stats.tstat;
    df = stats.df;
    
    % Calculate effect size: Cohen's d for two independent samples
    pooled_std = sqrt(((length(biases_1)-1)*var(biases_1) + (length(biases_2)-1)*var(biases_2)) / ...
                      (length(biases_1) + length(biases_2) - 2));
    cohen_d = (mean(biases_1) - mean(biases_2)) / pooled_std;

    % Check if only the p-value is required
    if only_p_value
        fprintf('p=%.3f\n', p);
    else
        % Display normality assumption check
        fprintf('Normality check for first schedule: %s (Lilliefors test p=%.3f)\n', ...
                ternary(normality_met_1, 'met', 'not met'), p_norm1);
        fprintf('Normality check for second schedule: %s (Lilliefors test p=%.3f)\n', ...
                ternary(normality_met_2, 'met', 'not met'), p_norm2);
        
        % Display means and SEMs
        fprintf('First schedule: Mean bias +/- SEM: %.1f%% +/- %.1f%%\n', mean(biases_1), std(biases_1)/sqrt(length(biases_1)));
        fprintf('Second schedule: Mean bias +/- SEM: %.1f%% +/- %.1f%%\n', mean(biases_2), std(biases_2)/sqrt(length(biases_2)));
        
        % Display t-test results including effect size and CI
        fprintf('First and second schedules statistical difference: t(%d) = %.2f, p = %.3f, Cohen''s d = %.2f, 95%% CI = [%.2f, %.2f]\n', ...
                df, t_stat, p, cohen_d, ci(1), ci(2));
    end
end

% Ternary operator function for cleaner conditional display
function out = ternary(cond, valTrue, valFalse)
    if cond
        out = valTrue;
    else
        out = valFalse;
    end
end

% function COMPETITION_compare_model_biases(biases_1,biases_2, only_p_value)
% %UNTITLED Summary of this function goes here
% %   Detailed explanation goes here
% if nargin == 2
%     only_p_value = false;
% end
% [h,p,ci,stats] = ttest2(biases_1,biases_2);
% if only_p_value
% fprintf('p=%.3f, ', p);
% else
%     % Calculate the p-value for a one-sample t-test against chance (50%)
%     [h,p,ci,stats] = ttest2(biases_1,biases_2);
% 
%     fprintf('First schedule: Mean bias +/-sem: %.1f%%+/- %.1f%%\n', mean(biases_1), sem(biases_1));
%     fprintf('Second schedule: Mean bias +/-sem: %.1f%%+/- %.1f%%\n', mean(biases_2), sem(biases_2));
%     fprintf('First and second schedules statistical difference: p=%.3f df=%.d\n', p, stats.df);
% end
% end
% 
