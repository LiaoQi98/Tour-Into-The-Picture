% build the mask
function a=get_mask(a,p0,p1)

a(p0(1),p0(2))=1;
a(p1(1),p1(2))=1;
dis=p1-p0;
gap=((-1).^double(dis<0));
absdis=abs(dis);
more=max(absdis);
less=min(absdis);

if absdis(1)>=absdis(2)
    dir1=[gap(1),0];
    dir2=[0,gap(2)];
else
    dir2=[gap(1),0];
    dir1=[0,gap(2)];
end

lmp=less/more;
i=0;j=0;
while i<more
    p0=p0+dir1;
    a(p0(1),p0(2))=1;
    i=i+1;
 if i<more
        p1=p1-dir1;
        a(p1(1),p1(2))=1;
        i=i+1;
    end
 if j/i<lmp
        if j<less
            p0=p0+dir2;
            a(p0(1),p0(2))=1;
            j=j+1;
        end
        if j<less
           p1=p1-dir2;
            a(p1(1),p1(2))=1;
            j=j+1;
        end
    end
end

end