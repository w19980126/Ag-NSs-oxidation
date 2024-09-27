function [B, coords] = radVarUpdate(A, savepath, ind, scale, varargin)
% RADVARUPDATE 从各颗粒的截图序列数据A中得到相应的角度矩阵B，其中B是一个三维矩阵，第一维
% 表示角度，第二维表示时间序列，第三维表示颗粒
%
% 输入
%   A - 截图数据，四维，第一二维对应每张截图的横纵坐标，第三维表示时间序列，第四维表示不同的颗粒
%   savepath - 保存路径
%   ind - 颗粒序号，用于表示hough变换后颗粒序号和原始定位序号之间的关系
%   scale - 放大倍数，一般就是一倍
% 输入（可选，键值对）
%   ind_update - 如果只想对特定颗粒的定位进行更新，则通过此值指定颗粒序号，默认为[]
%   coords - 如果相对特定颗粒的定位进行更新，则通过此值输入所有颗粒的定位，程序将只对特定颗粒的定位进行更新
%   displace - 每帧之间图片序列漂移位移，默认为[0 0]，即不漂移。若sum(displace)==0，则不进行漂移校正
% 输出
%   B - 更新后的角度矩阵
%   coords - 更新后的坐标

%% 
% 处理输入数据
    p = inputParser;
    addParameter(p,'ind_update',[]);
    addParameter(p,'coords',[]);
    addParameter(p,'displace',[0 0]);
    parse(p,varargin{:});

    coords = p.Results.coords;  ind_update = p.Results.ind_update;
    d = p.Results.displace;

% -------------------- 初始化 ----------------------
    sz = size(A);  
    r = (sz(1)-1)/2;    % 图片半径
    rho_num = 20;       % 统计多少圈  
    theta_num = 360;    % 统计多少个角度

    if sum(d) == 0  % 不进行位移校正
        if isempty(ind_update)  % 如果是空的，那么就先对所有的颗粒进行重定位
            ind_update = 1:sz(4);
            coords = newCircleCenter(squeeze(A(:,:,1,:)));
        else    % 如果不是空的，那么就是对特定的颗粒定位进行更新
            coords = newCircleCenter(squeeze(A(:,:,1,:)), 'ind', ind_update, 'coords', coords);
        end
    else    % 进行位移校正，此时默认定位是准确的，且不进行位移校正
        ind_update = 1:sz(4);
    end

    theta = linspace(2*pi,0,theta_num);    % 角度满足通常的笛卡尔坐标系，而不是图像的直角坐标系
    S_step = power(8*scale,2)/rho_num;     % 每一圈包围的面积相等
    r_list = zeros(rho_num,1);  % 半径列表
    r_list(1) = sqrt(S_step/pi);    % 初始半径
    Postn = zeros(theta_num, 2, rho_num);   % 各圈位置Position
    Postn(:,1,1) = r+1+r_list(1)*cos(theta); Postn(:,2,1) = r+1+r_list(1)*sin(theta);   
    % 切记，这里必须要加1，因为这个圆不与x、y轴相切，而是偏离了1个像素的！！！
    for ii = 2:rho_num
        r_list(ii) = r_list(ii-1) + S_step/(2*pi*r_list(ii-1));
        Postn(:,1,ii) = r+1+r_list(ii)*cos(theta);
        Postn(:,2,ii) = r+1+r_list(ii)*sin(theta);
    end
    Postn = repmat(Postn,1,1,1,sz(4));      % 插值位置矩阵，共四维，第一维是角度，第二维是xy中心坐标，第三维是半径，第四维是不同颗粒
    for ii = 1:sz(4)
        Postn(:,1,:,ii) = Postn(:,1,:,ii) + coords(ii,1) - (r+1);
        Postn(:,2,:,ii) = Postn(:,2,:,ii) + coords(ii,2) - (r+1);
    end
% ---------------- 坐标相关信息 ------------------------
    x = 1+r+linspace(-r,r,sz(1)); y = x; [x,y] = meshgrid(x,y);
    
% ----------------- 对每张图片的角度信息进行提取并作图保存 ------------
    B = zeros(theta_num, sz(3), sz(4));     % 初始化的角度矩阵
    for pp = 1:length(ind_update)
        A(:,:,:,ind_update(pp)) = A(:,:,:,ind_update(pp)) - mean(squeeze(A(:,:,end,ind_update(pp))),"all");     % 减去末帧以去偏置
        for rr = 1:rho_num  % 对不同半径的环进行循环
            temp = zeros(theta_num, rho_num, sz(3));
            for tt = 1:sz(3)    % 对不同的时间序列进行循环
                xpostn = squeeze(Postn(:,1,rr,ind_update(pp))) + d(1)*(tt-1);
                ypostn = squeeze(Postn(:,2,rr,ind_update(pp))) + d(2)*(tt-1);
                temp(:,rr,tt) = interp2(x,y,squeeze(A(:,:,tt,ind_update(pp))),xpostn,ypostn);
            end
            B(:,:,ind_update(pp)) = sum(temp,2);
        end
        % ------------------------ 作图 ---------------------------
        figure('Visible','off')
        H.ax(1) = axes('Position',[0.05 0.55 0.4 0.4]);   
            imagesc(H.ax(1), squeeze(normalize(B(:,:,ind_update(pp)),1,'range'))); 
            colormap(DF_color)
            title('Normalized Data');
        H.ax(2) = axes('Position',[0.55,0.55,0.4,0.4]);   
            imagesc(H.ax(2), squeeze(B(:,:,ind_update(pp)))); 
            axis square; axis off; colormap(DF_color)
            title('Raw Data');
        H.ax(3) = axes('Position',[0.05 0.05 0.4 0.4]);  
            plot(H.ax(3), squeeze(sum(A(:,:,:,ind_update(pp)),[1 2])));
            xlim([0, sz(3)])
            title('Intensity');
        H.ax(4) = axes('Position',[0.55,0.05,0.4,0.4]);   
            imagesc(H.ax(4), squeeze(A(:,:,1,ind_update(pp)))); 

            % imagesc(H.ax(4), squeeze(A(:,:,800,ind_update(pp)))); 


            axis off; axis square; colormap(DF_color);  hold(H.ax(4), 'on');
            plot(H.ax(4), Postn(:,1,1,ind_update(pp)),Postn(:,2,1,ind_update(pp)),'r.');
            plot(H.ax(4), Postn(:,1,end,ind_update(pp)),Postn(:,2,end,ind_update(pp)),'r.');

            % plot(H.ax(4), d(1)*800+Postn(:,1,end,ind_update(pp)),d(2)*800+Postn(:,2,end,ind_update(pp)),'r.');


            plot(H.ax(4), Postn(:,1,round(rho_num/2),ind_update(pp)),Postn(:,2,round(rho_num/2),ind_update(pp)),'r.');
            title('The 1st Fig'); 
        sgtitle(['p-' num2str(ind_update(pp)) '-' num2str(ind(ind_update(pp)))],'fontsize',10,'fontname','arial')
        set(H.ax,'fontsize',10,'fontname','arial')
        saveas(gcf, fullfile(savepath,['p-' num2str(ind_update(pp)) '-' num2str(ind(ind_update(pp))) '.fig']));
        saveas(gcf, fullfile(savepath,['p-' num2str(ind_update(pp)) '-' num2str(ind(ind_update(pp))) '.tiff']));
        close(gcf)
    end

end