function D = DataDensity(I, varargin)
%DATADENSITY 展示矩阵中各数据的集中度和整体趋势，用在Fig2中
%   
%   D = DataDensity(I)
%   D = DataDensity(I, n)
%   D = DataDensity(I, n, lim)
%
%   说明：密度矩阵D只是原数据矩阵I的另一种呈现，对于由多条一维曲线构成的数据矩阵I而言，很难在
%   一个图中将所有的曲线都展示出来，这里用密度矩阵D的形式对矩阵I进行展示。具体而言，我们对每一
%   帧下的所有颗粒强度进行统计，得到相应地概率分布，记录在矩阵D中。
%
%   输入参数：
%       I   待处理的数据矩阵，其第一维对应时间序列，第二维对应不同的颗粒
%       n   输出的密度矩阵D的列数，若不声明，默认为100
%       lim 输出的密度矩阵的上下限，若不声明，则默认为矩阵I中的最大值和最小值
%   输出参数：
%       D   密度矩阵
    
    p = inputParser;
    addRequired(p,'I');         % 添加必须参数 I
    addOptional(p,'n',100);     % 添加可选参数 n，若不声明，则默认是100
    addParameter(p,'lim',[min(I(:)), max(I(:))]);    % 密度矩阵的范围，若不明确，则是I的最值
    parse(p,I,varargin{:});
    
    I = p.Results.I;    n = p.Results.n;    lim = p.Results.lim;
    D = zeros(size(I,1), n);        % 为密度矩阵分配内存
    delta = (lim(2)-lim(1))/n;      % 强度间隔
    f = 1/delta;                    % 取整缩放参数，通过此参数，对原始数据进行线性缩放，使得密度矩阵的强度以1为步进
    I_scale = I;
    I_scale(I<lim(1)) = lim(1);     % 掐头去尾
    I_scale(I>lim(2)) = lim(2);
    I_scale = f*(I_scale-lim(1))+1; % 对原始数据I去偏置并进行线性缩放
    I_quant = round(I_scale);       % 对缩放后的数据进行量化
    for ii = 1:size(I,1)
        tab = tabulate(I_quant(ii,:));
        for jj = 1:size(tab,1)
            D(ii, tab(jj,1)) = tab(jj,2);
        end
    end
end