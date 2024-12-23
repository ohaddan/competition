function COMPETITION_plot_distribution_of_p_and_log_p(all_schedules)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
SAVED_CALCULATION_PATH = 'COMPETITION_plot_figures/COMPETITION_plot_figures_saved_calculation/COMPETITION_figure_4a_calculations.mat';
load(SAVED_CALCULATION_PATH, ...
        'empirical_simulated_bias_correlation', ...
        'models_order');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot figure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure('Name', 'distribution_of_p_and_log_p', ...
    'Position', [662.3333 220.3333 1042 1.0707e+03]);

model_ids = {'CATIE (Schedule 1)', 'QL (Schedule 6)', 'QL (Schedule 7)', 'QL (Schedule 9)', 'QL (Schedule 10)'};

[ql_hom_lab_probabilities, ql_hom_online_probabilities, ...
    ql_het_lab_probabilities, ql_het_online_probabilities, ...
    catie_probabilities] = ...
    COMPETITION_empirical_decisions_probabilities();

NUMBER_OF_MODELS = 5;
decisions_p_mean = zeros(1, NUMBER_OF_MODELS);
decisions_p_sem = zeros(1, NUMBER_OF_MODELS);
models_decision_p = {catie_probabilities, ql_het_online_probabilities, ql_hom_lab_probabilities, ql_hom_online_probabilities, ql_het_lab_probabilities};
for ii=1:NUMBER_OF_MODELS
    choice_probabilities = models_decision_p{ii}(:);
    subplot(5,2,(ii-1)*2+1)
    set(gca,'FontSize',16)
    hold on
    histogram(choice_probabilities,0:0.005:1,'Normalization','probability', 'EdgeAlpha',.2);
    xline(mean(choice_probabilities), '--r', 'LineWidth', 2);
    xlim([0 1])
    title(model_ids{ii})
    if ii==length(model_ids)
        xlabel('\bf\it{p}\rm{\bf(decision)}', 'FontSize', 20)
    end
    if ii==round(length(model_ids)/2)
        ylabel('Probability', 'FontSize', 20, 'FontWeight', 'bold')
    end
    
    subplot(5,2,(ii-1)*2+2)
    set(gca,'FontSize',16)
    hold on
    histogram(log(choice_probabilities), -3:0.01:0, 'Normalization','probability', 'EdgeAlpha',.2);
    xline(mean(log(choice_probabilities)), '--r', 'LineWidth', 2);
    xlim([-3 0])
    title(model_ids{ii})
    if ii==length(model_ids)
        xlabel('\bf\it{p}\rm{\bf(log(decision))}', 'FontSize', 20);
    end
    % if ii==round(length(model_ids)/2)
    %     ylabel('Probability', 'FontSize', 20, 'FontWeight', 'bold')
    % end


end
end