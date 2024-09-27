function I_cut = get_cut_video(obj_copy, F, ind, savepath, varargin)
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
%   'figOpt' - [默认是'on']作图选项，若是on，则画图
%   'position' - [默认是 [0.4 0.4 0.1 0.1]]图片的大小
% 输出
%   I_cut - 截图矩阵，是一个四维矩阵，每一维分别对应：截图的行、截图的列、第几个颗粒、
%   颗粒的第几帧


% ---------------------- 处理输入数据 -------------------
    p = inputParser;
    addParameter(p,'r',10);
    addParameter(p,'figOpt','on');
    addParameter(p,'position',[0.4 0.4 0.1 0.1]);
    parse(p,varargin{:});

    r = p.Results.r;    figOpt = p.Results.figOpt;  postn = p.Results.position;

% ---------------------- 读入图片并截图 -------------------
    filepath = obj_copy.info.filepath;
    files = dir(filepath);  files(1:2) = [];        files = namesort(files);
    start_frame = obj_copy.info.stend(1);
    end_frame = obj_copy.info.stend(2);
    I_cut = zeros(2*r+1, 2*r+1, length(F));
    F = F + start_frame;
    coord = round(obj_copy.coords(ind,:));    % 颗粒在图片中的(x,y)坐标
    I_start = double(imread(fullfile(filepath,files(start_frame).name)));
    I_start = I_start(coord(2)-r:coord(2)+r,coord(1)-r:coord(1)+r);
    I_end = double(imread(fullfile(filepath,files(end_frame).name)));
    I_end = I_end(coord(2)-r:coord(2)+r,coord(1)-r:coord(1)+r);
    for ii = 1:length(F)    % 循环不同帧
        I = double(imread(fullfile(filepath,files(F(ii)).name)));
        I_cut(:,:,ii) = I(coord(2)-r:coord(2)+r,coord(1)-r:coord(1)+r);
        I_cut(:,:,ii) = (squeeze(I_cut(:,:,ii))-mean(I_end,"all"))./mean(I_start-I_end,"all");
    end

% ------------------- 作图并保存 ---------------------
    expname = split(filepath,'\');
    expname = expname{end-1};
    date_char = split(char(datetime));
    date_char = date_char{1};
    saveroute = fullfile(savepath, [expname date_char]);
    if ~exist(saveroute,'dir'); mkdir(saveroute); end

    if strcmp(figOpt, 'on')
        for ii = 1:length(F)    % 先循不同的颗粒，即依次做不同颗粒的图
            figure; ax = axes('Position',postn);
            imagesc(ax, squeeze(I_cut(:,:,ii)));
            axis square; axis off; colormap(DF_color); 
            clim([min(I_cut(:,:,ii),[],'all'),0.9*max(I_cut(:,:,ii),[],'all')])
            figname = [num2str([ind F(ii)])];
            colorbar;   set(ax,'fontname','arial','fontsize',20)
            saveas(gcf, fullfile(saveroute,[figname '.fig']));
            saveas(gcf, fullfile(saveroute,[figname '.tiff']))
        end
    end
end