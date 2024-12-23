function COMPETITION_plot_figure_S1(all_schedules)
    % Plot the optimzed QL and CATIE schedules
    % s1 = figure('Position',  [961.6667 41.6667 929.3333 1.3193e+03], Name='Fig. S1');
    COMPETITION_plot_figure_S2(all_schedules)
    
    % Define the path to saved computation folder
    CATIE_SAVED_COMPUTATION_PATH = 'CATIE/CATIE_saved_computations/';
    QL_SAVED_COMPUTATION_PATH = 'QL/QL_saved_computations/';

    % Get the most recent optimization results for CATIE
    CATIE_most_recent_optimization_results = get_most_recent_file_path(CATIE_SAVED_COMPUTATION_PATH, 'optimized_CATIE');
    load(CATIE_most_recent_optimization_results, 'CATIE_optimized_1', 'CATIE_optimized_2');
    
    % Get the most recent optimization results for QL
    QL_most_recent_optimization_results = get_most_recent_file_path(QL_SAVED_COMPUTATION_PATH, 'optimized_QL_HOM_LAB');
    load(QL_most_recent_optimization_results, 'optimized_1', 'optimized_2');

    % Plot the schedules side-by-side
    subplot(12,1,11)
    COMPETITION_plot_schedule(optimized_1, optimized_2);
    title('Optimized for QL')
    xlabel('')

    subplot(12,1,12)
    title('Optimized for CATIE')
    COMPETITION_plot_schedule(CATIE_optimized_1, CATIE_optimized_2);
    xlabel('Trial')
    
    % COMPETITION_save_figure('FigS1', s1);
end
