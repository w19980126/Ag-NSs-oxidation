function get_cut_video(obj_copy1, obj_copy2, F1, F2, ind1, ind2, savepath, varargin) 
%GET_CUT_VIDEO 通过此函数从obj_copy所对应的数据集中获得相应的图片截图
%   
% I_cut =  get_cut_video(obj_copy, Frame, ind, savepath, ...)
%
% 输入（必选的）
%   obj_copy - Fiji类，里面包含了读取图片所需要的路径等信息
%   F - 各颗粒对应的帧数（从obj_copy的起始帧开始计算，而不是从源文件夹的第一帧开始计算）
%   ind - 颗粒所引，即对应于obj_copy中的哪些颗粒
%   savepath - 生成图片的保存路径
% 输入（可选的，键值对）
%   'r' - [默认是10]截图的半径
%   'lineColor' - 指定曲线颜色
% 输出
%   I_cut - 截图矩阵，是一个四维矩阵，每一维分别对应：截图的行、截图的列、第几个颗粒、
%   颗粒的第几帧


% ---------------------- 处理输入数据 -------------------
    p = inputParser;
    addParameter(p,'r',10);
    addParameter(p,'lineColor1', '#cb181d')
    addParameter(p,'lineColor2', '#2171b5')
    parse(p,varargin{:});

    r = p.Results.r; lineColor1 = p.Results.lineColor1;   lineColor2 = p.Results.lineColor2;   

% ---------------------- 读入图片并截图 -------------------
    filepath1 = obj_copy1.info.filepath;        % DF 数据
    files = dir(filepath1);  files(1:2) = [];
    start_frame = obj_copy1.info.stend(1);
    end_frame = obj_copy1.info.stend(2);
    I_cut1 = zeros(2*r+1, 2*r+1, length(F1));
    F1 = F1 + start_frame;
    for ii = 1:length(F1)    % 循环不同的颗粒
        coord = round(obj_copy1.coords(ind1,:));    % 颗粒在图片中的(x,y)坐标
        I_start = double(imread(fullfile(filepath1,files(start_frame).name)));
        I_start = I_start(coord(2)-r:coord(2)+r,coord(1)-r:coord(1)+r);
        I_end = double(imread(fullfile(filepath1,files(end_frame).name)));
        I_end = I_end(coord(2)-r:coord(2)+r,coord(1)-r:coord(1)+r);
        I = double(imread(fullfile(filepath1,files(F1(ii)).name)));
        I_cut1(:,:,ii) = I(coord(2)-r:coord(2)+r,coord(1)-r:coord(1)+r);
        I_cut1(:,:,ii) = (squeeze(I_cut1(:,:,ii))-mean(I_end,"all"))./mean(I_start-I_end,"all");
    end
    F1 = F1 - start_frame;

    filepath2 = obj_copy2.info.filepath;    % ROCS 数据
    files = dir(filepath2);  files(1:2) = [];
    start_frame = obj_copy2.info.stend(1);
    end_frame = obj_copy2.info.stend(2);
    I_cut2 = zeros(2*r+1, 2*r+1, length(F2));
    F2 = F2 + start_frame;
    for ii = 1:length(F1)    % 循环不同的颗粒
        coord = round(obj_copy2.coords(ind2,:));    % 颗粒在图片中的(x,y)坐标
        I_start = double(imread(fullfile(filepath2,files(start_frame).name)));
        I_start = I_start(coord(2)-r:coord(2)+r,coord(1)-r:coord(1)+r);
        I_end = double(imread(fullfile(filepath2,files(end_frame).name)));
        I_end = I_end(coord(2)-r:coord(2)+r,coord(1)-r:coord(1)+r);
        I = double(imread(fullfile(filepath2,files(F2(ii)).name)));
        I_cut2(:,:,ii) = I(coord(2)-r:coord(2)+r,coord(1)-r:coord(1)+r);
        I_cut2(:,:,ii) = (squeeze(I_cut2(:,:,ii))-mean(I_end,"all"))./mean(I_start-I_end,"all");
    end
    F2 = F2 - start_frame;

% ------------------- 作图并保存 ---------------------
    date_char = split(char(datetime));
    date_char = date_char{1};
    savepath = fullfile(savepath, 'video');
    if ~exist(savepath,'dir'); mkdir(savepath); end
    saveroute = fullfile(savepath, [date_char '处理']);
    anim = VideoWriter([saveroute '.avi']);
    anim.FrameRate = 100;
    x1 = F1/(obj_copy1.info.fps);
    x2 = F2/(obj_copy1.info.fps);
    I1 = squeeze(obj_copy1.Intensities(:,1,ind1)); I1 = matNormalize(I1);
    I2 = squeeze(obj_copy2.Intensities(:,1,ind2)); I2 = matNormalize(I2);
    p1 = [0.1,0.63,0.3,0.3];    p2 = [0.53,0.63,0.4,0.3];   % DF 截图和曲线坐标数据
    p3 = [0.1,0.13,0.3,0.3];    p4 = [0.53,0.13,0.4,0.3];   % ROCS 截图和曲线坐标数据
    open(anim)
    clim1 = [min(I_cut1,[],'all'),0.9*max(I_cut1,[],'all')];
    clim2 = [min(I_cut2,[],'all'),0.9*max(I_cut2,[],'all')];
    ygap1 = max(I1) - min(I1);  ygap2 = max(I2) - min(I2);
    ymin1 = min(I1)-0.1*ygap1;  ymax1 = max(I1)+0.1*ygap1;
    ymin2 = min(I2)-0.1*ygap2;  ymax2 = max(I2)+0.1*ygap2;
    figure('Visible','off')
    hw = waitbar(0, ['一共' num2str(length(F1)) '帧，已处理' num2str(0) '帧']);
    for ii = 1:length(F1)
        ax1 = subplot('Position', p1); ax2 = subplot('Position', p2); hold(ax2, 'on')
        ax3 = subplot('Position', p3); ax4 = subplot('Position', p4); hold(ax4, 'on')
        imagesc(ax1, I_cut1(:,:,ii)); axis(ax1,'off'); axis(ax1,'square'); colormap(ax1, DF_color); clim(ax1, clim1);
        line(ax1, 11+0.5/(7.4/108)*[-1 1], [18 18],'linewidth',4,'color','w')
        imagesc(ax3, I_cut2(:,:,ii)); axis(ax3,'off'); axis(ax3,'square'); colormap(ax3, DF_color); clim(ax3, clim2);
        line(ax3, 11+0.5/(7.4/108)*[-1 1], [18 18],'linewidth',4,'color','w')
        plot(ax2, x1(1:ii), I1(F1(1:ii)), 'linewidth', 2, 'Color', lineColor1); axis(ax2, [x1(1) x1(end) ymin1 ymax1])
        xlabel(ax2, 'Time (s)'); ylabel(ax2, 'Intensity (a.u.)'); set(ax2, 'fontname','arial','fontsize',10)
        plot(ax4, x2(1:ii), I2(F2(1:ii)), 'linewidth', 2, 'Color', lineColor2); axis(ax4, [x2(1) x2(end) ymin2 ymax2])
        xlabel(ax4, 'Time (s)'); ylabel(ax4, 'Intensity (a.u.)'); set(ax4, 'fontname','arial','fontsize',10)
        f = getframe(gcf);
        writeVideo(anim, f);
        waitbar(ii/length(F1), hw, ['一共' num2str(length(F1)) '帧，已处理' num2str(ii) '帧'])
    end
    close(anim);
    delete(hw)

end