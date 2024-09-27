function obj = mphcalcu(obj)

% ---------------------------- 初始化 -----------------------------
    tic    

    % 模型初始化
    obj= init_model(obj);        % 模型初始化并计算
    cal_champ = @(x,y,z) extract_comsol_field(obj.model, x, y, z, obj.params.RETOP.opt_field);       % RETOP 工具包中从 COMSOL 文件运行结果中提取电场的函数
    init = retop(cal_champ,obj.params.RETOP.wavenumber, ...
        obj.params.RETOP.refractive_indices, obj.params.RETOP.z_layers, ...
        obj.params.RETOP.box_center, obj.params.RETOP.box_size, ...
        obj.params.RETOP.N_gauss, ...
        struct('option_cal_champ', 2, 'option_i', obj.params.RETOP.option_i));

    % 定义极角、方位角
    [teta,~]        =   retgauss(0,pi/2,10,3);                  % polar angle
    [phi,~]         =   retgauss(0,2*pi,10,7);                  % azimuthal angle
    [Teta,Phi]      =   ndgrid(teta,phi);                       % generate the grid
    u               =   sin(Teta).*cos(Phi);                    % weight in x-coordinate
    v               =   sin(Teta).*sin(Phi);                    % weight in y-coordinate

% --------------------------- 计算 -------------------------------
    % 下半空间中远场计算
    if imag(obj.params.RETOP.refractive_indices(end))==0
        ub          =   obj.params.RETOP.wavenumber*obj.params.RETOP.refractive_indices(end)*u;   % 下半空间中波矢 x 分量，kx=ub
        vb          =   obj.params.RETOP.wavenumber*obj.params.RETOP.refractive_indices(end)*v;   % 下半空间中波矢 y 分量，ky=vb
        direction   =   -1;                                     % 下半空间
        angles_dn   =  retop(init,ub,vb,direction);             % planewave decomposition for the lower space
    end

% ------------------------------- 输出远场量 ----------------------------------
    obj = model_output(obj, angles_dn);
    
%     ModelUtil.remove('Model')
    toc
end

%% 函数
function obj = init_model(obj)
    model = mphopen(obj.filename);            % 读入 COMSOL 模型
    model.param.set('r_particle', [num2str(obj.params.COMSOL.r_particle) '[nm]']);
    model.param.set('h_particle', [num2str(obj.params.COMSOL.h_particle) '[nm]']);
    model.param.set('phi_illum', [num2str(obj.params.COMSOL.phi_illum) '[deg]']);
    model.param.set('theta_illum',  [num2str(obj.params.COMSOL.theta_illum) '[deg]']);

    strs = split(obj.filename, '\');
    switch strs{end}
        case 'Ag,mph'
            
        case 'inclusion_1.mph'
            model.param.set('theta_dir',  [num2str(obj.params.COMSOL.theta_dir) '[deg]']);
            model.param.set('theta_span', [num2str(obj.params.COMSOL.theta_span) '[deg]']);
            model.param.set('phi_dir', [num2str(obj.params.COMSOL.phi_dir) '[deg]']);
        case 'inclusion_2.mph'

    end
    
    model.sol('sol1').runAll;       % 运行模型
    obj.model = model;

end

function obj = model_output(obj, angles_dn)
    NA = 1.49;          % 物镜数值孔径
    E_farfield = angles_dn.EH(:, 1:3);                             
    k_norm = angles_dn.k./vecnorm(angles_dn.k, 2, 2);   % 波矢方向矢量
    E_farfield(:,[2 3]) =  -E_farfield(:,[2 3]);                   % 坐标轴改成朝下为正
    k_norm(:,[2 3])  = -k_norm(:,[2 3]);
    
    theta_out = acos(k_norm(:,3));                       % 物方极角
    theta_max = asin(NA/obj.params.RETOP.refractive_indices(2));       % 物镜收集到的最大角度
    
    obj.result.E_farfield = E_farfield(theta_out < theta_max, :);           % 对电场进行筛选，只保留能够被物镜收集的部分
    obj.result.k_norm = k_norm(theta_out < theta_max, :);
    obj.result.theta_out = theta_out(theta_out < theta_max);
    obj.result.phi_out = atan2(obj.result.k_norm(:,2),obj.result.k_norm (:,1));           % 物像双方方位角 
end