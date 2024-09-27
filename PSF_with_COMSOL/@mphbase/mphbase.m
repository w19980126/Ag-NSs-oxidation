classdef mphbase
    %此类用于初始化COMSOL模型

    %%
    properties
        filename
        savepath
        params
    end

    %%
    methods
        function obj = mphbase(filename, varargin)
          %  mphsolver 的构造函数
          %
          %  Usage :
          %    obj = mphbase( filename, PropertyName, PropertyValue, ... )
          %  PropertyName
          %    'theta_dir'     :  patch的极角朝向，单位 °， 默认是 90°，对于多个patch，则是矢量
          %    'theta_span'        :  patch 的大小，单位 °，默认是 10°，对于多个patch，则是矢量
          %    'phi_dir'      :  patch的方位角朝向，单位 °，默认是 0°，对于多个patch，则是矢量
          %    'r_particle'    :  颗粒半径，单位 nm，默认 30 nm
          %    'h_particle'    :  颗粒距离基底高度，单位 nm，默认 1 nm

            obj.filename = filename;
            obj = init(obj, varargin{:});
        end
    end
end