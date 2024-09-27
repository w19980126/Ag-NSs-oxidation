function obj = init_model(obj, phi_illum)
% 本函数设置COMSOL模型参数，并运行之
%

% -------------------------------- 初始化 ---------------------------
    import com.comsol.model.*
    import com.comsol.model.util.*
    ModelUtil.showProgress(true)

% ----------------------------- 设置参数 ----------------------------
    model = mphopen(obj.filename);            % 读入 COMSOL 模型
    model.param.set('r_particle', [num2str(obj.params.COMSOL.r_particle) '[nm]']);
    model.param.set('h_particle', [num2str(obj.params.COMSOL.h_particle) '[nm]']);
    model.param.set('phi_illum', [num2str(phi_illum) '[deg]']);
    model.param.set('theta_illum',  [num2str(obj.params.COMSOL.theta_illum) '[deg]']);
    model.param.set('n_water', num2str(obj.params.RETOP.refractive_indices(1)));
    model.param.set('n_glass', num2str(obj.params.RETOP.refractive_indices(2)));
    model.param.set('phi_illum', [num2str(phi_illum) '[deg]']);

    strs = split(obj.filename, '\');
    switch strs{end}
        case 'single_particle.mph'
            if strcmp(obj.params.COMSOL.mat, 'Ag')
                model.component('comp1').material('Ag').active(true);
            elseif strcmp(obj.params.COMSOL.mat, 'AgCl')
                model.component('comp1').material('AgCl').active(true);
            else
                erro('未识别材料，目前只支持对银和氯化银颗粒进行计算');
            end
        case 'inclusion_1.mph'
            model.param.set('theta_dir',  [num2str(obj.params.COMSOL.theta_dir) '[deg]']);              % 颗粒极角朝向
            model.param.set('theta_span', [num2str(obj.params.COMSOL.theta_span) '[deg]']);         % 颗粒反应大小
            model.param.set('phi_dir', [num2str(obj.params.COMSOL.phi_dir) '[deg]']);                       % 颗粒方位角朝向
        case 'inclusion_1_hyp.mph'
            model.param.set('theta_dir',  [num2str(obj.params.COMSOL.theta_dir) '[deg]']);              % 颗粒极角朝向
            model.param.set('phi_dir', [num2str(obj.params.COMSOL.phi_dir) '[deg]']);                       % 颗粒方位角朝向
            model.param.set('c', num2str(obj.params.COMSOL.c));
            model.param.set('a', num2str(obj.params.COMSOL.a));
        case 'inclusion_2.mph'
            model.param.set('alpha', [num2str(obj.params.COMSOL.alpha) '[deg]']);                       % aos方位角取向
            model.param.set('beta', [num2str(obj.params.COMSOL.beta) '[deg]']);                       % aos极角取向
            model.param.set('gamma', [num2str(obj.params.COMSOL.gamma) '[deg]']);                       % aos自转角取向
            model.param.set('included_angle', [num2str(obj.params.COMSOL.included_angle) '[deg]']);                       % 两patch夹角
            model.param.set('theta_span1', [num2str(obj.params.COMSOL.theta_span1) '[deg]']);                       % patch1张角大小
            model.param.set('theta_span2', [num2str(obj.params.COMSOL.theta_span2) '[deg]']);                       % patch2张角大小
        case 'inclusion_2_主体是氯化银-银斑块散布.mph'
            model.param.set('alpha', [num2str(obj.params.COMSOL.alpha) '[deg]']);                       % aos方位角取向
            model.param.set('beta', [num2str(obj.params.COMSOL.beta) '[deg]']);                       % aos极角取向
            model.param.set('gamma', [num2str(obj.params.COMSOL.gamma) '[deg]']);                       % aos自转角取向
            model.param.set('included_angle', [num2str(obj.params.COMSOL.included_angle) '[deg]']);                       % 两patch夹角
            model.param.set('theta_span1', [num2str(obj.params.COMSOL.theta_span1) '[deg]']);                       % patch1张角大小
            model.param.set('theta_span2', [num2str(obj.params.COMSOL.theta_span2) '[deg]']);                       % patch2张角大小
        case 'core_shell.mph'
            model.param.set('r_Ag',  [num2str(obj.params.COMSOL.r_Ag) '[nm]']);              % 颗粒极角朝向
        case 'core_shell_free_space.mph'
            model.param.set('r_Ag',  [num2str(obj.params.COMSOL.r_Ag) '[nm]']);              % 颗粒极角朝向
        case 'nanorod.mph'
            model.param.set('d_rod',  [num2str(obj.params.COMSOL.d_rod) '[nm]']);              % 纳米棒直径
            model.param.set('AR',  num2str(obj.params.COMSOL.AR));              % 纳米棒长径比
            if strcmp(obj.params.COMSOL.mat, 'Ag')
                model.component('comp1').material('Ag').active(true);
            elseif strcmp(obj.params.COMSOL.mat, 'AgCl')
                model.component('comp1').material('AgCl').active(true);
            else
                erro('未识别材料，目前只支持对银和氯化银颗粒进行计算');
            end
    end

% -------------------------- 计算并保存运行结果 --------------------------
    model.sol('sol1').runAll;       % 运行模型
    obj.model = model;

end