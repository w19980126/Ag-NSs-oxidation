%% ����ԭʼͼƬ����
path='F:\work\SPR-DF\Ag-FeCl3\20230730-ZKLM-Ũ��-30mW\A9-50uM-100fps-30mW';
[ fileList ] = dir(fullfile(path,'*.tiff'));

ind= 3700:4500;
data=zeros([size(imread(fullfile(path,fileList(1).name))),length(ind)]);

for ii = 1:length(ind)
    data(:,:,ii)=imread((fullfile(path,fileList(ind(ii)).name)));
end
showSlide(data)

%% ����ѡ��
dataM = squeeze(mean(data,3));
dataS = squeeze(std(data,0,3));
figure
ax(1)=subplot(221);
imagesc(dataM);
ax(2)=subplot(222);
imagesc(dataS);
ax(3)=subplot(223);
imagesc(dataM.*dataS);
linkaxes(ax)
%% ��һ����������ͼ����Ϊģ��
cen=[323,332];
r=6;
mask=dataM(cen(1)-r:cen(1)+r,cen(2)-r:cen(2)+r);
% mask = (E_amp/P).^2;
figure;imagesc(mask);

%% ����ͼ��ֱ���
reS=3;
% mask(5:7,5:7)=-100;
% dataS2 = imresize(dataS,reS);
dataS2 = imresize(dataM,reS);
mask2 = imresize(mask,reS);
figure
imagesc(mask2);

%% �г�Ǳ�ں��ʵĿ���
dataConv=conv2(dataS2,mask2,'same');
pk=fastPeakFind(dataConv/max(dataConv(:))*65535,0.035*8*65535,[],r*reS+1);
pk=reshape(pk,2,[])';
figure
imagesc(dataS2); 
hold on
plot(pk(:,1),pk(:,2),'r+')
hold off

%%
% dataS = imresize(double(imread(fullfile(path,fileList(ind(22)).name))),1);
dataS = dataS2;
while 1         % ��ͨ�˲�������Ƶ����
    prompt = {'���������ֱ�������أ�:'};
    dlgtitle = 'Input';
    definput = {'5'};
    answer = inputdlg(prompt,dlgtitle,[1,35],definput);
    b = bpass(dataS,1,str2double(answer{1}));
    figure;
    subplot(121);imagesc(dataS);axis off;axis equal;title('ԭͼ')
    subplot(122);imagesc(b);axis off;axis equal;title('�˲�')

    answer = input('�Ƿ����⣺Y/N \n','s');
    if strcmp(answer,'Y')
        break;
    end
end

while 1         % ������λ�����ؼ�
    prompt = {'��ֵ','����'};
    dlgtitle = 'Input';
    definput = {'300','25'};
    answer = inputdlg(prompt,dlgtitle,[1,35],definput);
    pk = pkfnd(b,str2double(answer{1}),str2double(answer{2}));
    figure;
    imagesc(b);axis off;axis equal;hold on;
    scatter(pk(:,1),pk(:,2),[],"red",'LineWidth',1.5)
    answer = input('�Ƿ����⣺Y/N \n','s');
    if strcmp(answer,'Y')
        break;
    end
end

while 1         % ������λ�������ؼ�
    prompt = {'��Ϸ�Χ��pixels in diameter)'};
    dlgtitle = 'Input';
    definput = {'7'};
    answer = inputdlg(prompt,dlgtitle,[1,35],definput);
    cnt = cntrd(b,pk,str2double(answer{1}));        % ���Ķ�λ�㷨��cnt = centroid
    figure;imagesc(dataS);colormap('parula');hold on;scatter(cnt(:,1),cnt(:,2),[],"red",'LineWidth',1.5)
    text(pk(:,1)+10,pk(:,2)+10,string(1:size(pk,1)),'Color','r');         % Ϊÿ����������ǩ�Ա�ɾ��

    answer = input('�Ƿ����⣺Y/N \n','s');
    if strcmp(answer,'Y')
        break;
    end
end
    
%% �����˹���ɸ�飬���ȷ��ѡ���Ҽ���ѡ��ÿ���
dt=zeros([size(pk,1),size(mask2)]);
for ii=1:size(pk,1)
    dt(ii,:,:)=dataS2(pk(ii,2)-r*reS-1:pk(ii,2)+r*reS+1,pk(ii,1)-r*reS-1:pk(ii,1)+r*reS+1);
end
selectOKp(dt)
global ringOK
%% ���ɷֱ����������ÿ��������ͼ��
pkround=round(pk/reS);
for ii=1:size(pkround,1)
    dt=data(pkround(ii,2)-r:pkround(ii,2)+r,pkround(ii,1)-r:pkround(ii,1)+r,:);
    if ringOK(ii)==1
        dtL{ii}=zeros([size(imresize(squeeze(dt(:,:,1)),reS)),size(dt,3)]);
        for j=1:size(dt,1)
            dtL{ii}(:,:,j)=imresize(squeeze(dt(:,:,j)),reS);
        end
    end
end
%% �˹���3���㣬����һ��Ȧ����Ϊ����ǿ�ȷֲ��Ļ�
figure
for ii=1:length(dtL)
    if ~isempty(dtL{ii})
%         [ c(i,:),r(i)] = ringMaker(squeeze(mean(dtL{i})));%�þ�ֵ
        [ c(ii,:),r(ii)] = ringMaker(squeeze(dtL{ii}(:,:,1)));%�õ�һ��
        pause(1)
    end
end
%% test
deg=0:360;
U = triu(ones(33));

[ ct,rt] = ringMaker(U);
rx=ct(1)+rt*cosd(deg);
ry=ct(2)+rt*sind(deg); 
vt(:,1)=interp2(U,rx,ry);
vt(:,2)=interp2(U,ry,rx);
plot(vt)
%% ����ÿ����������ǿ�ȷֲ��仯
ii=1
val=zeros(length(dtL),length(deg),size(dtL{ii},1));
val2=zeros(length(dtL),length(deg),size(dtL{ii},1));
deg=0:360;
for ii=1:length(dtL)
    if ~isempty(dtL{ii})
        rx=c(ii,1)+r(ii)*cosd(deg);
        ry=c(ii,2)+r(ii)*sind(deg); 
        v=zeros(length(deg),size(dtL{ii},3));
        for j=1:size(dtL{ii},1)
            temp=squeeze(dtL{ii}(j,:,:));
            v(:,j)=interp2(temp,rx,ry);
            v2(:,j)=normalize(v(:,j),'range');
        end
        val(ii,:,:)=v;
        val2(ii,:,:)=v2;
    end
end
%% show
for ii=1:length(dtL)
    if ~isempty(dtL{ii})
        subplot(221)
        imagesc(squeeze(val(ii,:,:)));
        subplot(222)
        imagesc(squeeze(val2(ii,:,:)));
        subplot(223)
        rx=c(ii,1)+r(ii)*cosd(deg);
        ry=c(ii,2)+r(ii)*sind(deg);
        imagesc(squeeze(mean(dtL{ii})));
        hold on ;  
        plot(rx,ry,'r');hold off;
        title('Average');
        subplot(224)
        imagesc(squeeze(dtL{ii}(1,:,:)));
        hold on ;  
        plot(rx,ry,'r');hold off;
        title('First');
        pause
    end
end