clc
clear
for i=1:9
number=i;
loc='D:\USC\Sem 2\Pattern Recoginition\Project\Test Data Images\TEST_DATA';
loc=strcat(loc,'\',num2str(number));
fileList=dir(loc);
nCells=4;   % change this to change number of cell projections
H_part=4;   % change this to change num of horizontal partions for zoning operation
V_part=4;   % change this to change num of vertical partions for zoning operation
nMoments=15;    %Do not change with out changing function getMoments()
numImages=sum([fileList.isdir]==0);
feature=zeros(numImages,2*nCells+H_part*V_part+nMoments);
labels=zeros(numImages,1);
k=1;
for i =1:size(fileList,1);
    if fileList(i).isdir==0
        
        loc=strcat(loc,'\',fileList(i).name);
        I=imread(loc);
        G=rgb2gray(I);
        BW=im2bw(G,graythresh(G));
        s=regionprops(~BW,'BoundingBox','Area');
      %  figure;
       % imshow(BW);
        areaList=zeros(1,size(s,1));
        for j=1:size(s,1) 
            areaList(1,j)=s(j).Area;
           % rectangle('Position',s(j).BoundingBox,'EdgeColor',[1 0 0],'LineWidth',2);
        end
        [maxArea,ind]=max(areaList);
      %  rectangle('Position',s(ind).BoundingBox,'EdgeColor',[1 0 0],'LineWidth',2);
        cropImg=imcrop(BW,s(ind).BoundingBox);
        
        feature_verCellProj=getVerCellProj(cropImg,nCells); %number of vert partions
        feature_horCellProj=getHorCellProj(cropImg,nCells);
        feature_zones=getZones(cropImg,H_part,V_part);    %number or hor,vertical partitions
        feature_moments=getMoments(cropImg);
        
        feature(k,:)=[feature_verCellProj,feature_horCellProj,feature_zones,feature_moments];
      
       % feature(k,:)
        labels(k,1)=number; 
        k
        k=k+1;
       
        loc=loc(1:size(loc,2)-size(fileList(i).name,2)-1);
        
    end
    
end
%input 'save?'
feature_train=feature;
size(feature_train)
label_train=labels;
save(strcat('D:\USC\Sem 2\Pattern Recoginition\Project\Test Data Images\TEST_DATA\',num2str(number),'.mat'),'feature_train','label_train') ;   
end   