function obj = ROCS_image(obj, mph_farfield)
% 本函数从包含有COMSOL远场计算数据的mph_farfield类中计算相机端点扩散函数
% 本函数可以计算ROCS的图案，也可以计算单角度点扩散函数，是一样的
%

% ---------------------------- 初始化 --------------------------
    fields = fieldnames(mph_farfield.result);
    I = zeros(101, 101, obj.num);
    E = zeros(101, 101, 3, obj.num);

% --------------------------- 循环计算各角度PSF ---------------------
    for ii = 1:length(fields)
        theta1 = mph_farfield.result.(fields{ii}).theta_out;
        phi1 = mph_farfield.result.(fields{ii}).phi_out;
        fe1 = mph_farfield.result.(fields{ii}).E_farfield;
        [fe2, theta2, phi2] = image_farrfield(theta1, phi1, fe1, obj.M, obj.n1, obj.n2);
        [E(:,:,:,ii), I(:,:,ii)] = Vect_Imaging(theta2, phi2, fe2, mph_farfield.params.RETOP.wavelength, obj.M, obj.f2, obj.x, obj.y, obj.z);
    end

% ----------------------- 保存数据 -----------------------------------
    obj.E = E;      obj.I = I;
  
    save(fullfile(mph_farfield.s_phy_savepath, 'aggregated_data.mat'), 'mph_farfield', 'I', 'E', '-v7.3');
end