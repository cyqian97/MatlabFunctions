[filepath,name,ext]=fileparts(mfilename('fullpath'));
addpath(filepath)
addpath(fullfile(filepath,"Calibration"))
addpath(fullfile(filepath,"boundedline-pkg","boundedline"))
addpath(fullfile(filepath,"boundedline-pkg","catuneven"))
addpath(fullfile(filepath,"boundedline-pkg","Inpaint_nans"))
addpath(fullfile(filepath,"boundedline-pkg","singlepatch"))
