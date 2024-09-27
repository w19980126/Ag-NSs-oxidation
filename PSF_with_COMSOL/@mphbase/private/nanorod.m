function  obj = nanorod(obj, varargin)

    param = inputParser;
    addRequired(param,'obj');
    addParameter(param, 'savepath', '');   % 保存路径，默认不保存，此时不保存

    addParameter(param, 'theta_illum', 64);       % 照明光极角，单位°，默认 64°
    addParameter(param, 'phi_illum', 0);       % 照明光方位角，单位 °，默认 0°
    addParameter(param, 'h_particle', 3);   % 颗粒高度，单位 nm，默认 3nm
    addParameter(param, 'r_particle', 30);  % 这一项本是球形颗粒的参数，此模型不用此参数，但
                                                                % 后面设置模型参数的时候需要设置这个值，不想改了，
                                                                % 所以就保留不删除了

    addParameter(param, 'd_rod', 80);  % 椭球直径，单位 nm，默认 80nm
    addParameter(param, 'AR', 1.2);   % 椭球长径比，默认是 1.2
    addParameter(param, 'mat', 'Ag');  % 想要计算的颗粒的材料，默认对银颗粒进行计算
    
    parse(param, obj, varargin{:});
    
    obj.params.COMSOL = param.Results;
    obj.params.RETOP.opt_field = 'std2_rel';
    obj.savepath = param.Results.savepath;

end