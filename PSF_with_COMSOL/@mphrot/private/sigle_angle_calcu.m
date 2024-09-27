function obj = sigle_angle_calcu(obj, phi_illum)
% 本函数计算某一个方位角度照明情况下的散射远场

% ------------------------- 模型初始化 ----------------------- 
    obj = init_model(obj, phi_illum);        % 模型初始化并计算
    
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
    obj = model_output(obj, angles_dn, phi_illum);
    obj.model.sol('sol1').clearSolution;

% ------------------------------- 创建单个角度的保存文件夹并保存 ---------------
    phi_savepath = fullfile(obj.s_phy_savepath, ['phi_illum_' num2str(phi_illum)]);       % 文件夹名
    if ~exist(phi_savepath, 'dir'); mkdir(phi_savepath); end            % 创建文件夹
    mphname = split(obj.filename, '\'); mphname = mphname{end};
    mphsave(obj.model, fullfile(phi_savepath, mphname));            % 保存单个角度的COMSOL文件
    save(fullfile(phi_savepath, 'RETOP_Data.mat'), "angles_dn", '-v7.3');       % 保存单个角度的远场数据
end