function COMPETITION_save_figure(fig_name, fig)
%SAVE_FIGURE Summary of this function goes here
%   Detailed explanation goes here
if nargin==1
    fig=gcf;
end
FIGURES_FOLDER = 'COMPETITION_figures';
formats = {'png', 'svg', 'fig'};
for format=formats
    saveas(fig, [FIGURES_FOLDER '/' fig_name '.' format{1}]);
end
end