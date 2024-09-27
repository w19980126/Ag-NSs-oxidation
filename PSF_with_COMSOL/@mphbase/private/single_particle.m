function  obj = single_particle(obj, varargin)

    param = inputParser;
    addRequired(param,'obj');
    addParameter(param, 'theta_illum', 64);       % 照明光极角，单位°，默认 64°
    addParameter(param, 'phi_illum', 0);       % 照明光方位角，单位 °，默认 0°
    addParameter(param, 'h_particle', 3);   % 颗粒高度，单位 nm，默认 3nm
    addParameter(param, 'r_particle', 30);  % 颗粒半径，单位 nm，默认 30nm
    addParameter(param, 'mat', 'Ag');  % 想要计算的颗粒的材料，默认对银颗粒进行计算
    addParameter(param, 'savepath', '');   % 保存路径，默认不保存，此时不保存
    parse(param, obj, varargin{:});
    
    obj.params.COMSOL = param.Results;
    obj.params.RETOP.opt_field = 'std2_rel';
    obj.savepath = param.Results.savepath;

end