function c = getParticleCenter(A)
% GETPARTICLECENTER 通过此函数手动对图片序列A中的颗粒进行定位，并返回相应的中心坐标矩阵c
% 
% 输入
%   A - 图片序列，四维，第一二维对应图片的行列，第三维对应图片序列，第四维对应不同的颗粒
% 输出
%   c - 中心坐标矩阵，三维，第一维是图片序列，第二维是x、y坐标，第三维是不同的颗粒

    f = figure('WindowKeyPressFcn',@tempCallback);
    global coords_inFun k
    c = zeros(size(A,3),2,size(A,4));
    
    for jj = 1:size(A,4)
        for ii = 1:size(A,3)
            k = 0;
            ax = axes; 
            imagesc(ax, A(:,:,ii,jj));
            axis off; axis square;
            uiwait(f)
            c(ii,:,jj) = coords_inFun;
            delete(ax)
        end
    end
    close
end        


%%
function tempCallback(~, event)
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
