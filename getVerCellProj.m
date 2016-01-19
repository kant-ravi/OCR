function projVector=getVerCellProj(img,nCells)

% takes an image I partitions it in "parition" number of evenly spread parts
% and returns the projections along these vertical partitions

img=~img;
[r,c]=size(img);
factor=1/nCells;
projVector=zeros(1,nCells);
for i=1:nCells
    start_col=1+floor((i-1)*factor*c);
    
    end_col=floor(i*factor*c);
    if end_col>c
        end_col=c;
    end
    
    temp=img(:,start_col:end_col);
    vertProj=sum(temp,2);
    vertProj=vertProj./vertProj;
    length=sum(vertProj==1);
    projVector(1,i)=length/r;
    
end
end
