function  selectOKp(data)
%SELECTOKP 此处显示有关此函数的摘要
%   此处显示详细说明
fig=figure;
imagesc(squeeze(data(1,:,:)));
global dri ringOK
dri=1;
ringOK=zeros(size(data,1),1);
title([num2str(dri),'/',num2str(length(ringOK))]);
set(fig,'WindowButtonDownFcn',{@drnext, data});
end

function drnext(src,event,data)
global dri ringOK
cltype=get(src,'SelectionType');
if strcmpi(cltype,'Normal')
    ringOK(dri)=1;
elseif strcmpi(cltype,'Alt')
    
end
dri=dri+1;
if dri>length(ringOK)
    clf
    title(['Done! ',num2str(sum(ringOK)),' particles']);
else
    imagesc(squeeze(data(dri,:,:)));
    title([num2str(dri),'/',num2str(length(ringOK))]);
end
end
