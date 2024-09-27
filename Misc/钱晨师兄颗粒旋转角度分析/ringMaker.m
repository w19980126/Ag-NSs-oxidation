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
TR = triangulation([1,2,3],x,y); %��ʾ����������
[cc,r] = circumcenter(TR); 
deg=0:360;           %���ǽǶȵ�ȡֵ��0~360���ԽСԲԽƽ��
rx=cc(1)+r*cosd(deg);
ry=cc(2)+r*sind(deg); %���������Բ�ĺͰ뾶����Բ������
hold on ;  
plot(x,y,'ko'); %��������λ��
plot(rx,ry,'r');hold off;
end

