function Fig3()
%FIG42 对处理得到的统计数据作图
% 
% 说明：
%   本函数得到两张图，第一张图不同浓度下颗粒反应时长图，第二章是不同浓度下，闪烁的颗粒占比
    
%% 读取反应时间数据并进行统计反应时间
    result_path = 'E:\work\SPR-DF\Ag-FeCl3\20230730-ZKLM-浓度-30mW\Result\原始数据';    
    files = dir(result_path);
    files([1:2 14 17 18]) = [];    
    c = log10([10 60:10:100 200 500 1000 15:5:50])';  % 氧化剂浓度，单位 uM
    Q1 = c;    Q2 = Q1; Q3 = Q2;

    for ii = 1:length(files)
        IJ_path = fullfile(result_path, files(ii).name);
        temp = load(fullfile(IJ_path, 'IJ.mat'));   field = fields(temp);
        BET = temp.(field{1}).statistics.BET;
        BET(BET(:,2)<0, :) = [];      % 若判断为背景/未反应，则剔除此数据
        BET(BET(:,2)==0, 2) = max(BET(:,2));       % 若未反应完，令其反应时间为最长反应时间
        BET(:,3) = BET(:,2) - BET(:,1);
% -------------------------- 分位数 ----------------------------        
        % Q1(ii) = quantile(log10(BET(:,3)), 0.25);
        % Q2(ii) = quantile(log10(BET(:,3)), 0.5);
        % Q3(ii) = quantile(log10(BET(:,3)), 0.75);
        Q1(ii) = quantile(log10(1./BET(:,3)), 0.25);           % 按钱博的意思，改成速度量纲
        Q2(ii) = quantile(log10(1./BET(:,3)), 0.5);
        Q3(ii) = quantile(log10(1./BET(:,3)), 0.75);

    end

% ---------------------------- 数据剪裁与重排 ------------------------
    [~, ind1] = sort(c);
    c = c(ind1); Q1 = Q1(ind1); Q2 = Q2(ind1); Q3 = Q3(ind1);
    
    ind1 = [1 4 9 14 15 16 17]';     % 选择这几组浓度作图（10、25、50、100、200、500、1000）

%% 评估闪烁情况
    load('E:\work\SPR-DF\Ag-FeCl3\20230730-ZKLM-浓度-30mW\Result\统计数据\peak_data.mat')
    ind2 = [1 12 17 6 7 8 9]; 
    ratioOfBlink = zeros(length(ind2), 1);    % 闪烁颗粒数统计向量，长度对应参与统计的浓度数，每一个元素统计该组数据中闪烁的颗粒占比
    field = fields(npeaks); Q = zeros(length(ind2), 1); % 统计向量，用于评估每组实验中，存在闪烁的颗粒中颗粒闪烁的平均次数
    for ii = 1:length(ind2)      
        temp = npeaks.(string(field(ind2(ii))));
        temp_field = fields(temp);
        n_peaks = zeros(length(temp_field), 1);    % 用于统计闪烁情况的临时向量，长度与颗粒数对应，每个元素对应一个颗粒闪烁次数
        for jj = 1:length(temp_field)
            n_peaks(jj) = temp.(string(temp_field(jj))).n_peaks;
            if n_peaks(jj)
                ratioOfBlink(ii) = ratioOfBlink(ii) + 1;
            end
        end
        n_peaks(n_peaks==0) = [];   Q(ii) = mean(n_peaks);
        ratioOfBlink(ii) = ratioOfBlink(ii)/length(temp_field);
    end

%% 反应时间作图
% -------------------- 图片数据 -------------------
    % p = [0.3 0.3 0.4 0.4];
    p1 = [4.5,3.5,3.5,3.5];
    p2 = [4.5,8.5,3.5,1.5];

    mainLineColor1 = [203,24,29]/255;
    edge_color1 = mainLineColor1+(1-mainLineColor1)*0.55; 
    figure; ax11 = axes('unit','centimeters','Position',p1);   hold(ax11, 'on')
    ax12 = axes('unit','centimeters','Position',p2); set(ax12, 'box', 'on')
