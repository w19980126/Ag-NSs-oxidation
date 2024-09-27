function I_cut = get_cut(obj_copy, F, ind, savepath, temp_ind, varargin)
%GET_CUT 通过此函数从obj_copy所对应的数据集中获得相应的图片截图
%   
% I_cut =  get_cut(obj_copy, Frame, ind, savepath, ...)
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
    if temp_ind == 1
        files = dir('E:\work\SPR-DF\Ag-FeCl3\20231120_DF_微流控\A1_100fps');   
    else
        files = dir('E:\work\SPR-DF\Ag-FeCl3\20230730-ZKLM-浓度-30mW\A17-1mM');   
    end
    files(1:2) = [];
    start_frame = obj_copy.info.stend(1);
    end_frame = obj_copy.info.stend(2);
    I_cut = zeros(2*r+1, 2*r+1, size(F,1), size(F,2));
    F = F + start_frame;
    for ii = 1:size(F,1)    % 循环不同的颗粒
        coord = round(obj_copy.coords(ind(ii),:));    % 颗粒在图片中的(x,y)坐标
        I_start = double(imread(fullfile(filepath,files(start_frame).name)));
        I_start = I_start(coord(2)-r:coord(2)+r,coord(1)-r:coord(1)+r);
        I_end = double(imread(fullfile(filepath,files(end_frame).name)));
        I_end = I_end(coord(2)-r:coord(2)+r,coord(1)-r:coord(1)+r);
        for jj = 1:size(F,2)    % 循环不同帧
            I = double(imread(fullfile(filepath,files(F(ii,jj)).name)));
            I_cut(:,:,ii,jj) = I(coord(2)-r:coord(2)+r,coord(1)-r:coord(1)+r);
            I_cut(:,:,ii,jj) = (squeeze(I_cut(:,:,ii,jj))-mean(I_end,"all"))./mean(I_start-I_end,"all");
        end
    end

% ------------------- 作图并保存 ---------------------
    expname = split(filepath,'\');
    expname = [expname{end-1} '-' expname{end}];
    date_char = split(char(datetime));
    date_char = date_char{1};
    saveroute = fullfile(savepath, [expname '-' date_char '处理']);
    if ~exist(saveroute,'dir'); mkdir(saveroute); end

    if strcmp(figOpt, 'on')
        for ii = 1:size(F,1)    % 先循不同的颗粒，即依次做不同颗粒的图
             for jj = 1:size(F,2)    % 再循环帧数，对应同一个颗粒的不同帧
                figure; ax = axes('Position',postn);
                imagesc(ax, squeeze(I_cut(:,:,ii,jj)));
                axis square; axis off; colormap(DF_color); 
                clim([min(I_cut(:,:,ii,:),[],'all'),0.9*max(I_cut(:,:,ii,:),[],'all')])
                figname = [num2str([ind(ii) F(ii,jj)])];
                colorbar;   set(ax,'fontname','arial','fontsize',20)
                saveas(gcf, fullfile(saveroute,[figname '.fig']));
                saveas(gcf, fullfile(saveroute,[figname '.tiff']))
            end
        end
    end
end