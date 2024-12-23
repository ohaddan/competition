function COMPETITION_plot_figure_3(all_schedules)
%COMPETITION_PLOT_FIGURE_3 Summary of this function goes here
%   Detailed explanation goes here

SAVED_CALCULATION_PATH = 'COMPETITION_plot_figures/COMPETITION_plot_figures_saved_calculation/COMPETITION_figure_3_calculations.mat';
if exist(SAVED_CALCULATION_PATH, 'file') == 2
    % If it exists, load the result variable
    load(SAVED_CALCULATION_PATH, ...
        'empirical_bias_mean', 'empirical_bias_mean_sem', 'simulated_bias_mean', 'simulated_bias_mean_sem',...
        'empirical_bias_std', 'empirical_bias_std_sem', 'simulated_bias_std', 'simulated_bias_std_sem');
else
    % If it doesn't exist, compute the data for the figure

    %% Bias mean for participant in all schedules
    empirical_bias_mean = zeros(1, 12);
    empirical_bias_mean_sem = zeros(1, 12);

    empirical_bias_std = zeros(1, 12);
    empirical_bias_std_sem = zeros(1, 12);

    for jj = 1:12
        schedule_id = jj-1;
        schedule_biases = all_schedules(schedule_id).biases;
        empirical_bias_mean(jj) = mean(schedule_biases);
        empirical_bias_mean_sem(jj) = sem(schedule_biases);
        empirical_bias_std(jj) = std(schedule_biases);

        empirical_biases_n = length(all_schedules(schedule_id).biases);
        REPETITIONS = 1e3;
        resampled_empirical_std = zeros(1, REPETITIONS);
        for ii=1:REPETITIONS
            resampled_empirical_std(ii) = std(datasample(schedule_biases, empirical_biases_n));
        end

        empirical_bias_std_sem(jj) = sem(resampled_empirical_std);
    end
    %% Bias mean for simulated CATIE participant in all schedules
    simulated_bias_mean = zeros(1, 12);
    simulated_bias_mean_sem = zeros(1, 12);

    simulated_bias_std = zeros(1, 12);
    simulated_bias_std_sem = zeros(1, 12);
    for jj = 1:12
        schedule_id = jj-1
        rewards_1 = all_schedules(schedule_id).reward_schedule_1;
        rewards_2 = all_schedules(schedule_id).reward_schedule_2;
        REPETITIONS = 1e3;
        simulated_means = zeros(1, REPETITIONS);
        simulated_stds = zeros(1, REPETITIONS);
        empirical_biases_n = length(all_schedules(schedule_id).biases);
        for ii=1:REPETITIONS
            catie_schedule_biases = CATIE_schedule_score(rewards_1, rewards_2, empirical_biases_n);
            simulated_means(ii) = mean(catie_schedule_biases);
            simulated_stds(ii) = std(catie_schedule_biases);
        end
        simulated_bias_mean(jj) = mean(simulated_means);
        simulated_bias_mean_sem(jj) = sem(simulated_means);
        simulated_bias_std(jj) = mean(simulated_stds);
        simulated_bias_std_sem(jj) = sem(simulated_stds);
    end
    save(SAVED_CALCULATION_PATH, ...
        'empirical_bias_mean', 'empirical_bias_mean_sem', 'simulated_bias_mean', 'simulated_bias_mean_sem',...
        'empirical_bias_std', 'empirical_bias_std_sem', 'simulated_bias_std', 'simulated_bias_std_sem');
end

%% Plot figure 3
fig3 = figure('Position', [883.6667 625.6667 1.5247e+03 598.6667], 'Name', 'Fig 3');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% In submission 1, Figure 3 had (a) as plots of the means and (b) as plots
% of standard deviations. In submission 2, we have as 3.a as it was but
% flippinf the axes, and in 3.b put what used to be fig s4, the correlation
% coefficient of the predicted vs empirical biases for CATEI and the four
% QL models.
% In the sections below, there is the NEW VERSION OF FIGURE 3. Down below,
% in a code that is currently marked for non-execution, there is the
% version of that old code.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot 3.a Mean correlation
subplot(1,2,1)
hold on
min_lim = min([empirical_bias_mean, simulated_bias_mean]) - 2;
max_lim = max([empirical_bias_mean, simulated_bias_mean]) + 2;
xlim([min_lim max_lim])
ylim([min_lim max_lim])

% index            = [0         1       2          3        4        5         6        7        8        9       10       11];
text_translation_x = [.7       -2      .7         -2       .05       .2       -2       -2       .2      -.85      -1.4      .2];
text_translation_y = [.1       .1       .2         0        0       .1       -.7        0       .1       -2.2        2.3       0];

