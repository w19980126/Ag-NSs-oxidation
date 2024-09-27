function varargout = singleCurveCompare(x, I1, I2, varargin)
% SINGLECURVECOMPARE 本函数对挑选出来的两条曲线进行数据对比展示。
%
% varargout = singleCurveCompare(x, I1, I2, varargin)
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

% 画图
    H = makePlot(x,I1,I2,linewidth,linecolor1,linecolor2);
    
    if nargout==1
        varargout{1}=H;
    end    
end

%%
function H = makePlot(x,I1,I2,linewidth,linecolor1,linecolor2)
    figure
    H.ax = axes('Units', 'centimeters','Position',[2 1.6 7.2 5]);
    hold(H.ax, 'on');
    H.mainLine1 = plot(H.ax, x, I1, 'LineWidth',linewidth, 'Color', linecolor1);
    H.mainLine2 = plot(H.ax, x, I2, 'LineWidth',linewidth, 'Color', linecolor2);
   
    % label
    xlabel('Time (s)'); ylabel('Normalized Intensity (a.u.)')

    set(H.ax,'fontname', 'arial')
    set(H.ax,'fontsize',20)
    H.ax.XLim = [min(x) max(x)];
    ymax = max([I1 I2],[],'all');     % 在两条曲线的中寻找最大值
    ymin = min([I1 I2],[],'all');     % 在两条曲线的寻找最小值
    ygap = ymax - ymin;
    H.ax.YLim = [ymin-0.1*ygap, ymax+0.25*ygap];
    % axis(H.ax,'square');

end