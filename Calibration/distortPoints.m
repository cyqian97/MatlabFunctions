function im_pts_d = distortPoints(x,y,intrinsics)
%distortPoints distort the image using the radial distortion coefficients

[theta,rho] = cart2pol( ...
    (x-intrinsics.PrincipalPoint(1))/intrinsics.FocalLength(1), ...
    (y-intrinsics.PrincipalPoint(2))/intrinsics.FocalLength(2));
if length(intrinsics.RadialDistortion) == 2
    rho = rho.*(1+intrinsics.RadialDistortion(1)*rho.^2+intrinsics.RadialDistortion(2)*rho.^4);
elseif length(intrinsics.RadialDistortion) == 3
    rho = rho.*(1+intrinsics.RadialDistortion(1)*rho.^2+intrinsics.RadialDistortion(2)*rho.^4+intrinsics.RadialDistortion(3)*rho.^6);
end
[xx,yy] = pol2cart(theta,rho);
im_pts_d = [xx(:)*intrinsics.FocalLength(1)+intrinsics.PrincipalPoint(1), ...
            yy(:)*intrinsics.FocalLength(2)+intrinsics.PrincipalPoint(2)];

end
