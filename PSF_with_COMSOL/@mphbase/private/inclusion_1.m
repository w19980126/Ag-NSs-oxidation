function  obj = inclusion_1(obj, varargin)

    param = inputParser;
    addRequired(param,'obj');
    addParameter(param, 'theta_illum', 64);       % 照明光极角，单位°，默认 64°
    addParameter(param, 'phi_illum', 0);       % 照明光方位角，单位 °，默认 0°
    addParameter(param, 'theta_dir', 90);       % patch极角，单位°，默认 90°
    addParameter(param, 'theta_span', 50);      % patch大小，单位°，默认50°
    addParameter(param, 'phi_dir', 0);          % patch 方位角，单位°，默认0°
    addParameter(param, 'h_particle', 3);   % 颗粒高度，单位 nm，默认 3nm
    addParameter(param, 'r_particle', 30);  % 颗粒半径，单位 nm，默认 30nm
    addParameter(param, 'savepath', '');   % 保存路径，默认不保存，此时不保存
    parse(param, obj, varargin{:});
    
    obj.params.COMSOL = param.Results;
    obj.params.RETOP.opt_field = 'std2_rel';
    obj.savepath = param.Results.savepath;

end