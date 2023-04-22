function calibrateVideoFrames(data_path,batch_size)

movie_meta_data = readmatrix(data_path + "movie_metadata.csv");
gyro_data = readmatrix(data_path + "gyro_accel.csv");
frame_ts_data = readmatrix(data_path + "frame_timestamps.txt");

v = VideoReader(data_path + "movie.mp4");

batch_num = ceil(v.NumFrames/batch_size);
frames = zeros(v.Height,v.Width,3,batch_size,"uint8");

board_size = [9,11];
cx = v.Width/2;
cy = v.Height/2;
fs = movie_meta_data(1,:);
fx = fs(2);
fy = fs(3);
image_points = zeros((board_size(1)-1)*(board_size(2)-1),2,4,v.NumFrames);
params = cell(v.NumFrames,1);
errors = cell(v.NumFrames,1);
%%
tic
for i = 1:batch_num
    batch_length = min(batch_size,v.NumFrames-(i-1)*batch_size);
    for j=1:batch_length
        frames(:,:,:,j) = readFrame(v);
    end
    tic
    image_points_ = zeros((board_size(1)-1)*(board_size(2)-1),2,4,batch_length);
    params_ = cell(batch_length,1);
    errors_ = cell(batch_length,1);

    parfor j=1:batch_length
        k_init = [fx,0,cx;0,fy,cy;0,0,1];
        try
            [params_{j},image_points_(:,:,:,j),errors_{j}]=calibMultiCheckerboard(frames(:,:,:,j),board_size,init_K = k_init');
        catch ME
            fprintf("i = %d, j = %d\n",i,j);
            fprintf(ME.message + "\n");
        end
    end
    image_points(:,:,:,(i-1)*batch_size+(1:batch_length)) = image_points_;
    params((i-1)*batch_size+(1:batch_length)) = params_;
    errors((i-1)*batch_size+(1:batch_length)) = errors_;
    toc
end
clear("frame","i","j")
toc
%%
% addpath(getenv('USERPROFILE')+"\OneDrive - Texas A&M University\Project\OIS\Calibration")


clear fs fx fy cx cy
save(data_path + "matlab calibration.mat","params","image_points","errors",'-mat');

end