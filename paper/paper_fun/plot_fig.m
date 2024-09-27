function plot_fig(x, y, xl, yl, ind)
% PLOT_FIG 本函数作某一个子图的图，用在 Fig2 中
    ax = subplot(2, 3, ind);
    plot(x, y, 'LineWidth', 2);
    xlabel('Time (s)'); ylabel('Intensity (a.u.)')
    axis square; ax.FontSize = 12; ax.FontWeight = 'bold';
    xlim(xl); ylim(squeeze(yl));
end