for ii=1:12
    schedule_id = ii-1;
    x_position = simulated_bias_mean(ii);
    y_position = empirical_bias_mean(ii);
    % Vertical errobar
    errorbar(x_position, y_position, empirical_bias_mean_sem(ii),...
        '.', 'MarkerSize', 10, 'Color', all_schedules(schedule_id).color, 'LineWidth', 1);

    % Horizontal errobar
    errorbar(x_position, y_position, simulated_bias_mean_sem(ii), 'horizontal',...
        '.', 'MarkerSize', 10, 'Color', all_schedules(schedule_id).color, 'LineWidth', 1);

    % Schedule index
    text(x_position+text_translation_x(ii), y_position+text_translation_y(ii), ['(' num2str(schedule_id) ')'], 'fontsize', 18);
end


plot([min_lim max_lim ], [min_lim max_lim ], 'k--');

xlabel('Simulated bias mean', 'FontWeight','bold')
ylabel('Empirical bias mean', 'FontWeight','bold')

set(gca, 'FontSize', 22)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Figure 3.b - bar plot of correaltion coefficients
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
SAVED_CALCULATION_PATH = 'COMPETITION_plot_figures/COMPETITION_plot_figures_saved_calculation/COMPETITION_figure_4a_calculations.mat';
if exist(SAVED_CALCULATION_PATH, 'file') == 2
% if false
    % If it exists, load the result variable
    load(SAVED_CALCULATION_PATH, ...
        'empirical_simulated_bias_correlation', ...
        'models_order');
else

    REPETITION_PER_SIMULATED_SCHEDULE = 1e3; % number of simulated participants
    SIMULATION_REPETITIONS = 200;
    NUMBER_OF_MODELS = 5;
    empirical_simulated_bias_correlation = zeros(SIMULATION_REPETITIONS, NUMBER_OF_MODELS);
    for ii=1:SIMULATION_REPETITIONS
        [empirical_simulated_bias_correlation(ii,:), models_order]...
            = COMPETITION_empirical_simulated_bias_correlation(all_schedules, REPETITION_PER_SIMULATED_SCHEDULE);
    end
    save(SAVED_CALCULATION_PATH, ...
        'empirical_simulated_bias_correlation', ...
        'models_order');
end
%%%%%%%%%%%%%%
% Plot figure
%%%%%%%%%%%%%%

[~, COLORS_BY_MODEL] = COMPETITION_schedule_colors();
model_colors = [...
    COLORS_BY_MODEL.catie; ...
    COLORS_BY_MODEL.ql.het.online;
    COLORS_BY_MODEL.ql.hom.lab;
    COLORS_BY_MODEL.ql.hom.online;
    COLORS_BY_MODEL.ql.het.lab;
    ];
model_ids = [1, 6, 7, 9, 10];
    function plot_5_models_bars(score_mean, score_sem)
        hold on;
        NUMBER_OF_MODELS = 5;
        for model_index = 1:NUMBER_OF_MODELS
            bar(model_index, score_mean(model_index), 'FaceColor', model_colors(model_index,:));
        end
        errorbar(1:NUMBER_OF_MODELS, score_mean, score_sem, '.k', 'LineWidth', 3);
        xlim([0.2 5.7]);
        xlabel('Model ID', 'FontWeight','bold');
        set(gca,'FontSize', 22, 'xtick', 1:5, 'xticklabel', model_ids);

    end

subplot(1, 2, 2);
hold on
mean_correlation = mean(empirical_simulated_bias_correlation);
sem_correlation = sem(empirical_simulated_bias_correlation);
% plot_5_models_bars(mean_correlation, sem_correlation);
% Create 3.b- start

NUMBER_OF_MODELS = 5;
for model_index = 1:NUMBER_OF_MODELS
    % Bar plot
    bar(model_index, mean_correlation(model_index), 'FaceColor', model_colors(model_index, :), 'FaceAlpha', 0.9);

    % Scatter plot individual data points (jittered and semi-transparent)
    data_points = empirical_simulated_bias_correlation(:, model_index);
    jitter = (rand(size(data_points)) - 0.75) * 0.3; % Shift dots slightly to the left of the bar
    scatter(0.15+model_index+ 2*jitter, data_points, 20, ... % Smaller dots (size 8)
        model_colors(model_index, :) * 0.8, 'filled', 'MarkerFaceAlpha', 0.5, 'MarkerEdgeAlpha', 0.5); % Gray color

    % Create a continuous half violin plot (smoothed normalized histogram)
    [counts, edges] = histcounts(data_points, 20, 'Normalization', 'pdf');
    bin_centers = edges(1:end-1) + diff(edges) / 2;

    % Ensure histogram covers full range of data points (min/max values)
    min_point = min(data_points);
    max_point = max(data_points);
    extended_centers = [min_point, bin_centers, max_point]; % Include min and max
    extended_counts = [0, counts, 0]; % Append zeros to match extremes

    % Remove duplicate entries in extended_centers for unique interpolation points
    [extended_centers, unique_indices] = unique(extended_centers);
    extended_counts = extended_counts(unique_indices); % Keep corresponding counts

    % Interpolate for smoothness
    smooth_centers = linspace(min(extended_centers), max(extended_centers), 10);
    smooth_counts = interp1(extended_centers, extended_counts, smooth_centers, 'pchip');

    % Adjust violin color to be lighter or darker
    blend_factor = 0.3; % Adjust for lighter color
    lighter_color = model_colors(model_index, :) * (1 - blend_factor) + [1, 1, 1] * blend_factor;
    lighter_color = model_colors(model_index, :) * 0.8;

    % Create the shaded half violin plot
    % fill([model_index, model_index + smooth_counts * 0.03, model_index], ...
    %     [smooth_centers(1), smooth_centers, smooth_centers(end)], ...
    %     lighter_color, 'EdgeColor', 'none', 'FaceAlpha', 0.7); % Slight transparency

    % Overlay error bars
    errorbar(model_index, mean_correlation(model_index), sem_correlation(model_index), ...
        '.k', 'LineWidth', 2.5); % Thicker error bars for visibility

