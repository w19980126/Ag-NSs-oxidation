function  obj = inclusion_2(obj, varargin)

    param = inputParser;
    addRequired(param,'obj');

% ----------------------------- 照明光性质 ----------------------------------
    addParameter(param, 'theta_illum', 64);       % 照明光极角，单位°，默认 64°
    addParameter(param, 'phi_illum', 0);       % 照明光方位角，单位 °，默认 0°

% ------------------------------ 颗粒属性 ----------------------------------
    addParameter(param, 'h_particle', 3);   % 颗粒高度，单位 nm，默认 3nm
    addParameter(param, 'r_particle', 30);  % 颗粒半径，单位 nm，默认 30nm

% ------------------------------- 张角属性 ----------------------------------
    addParameter(param, 'alpha', 0);       % aos方位角取向，对应欧拉角的α，单位°，默认0°
    addParameter(param, 'beta', 0);      % aos极角取向，对应欧拉角的β，单位°，默认0°
    addParameter(param, 'gamma', 0);          % aos自转角取向，对应欧拉角的γ，单位°，默认0°
    addParameter(param, 'included_angle', 120);          % 两球心连线夹角，表征两patch的远近，单位°，默认张角120°，

    addParameter(param, 'theta_span1', 50);          % patch1 张角，单位°，默认0°
    addParameter(param, 'theta_span2', 50);          % patch2 张角，单位°，默认0°

% ------------------------------ 保存路径 -----------------------------------
    addParameter(param, 'savepath', '');   % 保存路径，默认不保存，此时不保存

% ------------------------------ 处理输入变量 ------------------------------
    parse(param, obj, varargin{:});
    obj.params.COMSOL = param.Results;
    obj.params.RETOP.opt_field = 'std2_rel';
    obj.savepath = param.Results.savepath;

end