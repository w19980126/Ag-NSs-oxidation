classdef mphrot < mphbase
    %此类用于COMSOL旋转照明成像
    %   此处显示详细说明

    properties
        num
        s_phy_savepath       % 某一个特定物理模型（比如某一具体朝向）的数据所保存的文件夹
        model
        result
    end

    methods
        function obj = mphrot(filename, varargin)
            % mphrot的构造函数
            %   此处显示详细说明
% ----------------------------- 处理输入参数 --------------------------------
            params = inputParser;
            addRequired(params, 'filename');
            addParameter(params, 'num', 36);
            addParameter(params, 'other_params', {});
            % ---------------------------- 处理num参数 -----------------------
            ind = 0; 
            for ii = 1:length(varargin); if strcmp(varargin{ii}, 'num'); ind = ii; break; end; end
            if ind == 0
                temp = cell(1,2); temp{1} = 'other_params'; temp{2} = varargin; 
            else
                temp = cell(1,4); temp(1:2) = varargin(ind:ind+1); varargin(ind:ind+1) = []; temp(3:4) = {'other_params', varargin}; 
            end
            parse(params, filename, temp{:});

% ---------------------------- 保存参数 ---------------------------------------
            obj = obj@mphbase(filename, varargin{:});
            obj.num = params.Results.num;

% --------------------------- 创建保存某一物理模型对应的各角度照明的总文件夹 --------------------------
            if ~exist(obj.savepath, 'dir'); mkdir(obj.savepath); end
            files = dir(obj.savepath); files(1:2) = [];
            s_phy_savepath = fullfile(obj.savepath, ['result_' num2str(1+length(files))]);      % some_physical_model_savepath
            if ~exist(s_phy_savepath, 'dir'); mkdir(s_phy_savepath); end
            obj.s_phy_savepath = s_phy_savepath;

        end

% --------------------------- 计算各角度的数据 -------------------------------
        obj = mphcalcu(obj);
        
    end
end