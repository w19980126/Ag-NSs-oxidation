function imgs = batch_imread(obj, num)
% 本函数从obj.filepath路径中读取所有图片并保存在obj.images中
    filepath = obj.info.filepath;
    files = obj.info.files;
    img0 = imread(fullfile(filepath, files(1).name));
    sz = size(img0);
    if length(sz) ~= 3      % 普通相机采集到的图像
        if num*1000 < length(files)
            imgs = zeros([sz, 1000]);
            for ii = 1:1000
                imgs(:,:,ii) = double(imread(fullfile(filepath, files(1000*(num-1)+ii).name)));
            end
        else
            imgs = zeros([sz, (length(files)-(num-1)*1000)]);
            for ii = 1:(length(files)-(num-1)*1000)
                imgs(:,:,ii) = double(imread(fullfile(filepath, files(1000*(num-1)+ii).name)));
            end
        end
    else    % 大恒这个倒霉催的采集到的图像
        if num*1000 < length(files)
            imgs = zeros([sz(1:2), 1000]);
            for ii = 1:1000
                temp = imread(fullfile(filepath, files(1000*(num-1)+ii).name));
                imgs(:,:,ii) = rgb2gray(temp);
            end
        else
            imgs = zeros([sz(1:2), (length(files)-(num-1)*1000)]);
            for ii = 1:(length(files)-(num-1)*1000)
                temp = imread(fullfile(filepath, files(1000*(num-1)+ii).name));
                imgs(:,:,ii) = rgb2gray(temp);
            end
        end
    end
end