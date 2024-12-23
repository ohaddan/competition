function COMPETITION_plot_choice_probabilities()
%CCOMPETITION_PLOT_CHOICE_PROBABILITIES Summary of this function goes here
%   Detailed explanation goes here
% Get empirical decision probabilities
[ql_hom_lab_probabilities, ql_hom_online_probabilities, ...
    ql_het_lab_probabilities, ql_het_online_probabilities, ...
    catie_probabilities] = ...
    COMPETITION_empirical_decisions_probabilities();

% Number of models
NUMBER_OF_MODELS = 5;

% Model probabilities
models_decision_p = {catie_probabilities, ql_het_online_probabilities, ...
    ql_hom_lab_probabilities, ql_hom_online_probabilities, ql_het_lab_probabilities};

% Calculate mean and SEM for each model
figure;
hold on;

[~, COLORS_BY_MODEL] = COMPETITION_schedule_colors();
model_colors = [...
    COLORS_BY_MODEL.catie; ...
    COLORS_BY_MODEL.ql.het.online;
    COLORS_BY_MODEL.ql.hom.lab;
    COLORS_BY_MODEL.ql.hom.online;
    COLORS_BY_MODEL.ql.het.lab;
    ];

for ii = 1:NUMBER_OF_MODELS
    % Calculate participant mean probabilities
    current_probabilities = models_decision_p{ii};
    participant_probability_mean = mean(current_probabilities, 2);
    decisions_p_mean = mean(participant_probability_mean);
    decisions_p_sem= sem(participant_probability_mean);

    % Plot bar for mean probability
    current_color = model_colors(ii,:);
    bar(ii, decisions_p_mean, 'FaceColor', current_color);


    all_probabilities = current_probabilities(:);
    % all_probabilities = all_probabilities(end-1000:end);
    
    % Scatter individual participant probabilities (jittered and small)
    jitter = ((rand(size(all_probabilities))) * - 0.35)-0.05; % Shift points slightly left
    scatter(ii + jitter, all_probabilities, 1, ... % Very small dots (size 6)
        current_color*0.8, 'filled', 'MarkerFaceAlpha', 0.5, 'MarkerEdgeAlpha', 0.5); % Darker and semi-transparent

    % Create a continuous half violin plot (smoothed normalized histogram)
    [counts, edges] = histcounts(all_probabilities, 20, 'Normalization', 'pdf');
    bin_centers = edges(1:end-1) + diff(edges) / 2;

    % Ensure histogram covers full range of probabilities
    min_point = min(participant_probability_mean);
    max_point = max(participant_probability_mean);
    extended_centers = [min_point, bin_centers, max_point]; % Include min and max
    extended_counts = [0, counts, 0]; % Append zeros to match extremes

    % Remove duplicate entries for unique interpolation points
    [extended_centers, unique_indices] = unique(extended_centers);
    extended_counts = extended_counts(unique_indices);

    % Interpolate for smoothness
    smooth_centers = linspace(min(extended_centers), max(extended_centers), 100);
    smooth_counts = interp1(extended_centers, extended_counts, smooth_centers, 'pchip');

    % Adjust violin color to be lighter than the bar color
    blend_factor = 0.3; % Adjust for lighter color
    lighter_color = current_color * (1 - blend_factor) + [1, 1, 1] * blend_factor;

    % Create the shaded half violin plot
    fill([ii, ii + smooth_counts * 0.05, ii], ...
        [smooth_centers(1), smooth_centers, smooth_centers(end)], ...
        lighter_color, 'EdgeColor', 'none', 'FaceAlpha', 0.7); % Slight transparency

    errorbar(ii, decisions_p_mean, decisions_p_sem, 'k', 'LineWidth', 3);
end

% Set axis limits and labels
ylim([0, 1]);
% ytick = 0.5:0.04:0.68;
% set(gca, 'YTick', ytick, 'YTickLabels', ytick);
xlabel('Model Index', 'FontSize', 16, 'FontWeight', 'bold');
ylabel('E[{\itp}]', 'FontWeight', 'bold', 'FontSize', 16);

model_ids = [1, 6, 7, 9, 10];
xlim([0.2 5.7]);
xlabel('Model ID', 'FontWeight','bold');
set(gca,'FontSize', 22, 'xtick', 1:5, 'xticklabel', model_ids);


% Turn off legend
legend off;

hold off;

end