% ------------------- 作图 -----------------------
    plot(ax11, c(ind1), Q1(ind1), '-', 'Color', edge_color1); 
    plot(ax11, c(ind1), Q2(ind1), '-', 'Color', mainLineColor1, 'LineWidth', 2);
    plot(ax11, c(ind1), Q3(ind1), '-', 'Color', edge_color1); 
    patch1 = patch([c(ind1); flipud(c(ind1))],[Q1(ind1); flipud(Q3(ind1))],1,'parent', ax11);
    ymin = min(Q3); ymax = max(Q1); ygap = ymax - ymin;
    y_lim = [ymin-0.15*ygap, ymax+0.15*ygap];
    set(patch1, 'facecolor', mainLineColor1, 'edgecolor', 'none', 'facealpha', 0.2, 'HandleVisibility', 'off')
    xticks(ax11, [1 2 3]); xticklabels(ax11, {'10','100','1000'})
    % yticks(ax11, [0 1 2 3]); yticklabels(ax11, {'1', '10','100','1000'})
    yticks(ax11, [-3 -2 -1 0]); yticklabels(ax11, {'1', '10','100','1000'})            % 按钱博意思改
    xlabel(ax11, 'Concentration (\mu M)');    ylabel(ax11, 'Reaction rate (s^{-1})')
    set(ax11, 'fontname','arial','fontsize',16,'box','on'); 
    line(ax11, [log10(30.1486) log10(30.1486)],[-3 0])
    line(ax11, [log10(141.7710) log10(141.7710)],[-3 0]);
    ylim(ax11, y_lim);

%% 闪烁次数统计
% -------------------- 数据拟合 -------------------
    x0 = c(ind1);       % x0为原始数据对应的横坐标
    y1 = Q ; y2 = ratioOfBlink ;    % y1和y2分别对应原始的闪烁次数统计和闪烁颗粒占比数据
    f = @(k,t) k(1)./(1+exp(-k(2).*(t-k(3))));  % 使用sigmoid函数对数据进行拟合，假设数据是无偏的（事实上有偏置
    k10 = [8 1 1.7];    k20 = [1 1 1.5];    % 初始拟合参数
    k1 = lsqcurvefit(f, k10, x0, y1- min(Q))
    k2 = lsqcurvefit(f, k20, x0, y2- min(ratioOfBlink))

% -------------------- 图片数据 -------------------
    markerColor = [33,113,181]/255;   lineColor = [203,24,29]/255;
    figure; ax21 = axes('unit','centimeters','Position',p1);  hold(ax21, 'on')
    ax22 = axes('unit','centimeters','Position',p2); set(ax22, 'box', 'on')

    % ---------------------- 闪烁次数统计 ---------------------
    x_lim = [0.8 3.2];  x = linspace(x_lim(1), x_lim(2), 100);
    plot(ax21, x0, y1, 'o','MarkerSize',6, 'MarkerEdgeColor', markerColor,'LineWidth',2); 
    plot(ax21, x, f(k1,x)+min(y1), 'linewidth',2, 'Color', lineColor); 
    ylim(ax21, [0.5 9.5]);    xticks(ax21, [1 2 3]); xticklabels(ax21, {'10','100','1000'})
    set(ax21, 'fontname','arial','fontsize',16,'box','on');
    xlabel(ax21, 'Concentration (\mu M)');    ylabel(ax21, 'Blinking Times')
    line(ax21, [log10(30.1486) log10(30.1486)],[0 3])
    line(ax21, [log10(141.7710) log10(141.7710)],[0 3])

% -------------------- 图片数据 -------------------
    figure; ax31 = axes('unit','centimeters','Position',p1);  hold(ax31, 'on')
    ax32 = axes('unit','centimeters','Position',p2); set(ax32, 'box', 'on')

    % ---------------------- 闪烁颗粒占比统计 ---------------------
    x_lim = [0.8 3.2];  x = linspace(x_lim(1), x_lim(2), 100);
    plot(ax31, x0, y2, 'o','MarkerSize',6, 'MarkerEdgeColor', markerColor,'LineWidth',1); 
    plot(ax31, x, f(k2,x)+min(y2), 'linewidth',2, 'Color', lineColor); 
    ylim(ax31, [0 1.2]);    xticks(ax31, [1 2 3]); xticklabels(ax31, {'10','100','1000'})
    set(ax31, 'fontname','arial','fontsize',16,'box','on');
    xlabel(ax31, 'Concentration (\mu M)');    ylabel(ax31, 'Proportion')
        
    line(ax31, [log10(30.1486) log10(30.1486)],[0 3])
    line(ax31, [log10(141.7710) log10(141.7710)],[0 3])

end