function COMPETITION_plot_figure_S5(all_schedules)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
SAVED_CALCULATION_PATH = 'COMPETITION_plot_figures/COMPETITION_plot_figures_saved_calculation/COMPETITION_figure_4a_calculations.mat';
if exist(SAVED_CALCULATION_PATH, 'file') == 2
    % If it exists, load the result variable
    load(SAVED_CALCULATION_PATH, ...
        'empirical_simulated_bias_correlation', ...
        'models_order');
else
    REPETITION_PER_SIMULATED_SCHEDULE = 1e3; % number of simulated participants
    SIMULATION_REPETITIONS = 50;
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

[ql_hom_lab_probabilities, ql_hom_online_probabilities, ...
    ql_het_lab_probabilities, ql_het_online_probabilities, ...
    catie_probabilities] = ...
    COMPETITION_empirical_decisions_probabilities();
NUMBER_OF_MODELS = 5;
models_decision_p = {catie_probabilities, ql_het_online_probabilities, ql_hom_lab_probabilities, ql_hom_online_probabilities, ql_het_lab_probabilities};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot figure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[~, COLORS_BY_MODEL] = COMPETITION_schedule_colors();
model_colors = [...
    COLORS_BY_MODEL.catie; ...
    COLORS_BY_MODEL.ql.het.online;
    COLORS_BY_MODEL.ql.hom.lab;
    COLORS_BY_MODEL.ql.hom.online;
    COLORS_BY_MODEL.ql.het.lab;
    ];
model_ids = [1, 6, 7, 9, 10];
    function plot_5_models_bars(score_mean, score_sem, is_max_significantly_different)
        hold on;

        % Initialize variables
        max_value = max(score_mean);
        max_index = find(score_mean == max_value);

        for model_index = 1:NUMBER_OF_MODELS
            % Plot each bar with its corresponding color
            hBar = bar(model_index, score_mean(model_index), 'FaceColor', model_colors(model_index,:));

            % Add text label at the top of the bar
            model_text = num2str(round(score_mean(model_index), 3));

            if model_index == max_index
                if is_max_significantly_different
                    asterisk = '*';
                else
                    asterisk = '';
                end
                text(model_index, score_mean(model_index) + 0.01, [model_text asterisk], ...
                    'VerticalAlignment', 'bottom', ...
                    'HorizontalAlignment', 'center', ...
                    'FontWeight', 'bold',...
                    'FontAngle', 'italic');
            else
                text(model_index, score_mean(model_index) + 0.01, model_text, ...
                    'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'center');
            end
        end

        % Add error bars
        errorbar(1:NUMBER_OF_MODELS, score_mean, score_sem, '.k', 'LineWidth', 3);

        hold off;

        xlim([0.2 5.7]);
        xlabel('Model ID', 'FontSize', 20, 'FontWeight','bold');
        set(gca,'FontSize', 14, 'xtick', 1:5, 'xticklabel', model_ids);

    end
%% Figure S5+S6
% Initialize
n_previous = 1;
NUMBER_OF_MODELS = 5; % Example value, replace with actual value
sem = @(v) std(v) ./ sqrt(length(v) - 1); % Standard Error of the Mean function

% Create figure
figure('Name', 'Fig S.5 and 6', 'Position', [1661 41.6667 899.4000 1.3193e+03]);
ALPHA = 0.001;
ALPHA = 0.01;
% Loop through each schedule
for jj = 1:12
    % Initialize arrays for action probabilities and their SEM
    model_overall_action_p = zeros(1, NUMBER_OF_MODELS);
    model_overall_action_p_sem = zeros(1, NUMBER_OF_MODELS);

    % Get the number of participants for the current schedule
    current_n = all_schedules(jj-1).n_participants;
    n_range = n_previous:((n_previous + current_n) - 1);
    n_previous = n_previous + current_n;

    % Calculate mean probabilities and SEM for each model
    for ii = 1:NUMBER_OF_MODELS
        participants_all_actions_probabilities = models_decision_p{ii}(n_range, :);
        participant_mean_probability = mean(participants_all_actions_probabilities, 2);
        model_overall_action_p(ii) = mean(participant_mean_probability);
        model_overall_action_p_sem(ii) = sem(participant_mean_probability);
    end

    % Plot the results for the current schedule (first set of plots)
    [~, means_order] = sort(model_overall_action_p, 'Descend');
    first_place_participants_mean = mean(models_decision_p{means_order(1)}(n_range, :),2);
    second_place_participants_mean = mean(models_decision_p{means_order(2)}(n_range, :),2);
    [first_place_significantly_different_than_second, p] = ...
        ttest2(first_place_participants_mean, second_place_participants_mean, "Alpha",ALPHA, "Vartype","unequal");
    subplot(12, 2, (jj-1) * 2 + 1);
    plot_5_models_bars(model_overall_action_p, model_overall_action_p_sem, first_place_significantly_different_than_second);

    title(['Schedule ' num2str(jj) ', n=' num2str(current_n)]);
    set(gca, 'FontSize', 14);
    ylabel('E[{\itp}]', 'FontWeight', 'bold', 'FontSize',20);
    ylim([0.5 0.75]);
    if jj < 12
        xlabel('');
        set(gca, 'XTick', []);
    end
    if jj ~= 6
        ylabel('');
    end


    % Recalculate for log-transformed probabilities
    model_overall_action_log_p = zeros(1, NUMBER_OF_MODELS);
    model_overall_action_log_p_sem = zeros(1, NUMBER_OF_MODELS);

    for ii = 1:NUMBER_OF_MODELS
        participants_all_actions_log_probabilities = log(models_decision_p{ii}(n_range, :));
        participant_mean_log_probability = mean(participants_all_actions_log_probabilities, 2);
        model_overall_action_log_p(ii) = mean(participant_mean_log_probability);
        model_overall_action_log_p_sem(ii) = sem(participant_mean_log_probability);
    end

    [~, means_log_order] = sort(model_overall_action_p, 'Descend');
    first_place_participants_log_mean = mean(log(models_decision_p{means_log_order(1)}(n_range, :)),2);
    second_place_participants_log_mean = mean(log(models_decision_p{means_log_order(2)}(n_range, :)),2);
    [first_place_significantly_different_than_second_log, p] = ...
        ttest2(first_place_participants_log_mean, second_place_participants_log_mean, "Alpha",ALPHA, "Vartype","unequal");

    % Plot the results for the current schedule (second set of plots)
    subplot(12, 2, (jj-1) * 2 + 2);
    plot_5_models_bars(model_overall_action_log_p, model_overall_action_log_p_sem, first_place_significantly_different_than_second_log);

    title(['Schedule ' num2str(jj) ', n=' num2str(current_n)]);
    set(gca, 'FontSize', 14);
    ylabel('E[{log(\itp)}]', 'FontSize', 20, 'FontWeight','bold');
    ylim([-1.3 0]);
    if jj < 12
        xlabel('');
        set(gca, 'XTick', []);
    end
    if jj ~= 6
        ylabel('');
    end
end
end