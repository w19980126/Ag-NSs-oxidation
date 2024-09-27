classdef Fiji
    % FIJI 此类用于实现类似于imageJ的从图片序列中读取某个ROI的强度
    %   
    
    properties
        info        % 所有相关信息
        ROIs        % 所有颗粒的ROI，无论最后分析与否
        target_ROIs % 目标颗粒ROI，是一个三维矩阵，前两个维度对应图片大小，第三个维度对应目标颗粒数        
        BG_ROIs     % 每个颗粒对应的背景的roi，同样是一个三维矩阵，与ROIs一一对应
        images      % 导入的图片
        coords      % 各目标颗粒的行列坐标（非整数）
        Intensities % 颗粒强度
        statistics  % 一个结构体，用于存放统计信息
        angData     % 反应过程中角度变化
    end

    properties(Hidden)
        MaskForAllParticles     % 此mask是所有颗粒所对应mask的一个集合，不
                                % 仅包含目标颗粒，同时还包含剔除掉的颗粒，
                                % 利用此mask划定颗粒背景mask，以防止背景中
                                % 含有颗粒强度干扰
        
    end
    
    methods
        function obj = Fiji(filepath, varargin)
            %UNTITLED 构造此类的实例
            %   obj = Intensity_read(filepath)
            %   obj = Intensity_read(filepath, PropertyName, PropertyValue)
            % Name - Value:
            % fps- 采样速率，默认是100fps
            % stend - 始末帧
            % increment - 隔多少帧导入一帧
            
            obj.info.filepath = filepath;
            obj = init(obj, varargin{:});
        end    

        I_batch = batch_imread(obj, ii);
    end
    
    methods(Static)
        function ROI2 = m_trans(ROI1, row_offset, col_offset)
        % 本方法对ROI进行平移操作
            sz = size(ROI1);
            R = eye(sz(1)); C = eye(sz(2));
            R = circshift(R, row_offset, 1);
            C = circshift(C, col_offset, 2);
            ROI2 = R*ROI1*C;
        end

        reaction_Time(result_path);

        [c, Q1, Q2, Q3, xgroupdata, ydata] = reaction_Time_boxchart();

        peaks_statistics(result_path);

        Exp_statistics2 = peaks_boxchart(datapath);
    end
end


