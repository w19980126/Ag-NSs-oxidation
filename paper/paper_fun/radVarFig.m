function radVarFig(IJ, ind, fig_ind, varargin)
%RADVARFIG 此函数用于展示单颗粒反应过程中角度的变化
%   
% 输入(必选)
%   IJ - 处理好的IJ数据，里面包含有必要的角度信息
%   ind - 想要处理的颗粒的序号，这个序号对应hough变换定位的颗粒序号
%   fig_ind - 想要集中展示的图案的序号
% 输入(可选，键值对)
%   Color - 曲线颜色

% 处理输入数据
    params = inputParser;
    params.addParameter('Color', 'k');    
    params.parse(varargin{:});
    
% Extract values from the inputParser
    Color =  params.Results.Color;
    if isempty(fig_ind); fig_ind = [1 size(IJ.Intensities,1)]; end
    
% 从IJ结构体中读取作图需要的数据    
    if isfield(IJ.angData,'RadVar_upDate')
        A = squeeze(IJ.angData.RadVar_upDate(:,fig_ind(1):fig_ind(2),ind));
    else
        A = squeeze(IJ.angData.RadVar(:,fig_ind(1):fig_ind(2),ind));
    end
    A = normalize(A,1,'range');     % 角度数据，Angle
    I = squeeze(IJ.Intensities(fig_ind(1):fig_ind(2), 3, IJ.angData.ind(ind)));
    % I = squeeze(IJ.angData.p_Cut(:,:,fig_ind(1):fig_ind(2),ind));
    % I = squeeze(sum(I,[1 2])); 
    I = matNormalize(I);            % 强度数据，Intensity
    xstep = IJ.info.increment/IJ.info.fps;
    x = xstep*(1:length(I));

% 图片参数
    figure; 
    H.ax(1) = axes('units', 'centimeters','Position',[6,7,4,3]);
    imagesc(H.ax(1), A); 
    colormap(DF_color); axis tight; colorbar
    xlabel('Time (s)'); ylabel('Theta (\circ)');
    set(gca,'FontName','arial','fontsize',16);
    
    ymin = min(I);  ymax = max(I); ygap = ymax - ymin;

    H.ax(2) = axes('units', 'centimeters','Position',[6,1,4,3]);
    plot(H.ax(2), x, I, 'LineWidth', 0.75, 'Color', Color);
    xlim([x(1) x(end)]); ylim([ymin-0.1*ygap, ymax+0.1*ygap])
    xlabel('Time (s)'); ylabel('Intensity (a.u.)');
    set(gca,'FontName','arial','fontsize',16);
end