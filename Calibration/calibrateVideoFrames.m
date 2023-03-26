function calibrateVideoFrames(data_path)

movie_meta_data = readmatrix(data_path + "movie_metadata.csv");
gyro_data = readmatrix(data_path + "gyro_accel.csv");
frame_ts_data = readmatrix(data_path + "frame_timestamps.txt");

v = VideoReader(data_path + "movie.mp4");
frames = zeros(v.Height,v.Width,3,frame_num,"uint8");
%%
tic
for i = 1:v.NumFrames
    frames(:,:,:,i) = readFrame(v);
end
clear("frame","i","j")
toc
%%
% addpath(getenv('USERPROFILE')+"\OneDrive - Texas A&M University\Project\OIS\Calibration")
board_size = [9,11];
cx = v.Width/2;
cy = v.Height/2;
fs = movie_meta_data(1,:);
fx = fs(2);
fy = fs(3);
image_points = zeros((board_size(1)-1)*(board_size(2)-1),2,4,frame_num);
params = cell(frame_num,1);
errors = cell(frame_num,1);
tic
parfor i = 1:v.NumFrames
    
    k_init = [fx,0,cx;0,fy,cy;0,0,1];
    try
        [params{i},image_points(:,:,:,i),errors{i}]=detectMultiCheckerboard(frames(:,:,:,i),board_size,k_init);
    catch ME
        fprintf("i = %d\n",i);
        fprintf(ME.message + "\n");
    end
end
toc
clear fs fx fy cx cy
save(data_path + "matlab calibration.mat","params","image_points","errors",'-mat');
%%
rep_lim = 0.9;
times = [];
cxs = [];
cys = [];
fxs = [];
fys = [];
cxes = [];
cyes = [];
fxes = [];
fyes = [];
for i = 1:v.NumFrames
    if(~isempty(params{i}) && params{i}.MeanReprojectionError < rep_lim)
        K = params{i}.Intrinsics.K;
        fxs = [fxs, K(1,1)]; % x and y in matlab is oppsite from opencv
        fys = [fys, K(2,2)];
        cxs = [cxs, K(1,3)];
        cys = [cys, K(2,3)];
        fxes = [fxes, errors{i}.IntrinsicsErrors.FocalLengthError(1)]; % x and y in matlab is oppsite from opencv
        fyes = [fyes, errors{i}.IntrinsicsErrors.FocalLengthError(2)];
        cxes = [cxes, errors{i}.IntrinsicsErrors.PrincipalPointError(1)];
        cyes = [cyes, errors{i}.IntrinsicsErrors.PrincipalPointError(2)];
        times = [times, frame_ts_data(i,1)];
    end
end
%% 
% Plot all gyro_accl data

f = figure();
subplot(3,1,1)
plot(gyro_data(:,1)-gyro_data(1,1),gyro_data(:,5))
ylabel("a_x")
subplot(3,1,2)
plot(gyro_data(:,1)-gyro_data(1,1),gyro_data(:,6))
ylabel("a_y")
subplot(3,1,3)
plot(gyro_data(:,1)-gyro_data(1,1),gyro_data(:,7))
ylabel("a_z")
xlabel("time (ns)")
exportgraphics(f, data_path+"accl.png")
%%
f = figure();
subplot(3,1,1)
plot(gyro_data(:,1)-gyro_data(1,1),gyro_data(:,2))
ylabel("\omega_x")
subplot(3,1,2)
plot(gyro_data(:,1)-gyro_data(1,1),gyro_data(:,3))
ylabel("\omega_y")
subplot(3,1,3)
plot(gyro_data(:,1)-gyro_data(1,1),gyro_data(:,4))
ylabel("\omega_z")
xlabel("time (ns)")
exportgraphics(f, data_path+"omega.png")
%% 
% Plot all K data

f = figure();
subplot(2,1,1)
ebar = zeros(length(times),2,2);
ebar(:,:,1) = [fxes;fxes]';
ebar(:,:,2) = [fyes;fyes]';
% [l,p]=boundedline(times-times(1), fxs, fxes, '-r', times-times(1), fys, fyes, '--b');
% outlinebounds(l,p);
boundedline(times-times(1),[fxs;fys],ebar, 'alpha');
xlabel("time (ns)")
ylabel("focus (px)")
legend("f_x","f_y")


subplot(2,1,2)
ebar = zeros(length(times),2,2);
ebar(:,:,1) = [cxes;cxes]';
ebar(:,:,2) = [cyes;cyes]';

boundedline(times-times(1),[cxs-mean(cxs);cys-mean(cys)],ebar);

xlabel("time (ns)")
ylabel("camera center (px)")
legend("c_x","c_y",'location','southeast')
exportgraphics(f, data_path+"K.png")


end