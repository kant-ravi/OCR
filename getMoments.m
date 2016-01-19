function momentVector=getMoments(img)

    function moment=computeMoment(I,p,q)

        [r,c]=size(I);
        sum=0;
        for x=1:c
            for y=1:r
                sum=sum+(x^p)*(y^q)*I(y,x);
            end
        end
        moment=sum;
    end

    function centralMoment=computeCentralMoment(I,p,q,xbar,ybar)
        
        [r,c]=size(I);
        sum=0;
        for x=1:c
            for y=1:r
                sum=sum+((x-xbar)^p)*((y-ybar)^q)*I(y,x);
            end
        end
        centralMoment=sum;
    end

img=~img;

m10=computeMoment(img,1,0);
m01=computeMoment(img,0,1);
m00=computeMoment(img,0,0);
xbar=m10/m00;
ybar=m01/m00;

u00=computeCentralMoment(img,0,0,xbar,ybar);
u10=computeCentralMoment(img,1,0,xbar,ybar);
u01=computeCentralMoment(img,0,1,xbar,ybar);
u11=computeCentralMoment(img,1,1,xbar,ybar);
u20=computeCentralMoment(img,2,0,xbar,ybar);
u02=computeCentralMoment(img,0,2,xbar,ybar);
u22=computeCentralMoment(img,2,2,xbar,ybar);
u30=computeCentralMoment(img,3,0,xbar,ybar);
u03=computeCentralMoment(img,0,3,xbar,ybar);
u21=computeCentralMoment(img,2,1,xbar,ybar);
u12=computeCentralMoment(img,1,2,xbar,ybar);
u31=computeCentralMoment(img,3,1,xbar,ybar);
u13=computeCentralMoment(img,1,3,xbar,ybar);
u40=computeCentralMoment(img,4,0,xbar,ybar);
u04=computeCentralMoment(img,0,4,xbar,ybar);

momentVector=[u00 u10 u01 u11 u20 u02 u22 u30 u03 u21 u12 u31 u13 u40 u04];
end