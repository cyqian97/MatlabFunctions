function imagePoints = detectMultiCheckerboard(im,boardSize)
% detectMultiCheckerboard detects Multiple Checkerboards in One Image
% boardSize: (h,w). The size of the checkerboard, equals to the point array
% size + (1,1).

if (ischar(im) || isstring(im))
    im = imread(im);
else
    validateattributes(im,{'numeric'},{'3d'},'detectMultiCheckerboard','im');
end
imagePoints = zeros((boardSize(1)-1)*(boardSize(2)-1),2,4);

for i=1:4
    [imagePoints_,boardSize_] = detectCheckerboardPoints(im);
    if(~all(boardSize_ == boardSize))
        error("boardSize detected is different from the input in pattern %d! input: (%d,%d), detected: (%d,%d)",i,boardSize(1),boardSize(2),boardSize_(1),boardSize_(2));
    end
    imagePoints(:,:,i)=imagePoints_;

    % Color all points on the current check board black
    [xq,yq]=meshgrid(1:size(im,2),1:size(im,1));
    xv = imagePoints_([1,boardSize(1)-1,end,end-boardSize(1)+2],1) ...
        +[imagePoints_(1,1)-imagePoints_(boardSize(1),1),imagePoints_(boardSize(1)-1,1)-imagePoints_(2*(boardSize(1)-1),1), ...
        imagePoints_(end,1)-imagePoints_(end-boardSize(1)+1,1), imagePoints_(end-boardSize(1)+2,1)-imagePoints_(end-2* boardSize(1)+3,1)]';
    yv = imagePoints_([1,boardSize(1)-1,end,end-boardSize(1)+2],2) ...
        +[imagePoints_(1,2)-imagePoints_(2,2),imagePoints_(boardSize(1)-1,2)-imagePoints_(boardSize(1)-2,2), ...
        imagePoints_(end,2)-imagePoints_(end-1,2), imagePoints_(end-boardSize(1)+2,2)-imagePoints_(end-boardSize(1)+3,2)]';
    in = inpolygon(xq,yq,xv,yv);
    for j=1:3
        temp = im(:,:,j);
        temp(in) = 0;
        im(:,:,j) = temp;
    end
end

end