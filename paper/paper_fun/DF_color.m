function p = DF_color(m)

    if nargin < 1
        m = size(get(gcf, 'colormap'), 1); 
    end

    cmap_mat = [215,48,39
244,109,67
253,174,97
254,224,144
255,255,191
224,243,248
171,217,233
116,173,209
69,117,180]/255;
%     cmap_mat = [215,48,39
% 244,109,67
% 253,174,97
% 254,224,144
% 218,218,235
% 188,189,220
% 158,154,200
% 128,125,186
% 106,81,163]/255;
% c1 = [215,48,39
% 244,109,67
% 253,174,97
% 254,224,144]/255;
% c2 = [158,154,200
% 128,125,186
% 106,81,163
% 84,39,143]/255;
% cmap_mat = [c1;(c2)];

cmap_mat = flip(cmap_mat);
    if m > 1 && m <= size(cmap_mat, 1)
        step = floor(size(cmap_mat,1)/(m-1));
        p = cmap_mat(1:step:(step*(m-1)+1),:);
    end

    if m > size(cmap_mat, 1)
        xin = linspace(0, 1, m)';
        xorg = linspace(0, 1, size(cmap_mat, 1));
        p(:, 1) = interp1(xorg, cmap_mat(:,1), xin, 'linear');
        p(:, 2) = interp1(xorg, cmap_mat(:,2), xin, 'linear');
        p(:, 3) = interp1(xorg, cmap_mat(:,3), xin, 'linear');
    end
    
    
end