function obj = get_param(obj)
    obj.params.RETOP.wavelength              = 660e-9;                           % 真空中波长
    obj.params.RETOP.wavenumber            =   2*pi/obj.params.RETOP.wavelength;          % 真空中波数
    obj.params.RETOP.refractive_indices     = [1.331, 1.5142];               % 介质折射率
    obj.params.RETOP.z_layers                    =   [0];                                % 层高
    obj.params.RETOP.box_center               =   [0, 0, 0];                         % 盒子中心 
    obj.params.RETOP.box_size                    =   [400, 400, 400]*1e-9;   % 盒子长宽高
    obj.params.RETOP.option_i                    =   1;                                   % 对应exp(iwt)
    obj.params.RETOP.N_gauss                    =   [8,8;8,8;8,8];                   % box上的采样点数
end