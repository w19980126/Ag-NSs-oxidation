function varargout = quantileErrorBar(x, I, varargin)
% QUANTILEERRORBAR 本函数用百分位数画Fig2中的暗场和ROCS的强度曲线图。
%
% varargout = quantileErrorBar(x, I, varargin)
%
% 目的
% 对每个归一化的强度曲线进行作图，每组实验数据做三条曲线，分别对应各时刻的
% 第一、二、三四分位数，然后第一、四分位数之间用patch函数画出阴影效果。
%
% 输入（必选）
% x - 横坐标，要求是行向量
% I - 实验数据，要求行数与x的长度相同
% 输入（可选，键值对）
% 'linewidth' - [默认为2]曲线宽度
% 'linecolor' - [默认是黑色]线条颜色
% 'transparent' - [默认是0.2]面透明度

% 处理输入数据
    params = inputParser;
    params.addParameter('linewidth', 2);
    params.addParameter('linecolor', 'k');
    params.addParameter('transparent', 0.2);
    params.addParameter('pstn', [0.3 0.3 0.4 0.4]);
    
    params.parse(varargin{:});
    
    %Extract values from the inputParser
    linewidth =  params.Results.linewidth;
    linecolor =  params.Results.linecolor;
    transparent = params.Results.transparent;
    pstn = params.Results.pstn;

% 处理x坐标，就怕记错了输入格式错误了
    if size(x,1) ~= 1; x = x'; end

% 计算分位数
    I = matNormalize(I);
    Q1 = quantile(I', 0.25);
    Q2 = quantile(I', 0.5);
    Q3 = quantile(I', 0.75);
% 画图
    H = makePlot(x,Q1,Q2,Q3,linewidth,linecolor,transparent, pstn);
    
    if nargout==1
        varargout{1}=H;
    end    
end

%%
function H = makePlot(x,Q1,Q2,Q3,linewidth,linecolor,transparent, pstn)
    figure
    H.ax = axes('Position', pstn);
    hold(H.ax, 'on');
    H.mainLine = plot(H.ax, x, Q2, 'LineWidth',linewidth, 'Color', linecolor);
    mainLineColor = get(H.mainLine,'color');
    edgeColor = mainLineColor+(1-mainLineColor)*0.55;    
    patchColor = mainLineColor;
    
    H.patch = patch([x fliplr(x)],[Q1 fliplr(Q3)],1,'parent',H.ax);

    set(H.patch, ...
      'facecolor', patchColor, ...
      'edgecolor', 'none', ...
      'facealpha', transparent, ...
      'HandleVisibility', 'off')
    
    %Make pretty edges around the patch. 
    H.edge(1) = plot(H.ax, x, Q1, '-');
    H.edge(2) = plot(H.ax, x, Q3, '-');
    
    set([H.edge], 'color',edgeColor, ...
      'HandleVisibility','off')
    xlabel('Time (s)'); ylabel('Intensity (a.u.)'); box on
    set(H.ax,'fontname', 'arial')
    set(H.ax,'fontsize',20)
    H.ax.XLim = [min(x) max(x)];
    H.ax.YLim = [min(Q1)-(max(Q3)-min(Q1))*0.1, max(Q3)+(max(Q3)-min(Q1))*0.1];
    axis(H.ax,'square');
    
end