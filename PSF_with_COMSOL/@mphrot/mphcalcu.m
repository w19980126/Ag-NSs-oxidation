function obj = mphcalcu(obj)
% 此函数计算ROCS各入射角度情况下的远场值
%
    tic    

% --------------------- 照明光方位角 -----------------------
    phi_step = 360/obj.num;
    phi_illums = phi_step:phi_step:360;

% ---------------------- 开始循环 --------------------------
    hw = waitbar(0);
    for ii = 1:obj.num
        waitbar(ii/obj.num, hw, ['第' num2str(ii) '次计算，一共有' num2str(obj.num) '次计算']);
        obj = sigle_angle_calcu(obj, phi_illums(ii));
    end
    delete(hw)
    toc
    
end

