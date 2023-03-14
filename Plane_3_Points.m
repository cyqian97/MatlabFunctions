function plane = Plane_3_Points(p1,p2,p3)
% https://keisan.casio.com/exec/system/1223596129

if isvector(p1) && isvector(p2) && isvector(p3)
    if (length(p1) ~= 3 || length(p2) ~= 3 || length(p3) ~= 3)
        error(message('MINE:Plane_3_Points:InputInvalid'));
    end
    
    plane = cross(p2-p1,p3-p1);
    plane = plane(:);
    plane(4) = -p1(:)'*plane;
else
    error('Plane_3_Points: InputInvalid');
end


end