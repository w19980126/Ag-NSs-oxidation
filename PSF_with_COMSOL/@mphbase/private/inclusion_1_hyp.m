function  obj = inclusion_1_hyp(obj, varargin)

    param = inputParser;
    addRequired(param,'obj');
    addParameter(param, 'theta_illum', 64);       % 照明光极角，单位°，默认 64°
    addParameter(param, 'phi_illum', 0);       % 照明光方位角，单位 °，默认 0°
    addParameter(param, 'theta_dir', 90);       % patch极角，单位°，默认 90°
    addParameter(param, 'phi_dir', 0);          % patch 方位角，单位°，默认0°
    addParameter(param, 'h_particle', 3);   % 颗粒高度，单位 nm，默认 3nm
    addParameter(param, 'r_particle', 30);  % 颗粒半径，单位 nm，默认 30nm/习惯性保留参数，不会用到，但删除会报错
    addParameter(param, 'c', 30);   % 颗粒半径，单位 nm，默认是 30nm
    addParameter(param, 'a', 20);   % 双曲线半实轴，单位 nm，默认是 10nm，用a、c确定的双曲线生成 AgCl patch
    addParameter(param, 'savepath', '');   % 保存路径，默认不保存，此时不保存
    parse(param, obj, varargin{:});
    
    obj.params.COMSOL = param.Results;
    obj.params.RETOP.opt_field = 'std2_rel';
    obj.savepath = param.Results.savepath;

end