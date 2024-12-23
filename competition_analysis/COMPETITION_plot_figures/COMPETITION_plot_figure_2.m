function COMPETITION_plot_figure_2(all_schedules, include_data_points, extended_mode)
%COMPETITION_PLOT_FIGURE_2 Create a figure for biases across reward schedules.
% By default, creates a simple plot without violin plots and aligns duplicate dots horizontally.
% If `extended_mode` is true, it adds half-violin plots, jittered scatter points, and transparency.

if nargin < 2
    include_data_points = true;
end

if nargin < 3
    extended_mode = false;
end

% Set up figure
fig2 = figure('Position', [1044, 460, 1057, 819], 'Name', 'Fig 2');
hold on;

% Hard-coded number of schedules
N_schedules = 11;

% Initialize means and SEMs
schedules_mean = zeros(1, N_schedules);
schedules_sem = zeros(1, N_schedules);

% Calculate means and SEMs for each schedule
for schedule_id = 1:N_schedules
    biases = all_schedules(schedule_id).biases;
    schedules_mean(schedule_id) = mean(biases);
    schedules_sem(schedule_id) = sem(biases);
end

% Plot bars and other elements
for schedule_id = 1:N_schedules
    biases = all_schedules(schedule_id).biases;
    
    % Bar plot
    bar(schedule_id, schedules_mean(schedule_id), ...
        'FaceColor', all_schedules(schedule_id).color, ...
        'FaceAlpha', 1, ...
        'LineWidth', 0.1);

    % Extended mode: Add half-violin plots and jittered scatter points
    if extended_mode
        % Create a continuous half violin plot (smoothed normalized histogram)
        [counts, edges] = histcounts(biases, 20, 'Normalization', 'pdf');
        bin_centers = edges(1:end-1) + diff(edges) / 2;

        % Ensure histogram covers full range of biases (min/max values)
        min_bias = min(biases);
        max_bias = max(biases);
        extended_centers = [min_bias, bin_centers, max_bias];
        extended_counts = [0, counts, 0];

        % Remove duplicate entries in extended_centers for unique interpolation points
        [extended_centers, unique_indices] = unique(extended_centers);
        extended_counts = extended_counts(unique_indices);

        % Interpolate for smoothness
        smooth_centers = linspace(min(extended_centers), max(extended_centers), 100);
        smooth_counts = interp1(extended_centers, extended_counts, smooth_centers, 'pchip');

        % Adjust histogram color to be darker than the bar
        bar_color = all_schedules(schedule_id).color * 0.6; % Darken the color
        fill([schedule_id, schedule_id + smooth_counts * 10, schedule_id], ...
            [smooth_centers(1), smooth_centers, smooth_centers(end)], ...
            bar_color, 'EdgeColor', 'none', 'FaceAlpha', 0.7);

        % Plot individual biases as semi-transparent gray dots with jitter
        jitter = (rand(size(biases)) - 1.25) * 0.3; % Shift points further left
        scatter(schedule_id + jitter, biases, 8, ...
            all_schedules(schedule_id).color * 0.6, ...
            'filled', 'MarkerFaceAlpha', 0.4, 'MarkerEdgeAlpha', 0.4);
    else
        % Default mode: Plot dots aligned horizontally for identical values
        unique_biases = unique(biases);
        for idx = 1:length(unique_biases)
            y_val = unique_biases(idx);
            x_positions = -0.4 + schedule_id + (0:sum(biases == y_val) - 1) * 0.03; % Spread horizontally
            scatter(x_positions, y_val * ones(size(x_positions)), 7, ...
                all_schedules(schedule_id).color * 0.6, ...
                'filled', 'MarkerFaceAlpha', 0.8, 'MarkerEdgeAlpha', 0.8);
        end
    end

    % Error bars with thicker lines for visibility
    errorbar(schedule_id, schedules_mean(schedule_id), schedules_sem(schedule_id), ...
        'k.', 'LineWidth', 2.5);
end

% Set axis limits and labels
ylim([0, 100]);
set(gca, 'FontSize', 16, ...
    'YTick', 0:10:100, ...
    'XTick', 1:N_schedules, 'XTickLabel', 1:N_schedules);
