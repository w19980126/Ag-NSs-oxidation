function obj = model_output(obj, angles_dn, phi_illum)
% 本函数用于整理从RETOP推演出的COMSOL远场计算结果
%

% --------------------------- 整理数据 ----------------------------------
    phi_illum = ['phi_illum_' num2str(phi_illum)];          % 对该方位角命名
    NA = 1.49;          % 物镜数值孔径
    E_farfield = angles_dn.EH(:, 1:3);                             
    k_norm = angles_dn.k./vecnorm(angles_dn.k, 2, 2);   % 波矢方向矢量
    E_farfield(:,[2 3]) =  -E_farfield(:,[2 3]);                   % 坐标轴改成朝下为正
    k_norm(:,[2 3])  = -k_norm(:,[2 3]);
    theta_out = acos(k_norm(:,3));                       % 物方极角
    theta_max = asin(NA/obj.params.RETOP.refractive_indices(2));       % 物镜收集到的最大角度

% ---------------------------- 保存数据 ----------------------------------
    obj.result.(phi_illum).E_farfield = E_farfield(theta_out < theta_max, :);           % 对电场进行筛选，只保留能够被物镜收集的部分
    obj.result.(phi_illum).k_norm = k_norm(theta_out < theta_max, :);
    obj.result.(phi_illum).theta_out = theta_out(theta_out < theta_max);
    obj.result.(phi_illum).phi_out = atan2(obj.result.(phi_illum).k_norm(:,2),obj.result.(phi_illum).k_norm(:,1));           % 物像双方方位角 
end