classdef mphsolver < mphbase
    % 本类继承自mphbase类，并用于计算单个角度照明情况下的散射场
    %   此处显示详细说明

    properties
        filename
        params
        model
        result
    end

    methods
        function obj = mphsolver(filename, varargin)
            %UNTITLED2 构造此类的实例
            %   此处显示详细说明
            obj = obj@mphbase(filename, varargin);
            obj = mphcalcu(obj);
        end
    end
end