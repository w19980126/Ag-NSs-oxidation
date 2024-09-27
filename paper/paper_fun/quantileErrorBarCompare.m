function varargout = quantileErrorBarCompare(x, I1, I2, varargin)
% QUANTILEERRORBARCOMPARE 本函数用百分位数画Fig2中的暗场和ROCS的强度曲线图并进行比较。
%
% varargout = quantileErrorBarCompare(x, I1, I2, varargin)
%
% 目的
% 对每个归一化的强度曲线进行作图，每组实验数据做三条曲线，分别对应各时刻的
% 第一、二、三四分位数，然后第一、四分位数之间用patch函数画出阴影效果。用这
% 个方法同时做出DF和ROCS的数据在同一个图中展示以资比较。
%
% 输入（必选）
% x - 横坐标，要求是行向量
% I1 - 实验数据，要求行数与x的长度相同
% I2 - 实验数据，要求行数与x的长度相同
% 输入（可选，键值对）
% 'linewidth' - [默认为2]曲线宽度
% 'linecolor1' - [默认是黑色]线条1的颜色
% 'linecolor2' - [默认是黑色]线条2的颜色
% 'transparent' - [默认是0.2]面透明度

% 处理输入数据
    params = inputParser;
    params.addParameter('linewidth', 2);
    params.addParameter('linecolor1', 'k');
    params.addParameter('linecolor2', 'k');
    params.addParameter('transparent', 0.2);
    
    params.parse(varargin{:});
    
%Extract values from the inputParser
    linewidth =  params.Results.linewidth;
    linecolor1 =  params.Results.linecolor1;
    linecolor2 =  params.Results.linecolor2;
    transparent = params.Results.transparent;

% 处理x坐标，就怕记错了输入格式错误了
    if size(x,1) ~= 1; x = x'; end

% 计算分位数
    Q11 = quantile(I1', 0.25);
    Q12 = quantile(I1', 0.5);
    Q13 = quantile(I1', 0.75);
    Q21 = quantile(I2', 0.25);
    Q22 = quantile(I2', 0.5);
    Q23 = quantile(I2', 0.75);
% 画图
    H = makePlot(x,Q11,Q12,Q13,Q21,Q22,Q23,linewidth,linecolor1,linecolor2,transparent);
    
    if nargout==1
        varargout{1}=H;
    end    
end

%%
function H = makePlot(x,Q11,Q12,Q13,Q21,Q22,Q23,linewidth,linecolor1,linecolor2,transparent)
    figure
    H.ax = axes('Units', 'centimeters','Position',[2 1.6 7.2 5]);
    hold(H.ax, 'on');
    H.mainLine1 = plot(H.ax, x, Q12, 'LineWidth',linewidth, 'Color', linecolor1);
    H.mainLine2 = plot(H.ax, x, Q22, 'LineWidth',linewidth, 'Color', linecolor2);
    mainLineColor1 = get(H.mainLine1,'color');
    edgeColor1 = mainLineColor1+(1-mainLineColor1)*0.55;    
    patchColor1 = mainLineColor1;
    mainLineColor2 = get(H.mainLine2,'color');
    edgeColor2 = mainLineColor2+(1-mainLineColor2)*0.55;    
    patchColor2 = mainLineColor2;

    H.patch1 = patch([x fliplr(x)],[Q11 fliplr(Q13)],1,'parent',H.ax);
    H.patch2 = patch([x fliplr(x)],[Q21 fliplr(Q23)],1,'parent',H.ax);

    set(H.patch1, 'facecolor', patchColor1, 'edgecolor', 'none', 'facealpha', transparent, 'HandleVisibility', 'off')
    set(H.patch2, 'facecolor', patchColor2, 'edgecolor', 'none', 'facealpha', transparent, 'HandleVisibility', 'off')

    %Make pretty edges around the patch. 
    H.edge(1) = plot(H.ax, x, Q11, '-'); H.edge(2) = plot(H.ax, x, Q13, '-');
    H.edge(3) = plot(H.ax, x, Q21, '-'); H.edge(4) = plot(H.ax, x, Q23, '-');

    set([H.edge(1:2)], 'color',edgeColor1, 'HandleVisibility','off')
    set([H.edge(3:4)], 'color',edgeColor2, 'HandleVisibility','off')

    % label
    xlabel('Time (s)'); ylabel('Normalized Intensity (a.u.)')
    
    set(H.ax,'fontname', 'arial')
    set(H.ax,'fontsize',20)
    H.ax.XLim = [min(x) max(x)];
    ymax = max([Q23 Q13],[],'all');     % 在两条曲线的第三四分位数中寻找最大值
    ymin = min([Q21 Q11],[],'all');     % 在两条曲线的第一四分位数中寻找最小值
    ygap = ymax - ymin;
    H.ax.YLim = [ymin-0.1*ygap, ymax+0.25*ygap];
    % axis(H.ax,'square');

end