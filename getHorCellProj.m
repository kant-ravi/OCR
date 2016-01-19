function projVector=getHorCellProj(img,nCells)

img=~img;
[r,c]=size(img);
factor=1/nCells;
projVector=zeros(1,nCells);
for i=1:nCells
    start_row=1+floor((i-1)*factor*r);
  
    end_row=floor(i*factor*r);
    if end_row>r
        end_row=r;
    end
    temp=img(start_row:end_row,:);
    horzProj=sum(temp,1);
    horzProj=horzProj./horzProj;
    length=sum(horzProj==1);
    projVector(1,i)=length/c;
end
end