xlabel('Reward schedule', 'FontSize', 20, 'FontWeight', 'bold');
ylabel('Bias (%)', 'FontSize', 20, 'FontWeight', 'bold');

% Add a horizontal reference line at 50%
yline(50, '--k');

% Turn off legend
legend off;

% Save the figure
COMPETITION_save_figure('Fig2', fig2);
end

function s = sem(data)
% Helper function to calculate standard error of the mean
s = std(data) / sqrt(length(data));
end

% %%%%%%%%%%%%%%
% % Only violin
% %%%%%%%%%%%%%%
% function COMPETITION_plot_figure_2(all_schedules, includ_data_points)
% %COMPETITION_PLOT_FIGURE_2 Extended function with individual bias points,
% % smooth continuous violin plots, and jittered scatter points.
% if nargin==1
%     includ_data_points=true;
% end
% if includ_data_points
%     % Set up figure
%     fig2 = figure('Position', [1044, 460, 1057, 819], 'Name', 'Fig 2');
%     hold on;
% 
%     % Hard-coded number of schedules
%     N_schedules = 11;
% 
%     % Initialize means and SEMs
%     schedules_mean = zeros(1, N_schedules);
%     schedules_sem = zeros(1, N_schedules);
% 
%     % Calculate means and SEMs for each schedule
%     for schedule_id = 1:N_schedules
%         biases = all_schedules(schedule_id).biases;
%         schedules_mean(schedule_id) = mean(biases);
%         schedules_sem(schedule_id) = sem(biases);
%     end
% 
%     % Plot bars with error bars and additional elements
%     for schedule_id = 1:N_schedules
%         biases = all_schedules(schedule_id).biases;
%         % Bar plot
%         bar(schedule_id, schedules_mean(schedule_id), ...
%             'FaceColor', all_schedules(schedule_id).color, ...
%             'FaceAlpha', 1, ...
%             'LineWidth', 0.1);
% 
%         % Create a continuous half violin plot (smoothed normalized histogram)
%         [counts, edges] = histcounts(biases, 20, 'Normalization', 'pdf');
%         bin_centers = edges(1:end-1) + diff(edges) / 2;
% 
%         % Ensure histogram covers full range of biases (min/max values)
%         min_bias = min(biases);
%         max_bias = max(biases);
%         extended_centers = [min_bias, bin_centers, max_bias]; % Include min and max
%         extended_counts = [0, counts, 0]; % Append zeros to match extremes
% 
%         % Remove duplicate entries in extended_centers for unique interpolation points
%         [extended_centers, unique_indices] = unique(extended_centers);
%         extended_counts = extended_counts(unique_indices); % Keep corresponding counts
% 
%         % Interpolate for smoothness
%         smooth_centers = linspace(min(extended_centers), max(extended_centers), 100);
%         smooth_counts = interp1(extended_centers, extended_counts, smooth_centers, 'pchip');
% 
%         % Adjust histogram color to be darker than the bar
%         bar_color = all_schedules(schedule_id).color * 0.6; % Darken the color
%         fill([schedule_id, schedule_id + smooth_counts * 10, schedule_id], ...
%             [smooth_centers(1), smooth_centers, smooth_centers(end)], ...
%             bar_color, 'EdgeColor', 'none', 'FaceAlpha', 0.7); % Slight transparency
% 
%         % Plot individual biases as semi-transparent gray dots shifted left
%         jitter = (rand(size(biases)) - 1.25) * 0.3; % Shift points further left
%         lighter_factor = 0.8;
%         sctter_color = all_schedules(schedule_id).color*lighter_factor + [1, 1, 1]*(1-lighter_factor); %% 0.8*[1, 1, 1]; %% %%
%         sctter_color = all_schedules(schedule_id).color*0.6;
%         scatter(schedule_id + jitter, biases, 8, ... % Smaller dots (size 8)
%             sctter_color, 'filled', 'MarkerFaceAlpha', 0.4, 'MarkerEdgeAlpha', 0.4); % Gray color
% 
%         % Error bars with thicker lines for visibility
%         errorbar(schedule_id, schedules_mean(schedule_id), schedules_sem(schedule_id), ...
%             'k.', 'LineWidth', 2.5); % Thicker error bars
%     end
% 
%     % Set axis limits and labels
%     ylim([0, 100]);
%     set(gca, 'FontSize', 16, ...
%         'YTick', 0:10:100, ... % Y-ticks from 0 to 100
%         'XTick', 1:N_schedules, 'XTickLabel', 1:N_schedules);
%     xlabel('Reward schedule', 'FontSize', 20, 'FontWeight', 'bold');
%     ylabel('Bias (%)', 'FontSize', 20, 'FontWeight', 'bold');
% 
%     % Add a horizontal reference line at 50%
%     yline(50, '--k');
% 
%     % Turn off legend
%     legend off;
% 
%     % Save the figure
%     COMPETITION_save_figure('Fig2', fig2);
% else
%     fig2 = figure('Position', [1.0443e+03 459.6667 1.0573e+03 819.3333], 'Name', 'Fig 2');
% 
%     hold on
%     N_schedules = 11;
%     schedules_mean = zeros(1, N_schedules);
%     schedules_sem = zeros(1, N_schedules);
%     for schedule_id=1:N_schedules
%         schedules_mean(schedule_id) = mean(all_schedules(schedule_id).biases);
%         schedules_sem(schedule_id) = sem(all_schedules(schedule_id).biases);
%     end
% 
%     for schedule_id=1:N_schedules
%         bar(schedule_id, schedules_mean(schedule_id), ...
%             'FaceColor', all_schedules(schedule_id).color, ...
%             'FaceAlpha', 1, ...
%             'LineWidth', 0.1);
%     end
%     errorbar(1:N_schedules, schedules_mean, schedules_sem, 'k.', 'LineWidth', 1);
%     % legend('Mean', 'Standard error')
%     ylim([48 66])
%     set(gca, 'FontSize', 16,...
%         'YTick', 50:5:70,...
%         'XTick', 1:N_schedules, 'XTickLabel', 1:11)
%     xlabel('Reward schedule', 'FontSize', 20, 'FontWeight','bold');
%     ylabel('Bias (%)', 'FontSize', 20, 'FontWeight','bold');
%     legend off;
%     yline(50, '--k')
%     COMPETITION_save_figure('Fig2', fig2);
% end
% 
% 
% end
% 
% function s = sem(data)
% % Helper function to calculate standard error of the mean
% s = std(data) / sqrt(length(data));
% end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Only bars
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function [outputArg1,outputArg2] = COMPETITION_plot_figure_2(all_schedules)
% %COMPETITION_PLOT_FIGRE_2 Summary of this function goes here
% %   Detailed explanation goes here
% fig2 = figure('Position', [1.0443e+03 459.6667 1.0573e+03 819.3333], 'Name', 'Fig 2');
%
% hold on
% N_schedules = 11;
% schedules_mean = zeros(1, N_schedules);
%  schedules_sem = zeros(1, N_schedules);
% for schedule_id=1:N_schedules
%     schedules_mean(schedule_id) = mean(all_schedules(schedule_id).biases);
%     schedules_sem(schedule_id) = sem(all_schedules(schedule_id).biases);
% end
%
% for schedule_id=1:N_schedules
%     bar(schedule_id, schedules_mean(schedule_id), ...
%         'FaceColor', all_schedules(schedule_id).color, ...
%         'FaceAlpha', 1, ...
%         'LineWidth', 0.1);
% end
% errorbar(1:N_schedules, schedules_mean, schedules_sem, 'k.', 'LineWidth', 1);
% % legend('Mean', 'Standard error')
% ylim([48 66])
% set(gca, 'FontSize', 16,...
%     'YTick', 50:5:70,...
%     'XTick', 1:N_schedules, 'XTickLabel', 1:11)
% xlabel('Reward schedule', 'FontSize', 20, 'FontWeight','bold');
% ylabel('Bias (%)', 'FontSize', 20, 'FontWeight','bold');
% legend off;
% yline(50, '--k')
% COMPETITION_save_figure('Fig2', fig2);
% end
%
