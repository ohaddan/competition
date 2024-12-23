function COMPETITION_plot_figure_S3(all_schedules)
%COMPETITION_PLOT_FIGURE_3 Summary of this function goes here
%   Detailed explanation goes here

empirical_biases = COMPETITION_all_schedules_biases_distribution(all_schedules);
catie_biases = COMPETITION_all_schedules_CATIE_biases_distribution(all_schedules);
% figs3 = figure('Position', [883.6667 625.6667 1.5247e+03 598.6667], 'Name', 'Fig S3');
figs3 = figure('Position', [230.3333 528.3333 1.0193e+03 1.2687e+03], 'Name', 'Fig S3');

MAX_SUBPLOT = 24;
empirical_subplot = [1:4:MAX_SUBPLOT 3:4:MAX_SUBPLOT];
catie_subplot = [2:4:MAX_SUBPLOT 4:4:MAX_SUBPLOT];
for ii=1:12
    subplot(6, 4, empirical_subplot(ii));
    histogram(empirical_biases{ii}, 0:5:100, ...
        'FaceColor', [0.8500 0.3250 0.0980],...
        'Normalization','pdf');
    title(['Empirical: ' num2str(ii)])
    title(['S_{Empirical}: ' num2str(ii-1)])
    title(['Humans: ' num2str(ii-1)])
    ylim([0 .05]);
    set(gca,'FontSize',18)
    hold on;
    
    subplot(6, 4, catie_subplot(ii));
    histogram(catie_biases{ii}, ...
        0:5:100,'FaceColor', [0 0.4470 0.7410],...
        'Normalization','pdf');
    ylim([0 .05]);
    hold on;
    title(['CATIE: ' num2str(ii-1)])
    title(['Schedule_{' num2str(ii-1) '}^{CATIE}'])
    title(['CATIE: ' num2str(ii-1)])
    set(gca,'FontSize',18)
end

for ii=21:24
    subplot(6, 4, ii);
    xlabel('Bias', 'FontWeight','bold');
end
for ii=1:20
    subplot(6, 4, ii);
    set(gca, 'XTick',[])
end

for ii=1:4:24
    subplot(6, 4, ii);
    ylabel('PDF', 'FontWeight','bold');
end
for ii=1:24
    if all(ii~=1:4:24)
        subplot(6, 4, ii);
            set(gca, 'YTick',[])
    end
end

COMPETITION_save_figure('FigS3', figs3);

end

