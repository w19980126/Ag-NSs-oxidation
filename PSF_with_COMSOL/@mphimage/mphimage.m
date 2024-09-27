classdef mphimage
    % 此类用于基于物方远场计算相机端点扩散函数
    %   此处显示详细说明

    properties
        mph_farfield          % 远场数据（远场类）
        num         % 角度数
        I
        E
    end

   properties (Hidden)
     M = 100
     f1 = 1.8e-3
     f2 = 180e-3
     n1 = 1.5142
     n2 = 1
     x = [-0.5e3, 0.5e3]
     y = [-0.5e3, 0.5e3]
     z = 0
     NA = 1.49
   end

    methods
        function obj = mphimage(mph_farfield)
            %UNTITLED10 构造此类的实例
            %   此处显示详细说明
            obj.mph_farfield = mph_farfield;
            obj.num = length(fieldnames(mph_farfield.result));
            obj = ROCS_image(obj, mph_farfield);
        end
    end
end