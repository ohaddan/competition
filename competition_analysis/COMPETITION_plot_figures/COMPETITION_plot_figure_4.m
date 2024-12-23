function COMPETITION_plot_figure_4(all_schedules)
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot figure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fig_4 = figure('Name', 'Fig 4', ...
    'Position', [243 902.3333 1382 398.6667]);

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
%% Plot 4.a
subplot(1, 3, 1);
if false % plot correaltion coefficient bar graphs
mean_correlation = mean(empirical_simulated_bias_correlation);
sem_correlation = sem(empirical_simulated_bias_correlation);
plot_5_models_bars(mean_correlation, sem_correlation);

ylabel({'Correlation';'Coefficient'}, 'FontWeight','bold')
ylim([-0.1 1])
end
%% Plot 4.a E[P]
subplot(1, 2, 1);
COMPETITION_plot_choice_probabilities()
cla
[ql_hom_lab_probabilities, ql_hom_online_probabilities, ...
    ql_het_lab_probabilities, ql_het_online_probabilities, ...
    catie_probabilities] = ...
    COMPETITION_empirical_decisions_probabilities();

NUMBER_OF_MODELS = 5;
decisions_p_mean = zeros(1, NUMBER_OF_MODELS);
decisions_p_sem = zeros(1, NUMBER_OF_MODELS);
models_decision_p = {catie_probabilities, ql_het_online_probabilities, ql_hom_lab_probabilities, ql_hom_online_probabilities, ql_het_lab_probabilities};
for ii=1:NUMBER_OF_MODELS
    participant_probability_mean = mean(models_decision_p{ii},2);
    decisions_p_mean(ii) = mean(participant_probability_mean);
    decisions_p_sem(ii) = sem(participant_probability_mean);
end

plot_5_models_bars(decisions_p_mean, decisions_p_sem);
ylim([0.5 0.64])
ytick = 0.5:0.04:0.68;
set(gca, 'YTick', ytick, 'YTickLabels', ytick)
ylabel('E[{\itp}]', 'FontWeight','bold');

%% Plot 4.b E[P] Full distribution
subplot(1, 2, 2);
cla
[ql_hom_lab_probabilities, ql_hom_online_probabilities, ...
    ql_het_lab_probabilities, ql_het_online_probabilities, ...
    catie_probabilities] = ...
    COMPETITION_empirical_decisions_probabilities();

NUMBER_OF_MODELS = 5;

hold on
for ii=1:NUMBER_OF_MODELS
    participant_probability = sort(models_decision_p{ii},2);
    participant_probability_sorted = sort(participant_probability(:)');
    cdf_valus = [1:numel(participant_probability_sorted)]./numel(participant_probability_sorted);
    plot(participant_probability_sorted, cdf_valus ,'Color', model_colors(ii,:), 'LineWidth', (ii==1)+1.5);
end
xlabel('P','FontWeight','bold');
ylabel('CDF','FontWeight','bold');
set(gca,'FontSize', 22);
legend(num2str(model_ids'), 'Location', 'NorthWest')
% ytick = 0.5:0.04:0.68;
% set(gca, 'YTick', ytick, 'YTickLabels', ytick)
% ylabel('E[{\itp}]', 'FontWeight','bold');
%% Plot 4.c E[log(p)] log-probabilities
subplot(1, 3, 3);

decisions_log_p_mean = zeros(1, NUMBER_OF_MODELS);
decisions_log_p_sem = zeros(1, NUMBER_OF_MODELS);
models_decision_p = {catie_probabilities, ql_het_online_probabilities, ql_hom_lab_probabilities, ql_hom_online_probabilities, ql_het_lab_probabilities};
for ii=1:NUMBER_OF_MODELS
    participant_log_probability_mean = mean(log(models_decision_p{ii}),2);
    decisions_log_p_mean(ii) = mean(participant_log_probability_mean);
    decisions_log_p_sem(ii) = sem(participant_log_probability_mean);
end
plot_5_models_bars(decisions_log_p_mean, decisions_log_p_sem);
ylim([-0.9 0])
ylabel('E[log({\itp})]', 'FontWeight','bold');

%%
COMPETITION_save_figure('Fig4', fig_4)

%% Plot all histograms
IS_PLOT_PROBABILITY_HISTOGRAMS = false;
if IS_PLOT_PROBABILITY_HISTOGRAMS
    
    model_names = {'CATIE', 'QL Heterogeneous (online)',...
        'QL Homogeneous (Lab)', 'QL Homogeneous (online)', 'QL Heterogeneous Lab'};
    for ii=1:NUMBER_OF_MODELS
        subplot(5,2,(ii-1)*2 + 1)
        cla
        hold on
        choice_probability = models_decision_p{ii};
        histogram(choice_probability(:), 0:0.005:1,'Normalization','pdf', 'EdgeAlpha',.2);
        title(model_names{ii}, 'FontSize',18);
        xline(mean(choice_probability(:)), '--r', 'LineWidth', 2);
        xlabel('P[Decision]','FontSize',14)
        ylabel('PDF', 'FontSize',14);
        xlim([0 1])
    end

    for ii=1:NUMBER_OF_MODELS
        subplot(5,2,(ii-1)*2 + 2)
        cla
        hold on
        ylabel('pdf')
        title(model_names{ii}, 'FontSize',18);
        choice_probability = models_decision_p{ii};
        histogram(log(choice_probability(:)), -3:0.01:0, 'Normalization','pdf', 'EdgeAlpha',.2);
        xlabel('log(P[Decision]','FontSize',14)
        xline(mean(log(choice_probability(:))), '--r', 'LineWidth', 2);
        ylabel('PDF', 'FontSize',14);
        xlim([-3 0])
    end
end
end