function [dist, SortedInd] = dtw2(I)
% DTW2 通过动态时间规整 (DTW) 算法计算二维矩阵 I 各列之间的相似性，用在 Fig2 中
%
%   [dist, SortedInd] = dtw2(I)。
%
%   输入参数：
%       I   二维矩阵
%   输出参数：
%       dist        距离矩阵，size(I) = (size(I,2),size(I,2))。表示矩阵 I 各列之间的相似性。
%       SortedInd   排序矩阵，按照相似性从高到低排序，SortedInd 是一个长度为 size(I,2) 的向量。
%
%   计算说明：
%       对矩阵 I 以第一行和最后一行数据进行归一化，由于原来的强度数据最后一列是平均值，因此
%       计算相似度时不考虑这一列数据

    [m,n] = size(I);    % 矩阵 I 的大小
    I = (I-repmat(I(end,:),m,1))./(repmat(I(1,:),m,1)-repmat(I(end,:),m,1));    % 以第一行和最后一行进行归一化
    dist = zeros(n-1, n-1);
    for ii = 1:n-1  % 以 dtw 算法进行相似度计算
        for jj = 1:ii-1 % 因为是对称的，所以只计算一半，另一半转置即可
            dist(ii, jj) = dtw(I(:,ii), I(:,jj));
        end
    end
    dist = dist + dist';

    [~,SortedInd] = sort(sum(dist),'descend');  % 相关度降序排列
    figure
    plot(sum(dist(:,SortedInd)))                % 按照降序对每条曲线的相似性进行展示
    figure
    plot(sum(I(:,SortedInd(1:10)),2));          % 与整体最不相似的十条曲线进行作图
    hold on
    plot(sum(I(:,SortedInd(end-10:end-1)),2));  % 与整体最相似的十条曲线进行作图
    
    figure  % 对相似性矩阵进行作图
    imagesc(dist(SortedInd, SortedInd));
    axis square
    axis off
    colormap(DF_color)
end
