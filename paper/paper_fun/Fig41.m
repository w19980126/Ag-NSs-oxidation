function Fig41(A1, A17)
%FIG41 通过A1组数据和A17组数据做Fig4的图1
% 
% 输入：
%   A1：对应浓度为 10uM 的数据
%   A17：对应浓度为 1mM 的数据
% 说明：
%   本函数得到两张图，第一张图是两组数据中各挑出一个有代表性的颗粒进行对比；
%   第二张图则对数据进行统计，得到反应趋势图的对比。
    
%% 读取强度数据
    I1 = A1.Intensities;    I17 = A17.Intensities;
    BET1 = A1.statistics.BET;   BET17 = A17.statistics.BET;
    I1(:, :, BET1(:,2)<0) = [];    I17(:, :, BET17(:,2)<0) = [];    % 没有反应的颗粒，不计入内，避免误识颗粒
    I1(:, :, end) = []; I17(:,:,end) = [];      % 最后一组数据是统计图，不计入内
    x_step1 = A1.info.increment/A1.info.fps;    x_step17 = A17.info.increment/A17.info.fps; 
    start1 = round(BET1(1)/x_step1);    start17 = round(BET17(1)/x_step17);
    I1 = I1(start1:end,:,:);    I17 = I17(start17:end,:,:);
    I1 = squeeze(I1(:,3,:));    I17 = squeeze(I17(:,3,:));  % 选择去背景的数据，因为有的背景实在糟糕
    I1 = matNormalize(I1);  I17 = matNormalize(I17);
    %% 两个浓度下单个颗粒的强度曲线对比
    p = [0.15 0.15 0.65 0.65];
    ind1 = 1; ind17 = 52;
    x1 = x_step1*(1:size(I1,1));    x17 = x_step17*(1:size(I17,1));
    figure
    ax1 = axes('Position',p);   ax17 = axes('Position',p);
    L1 = plot(ax1, x1, I1(:,ind1), 'LineWidth',2,'Color','#cb181d'); 
    L17 = plot(ax17, x17, I17(:,ind17), 'LineWidth',2,'Color','#2171b5');
    axis(ax1, [0 1100 -0.1 3.25]); axis(ax17, [0 5 -0.1 3.25])
    axes(ax1); legend("10 \muM"); axis square;  axes(ax17); legend("1 mM"); axis square;    
    xlabel('Time (s)');
    ylabel('Intensity (a.u.)')
    set(ax1,'Color','None', 'XAxisLocation', 'top', 'YTick', [], 'FontName', 'arial', 'FontSize',20, 'XColor', '#cb181d');
    set(ax17,'Color','None', 'XAxisLocation', 'bottom', 'FontName', 'arial', 'FontSize',20,'XColor', '#2171b5');

    %% 两个浓度下强度统计图
    Q1_1 = quantile(I1', 0.25); Q1_2 = quantile(I1', 0.5);  Q1_3 = quantile(I1', 0.75);
    Q17_1 = quantile(I17', 0.25); Q17_2 = quantile(I17', 0.5);  Q17_3 = quantile(I17', 0.75);
    figure
    ax1 = axes('Position',p);   hold(ax1, 'on');    
    mainLineColor1 = get(L1, 'Color'); edge_color1 = mainLineColor1+(1-mainLineColor1)*0.55;   
    plot(ax1, x1, Q1_1, '-', 'Color', edge_color1); 
    plot(ax1, x1, Q1_2, '-', 'Color', mainLineColor1, 'LineWidth', 2);
    plot(ax1, x1, Q1_3, '-', 'Color', edge_color1); 
    patch1 = patch([x1 fliplr(x1)],[Q1_1 fliplr(Q1_3)],1,'parent', ax1);
    set(patch1, 'facecolor', mainLineColor1, 'edgecolor', 'none', 'facealpha', 0.2, 'HandleVisibility', 'off')

    ax17 = axes('Position',p);   hold(ax17, 'on');    
    mainLineColor17 = get(L17, 'Color'); edge_color17 = mainLineColor17+(1-mainLineColor17)*0.55;   
    plot(ax17, x17, Q17_1, '-', 'Color', edge_color17); 
    plot(ax17, x17, Q17_2, '-', 'Color', mainLineColor17, 'LineWidth', 2);
    plot(ax17, x17, Q17_3, '-', 'Color', edge_color17); 
    patch17 = patch([x17 fliplr(x17)],[Q17_1 fliplr(Q17_3)],1,'parent', ax17);
    set(patch17, 'facecolor', mainLineColor17, 'edgecolor', 'none', 'facealpha', 0.2, 'HandleVisibility', 'off')

    axis(ax1, [0 1100 -0.1 3.25]); axis(ax17, [0 5 -0.1 3.25])
    axes(ax1); legend("10 \muM"); axis square;  axes(ax17); legend("1 mM"); axis square;    
    xlabel('Time (s)');
    ylabel('Intensity (a.u.)')
    set(ax1,'Color','None', 'XAxisLocation', 'top', 'YTick', [], 'FontName', 'arial', 'FontSize',20, 'XColor', '#cb181d');
    set(ax17,'Color','None', 'XAxisLocation', 'bottom', 'FontName', 'arial', 'FontSize',20,'XColor', '#2171b5');
    box on
end