function is_in = is_Point_in_Triangle(p1,p2,p3,ps)
% ps should contain points on the plane defined by p1,p2 and p3.

if (isvector(p1) && isvector(p2) && isvector(p3) && ...
        isequal(length(p1),length(p2),length(p3)) && ...
        size(ps,1)==length(p1))
    A = [p2(:)-p1(:),p3(:)-p1(:)];
    coef = A\ps;
    is_in = coef(1,:)>=0 & coef(2,:)>=0 & sum(coef)<=1;
else
    error('is_Point_in_Triangle: InputInvalid');
end

end