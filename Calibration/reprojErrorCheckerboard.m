function [error_mean,pose,reproj_points] = reprojErrorCheckerboard(image_points,board_size,square_size,intrinsics)
%reprojErrorCheckerboard Calculate the reprojection error of a checkerboard
%pattern using known camera intrinsics. It uses pnp to solve the pose of
%the checkerboard.


worldPoints = generateCheckerboardPoints(board_size,square_size);
worldPoints3D = [worldPoints, zeros(size(worldPoints,1),1)];
worldPoints4D = [worldPoints3D,ones(size(worldPoints,1),1)];

im_pts_ud = undistortPoints(image_points,intrinsics);
pose = estpose(im_pts_ud,worldPoints3D,intrinsics,Confidence=99,MaxNumTrials=2000,MaxReprojectionError = 1);
im_pts_hm = [K_n, [0;0;0]] * invert(pose).A * worldPoints4D';
im_pts_proj = im_pts_hm(1:2,:)./im_pts_hm(3,:);
reproj_points = distortPoints(im_pts_proj(1,:),im_pts_proj(2,:),intrinsics);
error_mean = mean(vecnorm(image_points'-reproj_points'));


end