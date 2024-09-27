function [IJ, ind, p_Cut, RadVar] = houghAngVar(IJ)
%HOUGHANGVAR 此函数通过hough变换对图像中的颗粒进行定位，并返回反应过程中径向强度随时间变化
%   
% 输入：
%   IJ - 处理好的包含有颗粒信息的Fiji类
% 输出:
%   ind - 由于hough变换并不能够识别强度比较弱的颗粒，因此只返回所引导强度的颗粒序号
%   p_Cut - particle cut，颗粒截图数据，是一个四维矩阵，第一二维分别是截图的行和列，第三维是时间序列，第四维是不同的颗粒
%   RadVar - RadialVariation，计算得到的径向变化矩阵，是个三维矩阵，第一维对应角度，第二维对应强度，第三维对应颗粒
    
%% 从IJ中提取信息并读入图片序列
    % ------------------ 路径信息 -----------------------
    filepath = IJ.info.filepath;
    files = IJ.info.files;
    % ------------------- 生成保存路径 ------------------
    temp_path = split(filepath, '\');
    expname = temp_path{end};   temp_path(end) = [];    temp_path = join(temp_path,'\');
    temp_path = temp_path{:};
    savepath = fullfile(temp_path,'Result','原始数据',expname,'角度变化');
    if ~exist(savepath,'dir'); mkdir(savepath); end

    % ------------------ 读入图片序列 --------------------
    num = length(files)/1000;
    for ii = 1:ceil(num)
        IJ.images.(['I' num2str(ii)]) = IJ.batch_imread(ii);
    end
    % ------------------ 通过hough变换识别圆环并定位 ------------
    I0 = squeeze(IJ.images.I1(:,:,1));  
    I3 = imresize(I0,3);    % 对原始图片进行三倍插值
    b = bpass(I3,4,6);      % 低通滤波，但是通过调参可以得到类似圆环的效果
    BW = edge(b,"canny");   % 边缘检测圆环
    [centers, ~, ~] = imfindcircles(BW,[10 20]);    % 识别特定大小的圆环
    % ---------------------- 显示识别效果 --------------------
    centers = (centers-1)/3+1; 
    
    % --------------------- 与原始定位坐标进行比较并重新分别标号 ---------
    coords = IJ.coords; 
    R = hypot(centers(:,1)-coords(:,1)',centers(:,2)-coords(:,2)');
    R = R < 3;  centers(sum(R,2) == 0,:) = []; R(sum(R,2) == 0,:) = [];    
    [row,col] = ind2sub(size(R), find(R==1));   [~,temp] = sort(row); 
    ind = col(temp);    % ind中包含通过hough变换识别出来的颗粒，其中的标号对应原始定位中颗粒的顺序
    figure('visible','off'); imagesc(I0); hold on; plot(centers(:,1), centers(:,2), 'r+')
    for ii = 1:length(ind)
        plot(centers(ii,1), centers(ii,2), 'r+')
        text(centers(ii,1)+5,centers(ii,2)+5, [num2str(ii) '-' num2str(ind(ii))],'color', 'r', 'fontweight','bold');
        % 前一个数字是通过hough定位得到的位置标号，第二个数字则对应最开始的颗粒定位算法得到的颗粒标号
    end
    saveas(gcf,fullfile(savepath,'颗粒定位图.fig'))
    saveas(gcf,fullfile(savepath,'颗粒定位图.tiff'))
    close gcf
%% 从原始图片中获取截图
    r = 10;     % 截取坐标周围±10范围的图片
    scale = 1;
    p_Cut = zeros((2*r+1)*scale, (2*r+1)*scale, length(files), length(ind));
    for ii = 1:length(ind)
        p_Cut(:,:,:,ii) = getScreenShot(IJ.images, centers(ii,:), r, scale);
    end

%% 从截图数据中提取角度变化信息
    RadVar = getRadVar(p_Cut, savepath, ind, scale);
    IJ.angData.p_Cut = p_Cut;
    IJ.angData.RadVar = RadVar;
    IJ.angData.ind = ind;
    save(fullfile(savepath, 'IJ.mat'), 'IJ','-v7.3');
end

%% 函数

function M = getScreenShot(Imgs, center, r, scale)
    sz = size(squeeze(Imgs.I1(:,:,1)));
    num = length(fieldnames(Imgs));
    if num>1
        N = 1000*(num-1) + size(Imgs.(['I' num2str(num)]),3);
    else
        N = size(Imgs.I1,3);
    end
    center = round(center);
    M = zeros((2*r+1)*scale, (2*r+1)*scale, N);
    if center(1)>=r+1 && center(1)<=sz(2)-r && center(2)>=r+1 && center(2)<=sz(1)-r
        if num ~= 1
            for ii = 1:(num-1)
                temp = Imgs.(['I' num2str(ii)]);
                temp = temp(center(2)-r:center(2)+r,center(1)-r:center(1)+r,:);
                M(:,:,(ii-1)*1000+1:ii*1000) = resize3(temp, scale);
            end
        end
        temp = Imgs.(['I' num2str(num)]);
        temp = temp(center(2)-r:center(2)+r,center(1)-r:center(1)+r,:);
        M(:,:,(num-1)*1000+1:end) = resize3(temp, scale);
    end
end

function B = getRadVar(A, savepath, ind, scale)
% 从各颗粒的截图序列数据A中得到相应的角度矩阵B，其中B是一个三维矩阵，第一维
% 表示角度，第二维表示时间序列，第三维表示颗粒

    % -------------------- 初始化 ----------------------
    sz = size(A);  
    r = (sz(1)-1)/2;    % 图片半径
    rho_num = 20;       % 统计多少圈  
    theta_num = 360;    % 统计多少个角度
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
    
    % ---------------- 坐标相关信息 ------------------------
    x = 1+r+linspace(-r,r,sz(1)); y = x; [x,y] = meshgrid(x,y);
    
    % ----------------- 对每张图片的角度信息进行提取并作图保存 ------------
    B = zeros(theta_num, sz(3), sz(4));     % 初始化的角度矩阵
    for pp = 1:sz(4)    % 对不同颗粒进行循环
        A(:,:,:,pp) = A(:,:,:,pp) - mean(squeeze(A(:,:,end,pp)),"all");     % 减去末帧以去偏置
        for rr = 1:rho_num  % 对不同半径的环进行循环
            temp = zeros(theta_num, rho_num, sz(3));
            for tt = 1:sz(3)    % 对不同的时间序列进行循环
                temp(:,rr,tt) = interp2(x,y,squeeze(A(:,:,tt,pp)),squeeze(Postn(:,1,rr)),squeeze(Postn(:,2,rr)));
            end
            B(:,:,pp) = sum(temp,2);
        end
        % ------------------------ 作图 ---------------------------
        figure('Visible','off')
        H.ax(1) = axes('Position',[0.05 0.55 0.4 0.4]);   
            imagesc(H.ax(1), squeeze(normalize(B(:,:,pp),1))); 
            colormap(DF_color)
            title('Normalized Data');
        H.ax(2) = axes('Position',[0.55,0.55,0.4,0.4]);   
            imagesc(H.ax(2), squeeze(B(:,:,pp))); 
            axis square; axis off; colormap(DF_color)
            title('Raw Data');
        H.ax(3) = axes('Position',[0.05 0.05 0.4 0.4]);  
            plot(H.ax(3), squeeze(sum(A(:,:,:,pp),[1 2])));
            xlim([0, sz(3)])
            title('Intensity');
        H.ax(4) = axes('Position',[0.55,0.05,0.4,0.4]);   
            imagesc(H.ax(4), squeeze(A(:,:,1,pp))); 
            axis off; axis square; colormap(DF_color);  hold(H.ax(4), 'on');
            plot(H.ax(4), Postn(:,1,1),Postn(:,2,1),'r.');
            plot(H.ax(4), Postn(:,1,end),Postn(:,2,end),'r.');
            plot(H.ax(4), Postn(:,1,round(rho_num/2)),Postn(:,2,round(rho_num/2)),'r.');
            title('The 1st Fig'); 
        sgtitle(['p-' num2str(pp) '-' num2str(ind(pp))],'fontsize',10,'fontname','arial')
        set(H.ax,'fontsize',10,'fontname','arial')
        saveas(gcf, fullfile(savepath,['p-' num2str(pp) '-' num2str(ind(pp)) '.fig']));
        saveas(gcf, fullfile(savepath,['p-' num2str(pp) '-' num2str(ind(pp)) '.tiff']));
        close(gcf)
    end

end

function B = resize3(A, scale)
% 本函数对三维矩阵进行拓展
    sz = size(A);
    if length(sz) == 2
        sz(3) = 1;
    end
    B = zeros(sz(1)*scale,sz(2)*scale,sz(3));
    for ii = 1:sz(3)
        B(:,:,ii) = imresize(A(:,:,ii),scale);
    end
end