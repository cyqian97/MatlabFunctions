function [params,imagePoints,estimationErrors] = calibMultiCheckerboard(im,boardSize,varargin)
% detectMultiCheckerboard detects Multiple Checkerboards in One Image
% boardSize: (h,w). The size of the checkerboard, equals to the point array
% size + (1,1).
if ~isempty(varargin)
    init_K = varargin{1};
    validateattributes(init_K,'numeric',{'size',[3,3]})
end

imagePoints = detectMultiCheckerboard(im,boardSize);

%% Calibrate camera

squareSizeInMM = 22;
worldPoints = generateCheckerboardPoints(boardSize,squareSizeInMM);
imageSize = [size(im, 1),size(im, 2)];
if ~isempty(varargin)
    [params, ~, estimationErrors] = estimateCameraParameters(imagePoints,worldPoints, ...
        'ImageSize',imageSize,'WorldUnits','mm','InitialIntrinsicMatrix',init_K');
else
    [params, ~, estimationErrors] = estimateCameraParameters(imagePoints,worldPoints, ...
        'ImageSize',imageSize,'WorldUnits','mm');
end

end