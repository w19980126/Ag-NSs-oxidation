function [ c,r] = ringMaker( im )
%RESTIMATE Summary of this function goes here
%   Detailed explanation goes here
figure
imagesc(im);
title('Click 3 points on one circle');
[x,y]=ginput(3); 
[ c,r] = calc( x,y );
end

function [ cc,r] = calc( x,y )
TR = triangulation([1,2,3],x,y); %表示成三角网格
[cc,r] = circumcenter(TR); 
deg=0:360;           %这是角度的取值，0~360间隔越小圆越平滑
rx=cc(1)+r*cosd(deg);
ry=cc(2)+r*sind(deg); %这三句根据圆心和半径生成圆的数据
hold on ;  
plot(x,y,'ko'); %画出三点位置
plot(rx,ry,'r');hold off;
end

