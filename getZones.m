function zoneVector=getZones(img,nH_part,nV_part)
% skeletonize the image and compute densities going from (1,1),(2,1)...(nV_part,nH_part)
BW=~img;
BW_morph = bwmorph(BW,'skel',Inf);

[r,c]=size(BW_morph);
x_fact=1/nV_part;
y_fact=1/nH_part;
zoneDensity=zeros(nH_part,nV_part);
for i=1:nV_part
    col_start=1+floor((i-1)*x_fact*c);
    col_end=floor(i*x_fact*c);
   
    if col_end>c
        col_end=c;
    end
    for j=1:nH_part
        row_start=1+floor((j-1)*y_fact*r);
        row_end=floor(j*y_fact*r);

        if row_end>r
        row_end=r;
        end
        temp=BW_morph(row_start:row_end,col_start:col_end);
        
        zoneDensity(i,j)=sum(temp(:))/(size(temp,1)*size(temp,2));
    end
end

zoneVector=(zoneDensity(:))';

end