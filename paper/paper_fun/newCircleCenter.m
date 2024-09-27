function coords = newCircleCenter(A, varargin)
%NEWCIRCLECENTER 此函数手动校正颗粒定位中心
%   
% 输入：
%   A - 各颗粒的图像序列第一帧
% 输入（可选，键值对）
%   ind - (默认是[])想要定位的颗粒序号，默认是空，表示对所有颗粒定位
%   coords - (默认是[])重新定位后的颗粒坐标，如果想要对特定的颗粒进行重定位，则
%           此项就是想要更新的颗粒坐标，程序将对特定颗粒进行定位并更新坐标
% 输出
%   coords - 重定位的颗粒或者更新后的颗粒坐标

%%
% 处理输入数据
    p = inputParser;
    addParameter(p,'ind',[]);
    addParameter(p,'coords',[]);
    parse(p,varargin{:});

    ind = p.Results.ind;    coords = p.Results.coords;

% 判断输入数据
    if isempty(ind)
        ind = 1:size(A,3);  % 如果未指明对第几个颗粒进行定位，那么就默认对所有的颗粒进行重定位
        coords = zeros(length(ind), 2);
    end
    global coords_inFun k

% 开始定位
    figure('WindowKeyPressFcn',{@circleCenterCallback})
    for ii = 1:length(ind)
        k = 0;
        ax = axes;  
        imagesc(ax,squeeze(A(:,:,ind(ii))));
        colormap(DF_color); axis equal; axis off
        uiwait(gcf)
        delete(ax)
        coords(ind(ii), 1) = coords_inFun(1);
        coords(ind(ii), 2) = coords_inFun(2);
    end
    close
end

%%
function circleCenterCallback(~, event)
%UNTITLED3 此处显示有关此函数的摘要
%   此处显示详细说明

% ------------ 清理上次的曲线 -------------------
    ax = findobj(gcf, 'type', 'axes');
    I = findobj(gcf,'type','image');
    I = I.CData;
    sz = size(I);   r = (sz(1)-1)/2;
    hold(ax,'on');  
    axis(ax, 'equal');  axis(ax, 'off')
    hs = findobj(ax, 'Type', 'Scatter');
    delete(hs)
    global coords_inFun k
    if k == 0
        coords_inFun = [r r] + 1;
        theta = linspace(0,2*pi,360);
        rx = coords_inFun(1) + [0.5*cos(theta) 2*cos(theta) 3*cos(theta) 4*cos(theta) 5*cos(theta)];
        ry = coords_inFun(2) + [0.5*sin(theta) 2*sin(theta) 3*sin(theta) 4*sin(theta) 5*sin(theta)];
        scatter(ax, rx, ry, 'r.');
    end
    

% ------------- 判断响应 -------------------
    if strcmpi(event.Key,'rightarrow')
        k = k + 1;
        coords_inFun(1) = coords_inFun(1) + 0.1;
    elseif strcmpi(event.Key,'leftarrow')
        k = k + 1;
        coords_inFun(1) = coords_inFun(1) - 0.1;
    elseif strcmpi(event.Key,'uparrow')
        k = k + 1;
        coords_inFun(2) = coords_inFun(2) - 0.1;
    elseif strcmpi(event.Key,'downarrow')
        k = k + 1;
        coords_inFun(2) = coords_inFun(2) + 0.1;
    else
        uiresume(gcf);
    end 
        theta = linspace(0,2*pi,360);
        rx = coords_inFun(1) + [0.5*cos(theta) 2*cos(theta) 3*cos(theta) 4*cos(theta) 5*cos(theta)];
        ry = coords_inFun(2) + [0.5*sin(theta) 2*sin(theta) 3*sin(theta) 4*sin(theta) 5*sin(theta)];
        scatter(ax, rx, ry, 'r.');
end
