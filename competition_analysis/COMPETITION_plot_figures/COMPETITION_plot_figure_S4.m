function COMPETITION_plot_figure_S4(all_schedules)

SAVED_CALCULATION_PATH = 'COMPETITION_plot_figures/COMPETITION_plot_figures_saved_calculation/COMPETITION_figure_s4.mat';
if exist(SAVED_CALCULATION_PATH, 'file') == 2
    % If it exists, load the result variable
    load(SAVED_CALCULATION_PATH, ...
        'empirical_biases_mean', 'catie_biases_mean', ...
        'ql_hom_lab_biases_mean', 'ql_hom_lab_biases_mean', ...
        'ql_hom_online_biases_mean', 'ql_het_lab_biases_mean', ...
        'ql_het_online_biases_mean', ...
        'catie_biases_sem', 'empirical_biases_sem');
else
    % Calculate data for the figure
    REPETITIONS = 1e4;
    N_SCHEDULES = 12;

    empirical_biases_mean = zeros(1, N_SCHEDULES);
    catie_biases_mean = zeros(1, N_SCHEDULES);
    ql_hom_lab_biases_mean = zeros(1, N_SCHEDULES);
    ql_hom_online_biases_mean = zeros(1, N_SCHEDULES);
    ql_het_lab_biases_mean = zeros(1, N_SCHEDULES);
    ql_het_online_biases_mean = zeros(1, N_SCHEDULES);

    empirical_biases_sem = zeros(1, N_SCHEDULES);
    catie_biases_sem = zeros(1, N_SCHEDULES);

    % Compute biases for each schedule
    for ii = 1:N_SCHEDULES
        schedule_id = ii-1;
        rewards_1 = all_schedules(schedule_id).reward_schedule_1;
        rewards_2 = all_schedules(schedule_id).reward_schedule_2;

        empirical_biases =        all_schedules(schedule_id).biases;
        catie_biases =            CATIE_schedule_score(rewards_1, rewards_2, REPETITIONS);
        ql_hom_lab_biases =       COMPETITION_QL_HOM_LAB_schedule_score(rewards_1, rewards_2, REPETITIONS);
        ql_hom_online_biases =    COMPETITION_QL_HOM_ONLINE_schedule_score(rewards_1, rewards_2, REPETITIONS);
        ql_het_lab_biases =       COMPETITION_QL_HET_LAB_schedule_score(rewards_1, rewards_2, REPETITIONS);
        ql_het_online_biases =    COMPETITION_QL_HET_ONLINE_schedule_score(rewards_1, rewards_2, REPETITIONS);

        empirical_biases_mean(ii) =        mean(empirical_biases);
        catie_biases_mean(ii) =            mean(catie_biases);
        ql_hom_lab_biases_mean(ii) =       mean(ql_hom_lab_biases);
        ql_hom_online_biases_mean(ii) =    mean(ql_hom_online_biases);
        ql_het_lab_biases_mean(ii) =       mean(ql_het_lab_biases);
        ql_het_online_biases_mean(ii) =    mean(ql_het_online_biases);

        empirical_biases_sem(ii) =        sem(empirical_biases);
        catie_biases_sem(ii) =            sem(catie_biases);
    end
    % Save the computed results
    save(SAVED_CALCULATION_PATH, ...
        'empirical_biases_mean', 'catie_biases_mean', ...
        'ql_hom_lab_biases_mean', 'ql_hom_lab_biases_mean', ...
        'ql_hom_online_biases_mean', 'ql_het_lab_biases_mean', ...
        'ql_het_online_biases_mean', ...
        'catie_biases_sem', 'empirical_biases_sem');
end

% Plot te figure itself
figure('Position', [367.6667 59 796.6667 651.3333])
[~, COLORS_BY_MODEL] = COMPETITION_schedule_colors();
hold on
MARKER_SIZE = 6;
plot(empirical_biases_mean, catie_biases_mean, 'x-', 'Color', COLORS_BY_MODEL.catie, 'LineWidth', 4, 'Marker','o', 'MarkerSize', 10);
plot(empirical_biases_mean, ql_het_lab_biases_mean, 'Color', COLORS_BY_MODEL.ql.het.lab, 'MarkerFaceColor', COLORS_BY_MODEL.ql.het.lab, 'LineWidth', 1, 'Marker','s', 'MarkerSize', MARKER_SIZE);
plot(empirical_biases_mean, ql_het_online_biases_mean, 'Color', COLORS_BY_MODEL.ql.het.online, 'MarkerFaceColor', COLORS_BY_MODEL.ql.het.online, 'LineWidth', 1, 'Marker','o', 'MarkerSize', MARKER_SIZE);
plot(empirical_biases_mean, ql_hom_lab_biases_mean, 'Color', COLORS_BY_MODEL.ql.hom.lab, 'MarkerFaceColor',COLORS_BY_MODEL.ql.hom.lab, 'LineWidth', 1, 'Marker','pentagram', 'MarkerSize', MARKER_SIZE);
plot(empirical_biases_mean, ql_hom_online_biases_mean, 'Color', COLORS_BY_MODEL.ql.hom.online, 'MarkerFaceColor', COLORS_BY_MODEL.ql.hom.online, 'LineWidth', 1, 'Marker', 'diamond', 'MarkerSize', MARKER_SIZE);

% Add error bars, just for CATIE
errorbar(empirical_biases_mean, catie_biases_mean, catie_biases_sem, '.k', 'LineWidth',1);
errorbar(empirical_biases_mean, catie_biases_mean, empirical_biases_sem, '.k', 'horizontal', 'LineWidth',1);


% Customize axis
set(gca,'FontSize', 18, 'XTick', 50:4:70)
ylim([45 75])
xlim([45 75])
plot([0 100], [0 100],'k--')
set(gca,'xtick', 45:5:75, 'ytick',45:5:75)
xlabel('Bias Observed','FontSize', 24,'FontWeight','bold');
ylabel('Bias Predicted','FontSize', 24, 'FontWeight','bold');

% Add legend
legend({...
    ['CATIE ({\itr =}' num2str(round(corr2(empirical_biases_mean, catie_biases_mean),2)) ')'],...
    ['QL-het-lab ({\itr =}' num2str(round(corr2(empirical_biases_mean, ql_het_lab_biases_mean),2)) ')'],...
    ['QL-het-online ({\itr =}' num2str(round(corr2(empirical_biases_mean, ql_het_online_biases_mean),2)) ')'],...
    ['QL-hom-lab ({\itr =}' num2str(round(corr2(empirical_biases_mean, ql_hom_lab_biases_mean),2)) ')'],...
    ['QL-hom-online ({\itr =}' num2str(round(corr2(empirical_biases_mean, ql_hom_online_biases_mean),2)) ')'],...
    },'FontSize', 16, 'Location', 'SouthEast');

% Save figure
COMPETITION_save_figure('FigS4');