function [params,imagePoints,estimationErrors] = calibMultiCheckerboard(im,boardSize,options)
% calibMultiCheckerboard detects Multiple Checkerboards in One Image
% boardSize: (h,w). The size of the checkerboard, equals to the point array
% size + (1,1).

arguments
    im {mustBeNumeric}
    boardSize (1,2) double {mustBeInteger, mustBePositive}
    options.init_K (3,3) {mustBeNumeric}
    options.EstimateSkew (1,1) logical = false
    options.NumRadialDistortionCoefficients (1,1) {mustBeInteger, mustBePositive} =  2
    options.EstimateTangentialDistortion (1,1) = false

end



imagePoints = detectMultiCheckerboard(im,boardSize);

%% Calibrate camera

squareSizeInMM = 22;
worldPoints = generateCheckerboardPoints(boardSize,squareSizeInMM);
imageSize = [size(im, 1),size(im, 2)];
if isfield(options,"init_K")
    [params, ~, estimationErrors] = estimateCameraParameters(imagePoints,worldPoints, ...
        'ImageSize',imageSize,'WorldUnits','mm','InitialIntrinsicMatrix',options.init_K, ...
        "EstimateSkew",options.EstimateSkew, ...
        "NumRadialDistortionCoefficients",options.NumRadialDistortionCoefficients, ...
        "EstimateTangentialDistortion",options.EstimateTangentialDistortion);
else
    [params, ~, estimationErrors] = estimateCameraParameters(imagePoints,worldPoints, ...
        'ImageSize',imageSize,'WorldUnits','mm', ...
        "EstimateSkew",options.EstimateSkew, ...
        "NumRadialDistortionCoefficients",options.NumRadialDistortionCoefficients, ...
        "EstimateTangentialDistortion",options.EstimateTangentialDistortion);
end

end