end
xlim([0.2 5.7]);
xlabel('Model ID', 'FontWeight','bold');
set(gca,'FontSize', 22, 'xtick', 1:5, 'xticklabel', model_ids);

% Create 3.b - end
ylabel({'Correlation';'Coefficient'}, 'FontWeight','bold')
ylim([-0.1 1])
COMPETITION_save_figure('Fig3', fig3);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% OLD VERSION OF FIGURE 3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if false
    %% Plot OLD figure 3.a
    subplot(1,2,1)
    hold on
    % index            = [0         1       2          3        4        5         6        7        8        9       10        11];
    text_translation_x = [.4       .7       .7       -.7       .6       .8       -.8       -.5       1.5     -3.5     0     1.2];
    text_translation_y = [0         0       .2       -.7       .1       .1       -.9       .9       .1       .1       2       -.4];

    for ii=1:12
        schedule_id = ii-1;
        x_position = empirical_bias_mean(ii);
        y_position = simulated_bias_mean(ii);
        % Vertical errobar
        errorbar(x_position, y_position, simulated_bias_mean_sem(ii),...
            '.', 'MarkerSize', 10, 'Color', all_schedules(schedule_id).color, 'LineWidth', 1);

        % Horizontal errobar
        errorbar(x_position, y_position, empirical_bias_mean_sem(ii), 'horizontal',...
            '.', 'MarkerSize', 10, 'Color', all_schedules(schedule_id).color, 'LineWidth', 1);

        % Schedule index
        text(x_position+text_translation_x(ii), y_position+text_translation_y(ii), ['(' num2str(schedule_id) ')'], 'fontsize', 18);
    end

    min_lim = min([empirical_bias_mean, simulated_bias_mean]) - 2;
    max_lim = max([empirical_bias_mean, simulated_bias_mean]) + 2;
    plot([min_lim max_lim ], [min_lim max_lim ], 'k--');
    xlabel('Empirical bias mean', 'FontWeight','bold')
    ylabel('Simulated bias mean', 'FontWeight','bold')
    xlim([min_lim max_lim])
    ylim([min_lim max_lim])
    set(gca, 'FontSize', 22)
    %% Plot OLD figure 3.b
    subplot(1,2,2)
    hold on
    % index            = [0         1       2          3        4        5         6        7        8        9       10        11];
    text_translation_x = [.1       .1       .1       .1       .1       .1     .1       .1       .1       .1       .1       .1];
    text_translation_y = [.1       .1       .1       .1       .1       .1     .1       .1       .1       .1       .1       .1];

    for ii=1:12
        schedule_id = ii-1;
        x_position = empirical_bias_std(ii);
        y_position = simulated_bias_std(ii);
        % Vertical errobar
        errorbar(x_position, y_position, simulated_bias_std_sem(ii),...
            '.', 'MarkerSize', 10, 'Color', all_schedules(schedule_id).color, 'LineWidth', 1);

        % Horizontal errobar
        errorbar(x_position, y_position, empirical_bias_std_sem(ii), 'horizontal',...
            '.', 'MarkerSize', 10, 'Color', all_schedules(schedule_id).color, 'LineWidth', 1);

        % Schedule index
        text(x_position+text_translation_x(ii), y_position+text_translation_y(ii), ['(' num2str(schedule_id) ')'], 'fontsize', 18);
    end

    min_lim = min([empirical_bias_std, simulated_bias_std]) - 1;
    max_lim = max([empirical_bias_std, simulated_bias_std]) + 1;
    plot([min_lim max_lim ], [min_lim max_lim ], 'k--');
    xlabel('Empirical bias STD', 'FontWeight','bold')
    ylabel('Simulated bias STD', 'FontWeight','bold')
    xlim([min_lim max_lim])
    ylim([min_lim max_lim])
    set(gca, 'FontSize', 22)
    COMPETITION_save_figure('Fig3', fig3);

    %% Statistical test for difference in std of humans and simulations
    n_greater_std_in_simulation = sum(simulated_bias_std>empirical_bias_std);
    p_greater_std_in_simulation = sum(binopdf(0:n_greater_std_in_simulation,12,0.5));
    fprintf('%d/12 schedules greater std in simulation compared to empirical (p=%.2f)\n', n_greater_std_in_simulation, p_greater_std_in_simulation);
end
end

