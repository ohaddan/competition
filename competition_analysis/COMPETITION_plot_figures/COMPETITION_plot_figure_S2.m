function COMPETITION_plot_figure_S2(all_schedules)
% Plot the optimzed QL and CATIE schedules
s2 = figure('Position',  [961.6667 41.6667 929.3333 1.3193e+03], Name='Fig.S2');

% Plot the schedules side-by-side
for ii = 0:11
    subplot(12,1,ii+1)
    COMPETITION_plot_schedule(all_schedules(ii).reward_schedule_1, all_schedules(ii).reward_schedule_2);
    title(['Schedule ' num2str(ii)])
    xlabel('')
end
xlabel('Trial')
COMPETITION_save_figure('FigS2', s2);
end
