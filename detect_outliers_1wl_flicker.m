clc;clear all;close all force;


crop_perc = 0.1;
thresholdFactor = 0.005;
medfilt_size = 71;
sparsity = 3;
remove_max_perc = 0.2;


tmp_save_folder = 'C:\Data\Vicar\tmp_sada03\Sada03_outliers';
mkdir(tmp_save_folder)

filenames = subdir('C:\Data\Vicar\tmp_sada03/*_registered.avi');
filenames = {filenames(:).name};

% has_not_660_ = cellfun(@(x) contains(x,'_660_')==0, filenames, UniformOutput=true) ;
% filenames = filenames(has_not_660_);


% rng(42)
% perm = randperm(length(filenames));
for k = 1:length(filenames)
    
%     filename = filenames(perm(k)).name;
    filename = filenames{k};

    disp([num2str(k) ' / ' num2str(length(filenames))])
    disp(filename)
    
    
    vidObj = VideoReader(filename);
    
    video_num_frames = vidObj.NumFrames;
    
    video_data = zeros(vidObj.Height,vidObj.Width,video_num_frames, 'uint8');
    
    frame_ind = 0;
    while hasFrame(vidObj)
        frame_ind = frame_ind + 1;
        frame = readFrame(vidObj);
        video_data(:,:,frame_ind) = frame(:,:,1);
    end



    shape = size(video_data);
    shape_reduce = round(2 * crop_perc * shape);
    shape_reduce = shape_reduce - mod(shape_reduce,2);
    shape_small = shape - shape_reduce;
    W_small = hamming(shape_small(1))*hamming(shape_small(2))';
    W = padarray(W_small,[shape_reduce(1)/2 shape_reduce(2)/2],'both');




    med3_filt =  medfilt3_time_sparse(video_data,medfilt_size,sparsity);
    data_min_med = single(video_data) - single(med3_filt);
    
    med3_filt = [];
    W3 = repmat(single(W),[1,1,size(video_data,3)]);
    rmse_from_med  =  squeeze(sqrt(sum( W3 .* single(data_min_med.^2),[1,2])))';
%     rmse_from_med  =  squeeze(sum( single(W3) .* (abs(data_min_med)),[1,2]))';
    W3 = [];

    remove_max = round(size(video_data,3)*remove_max_perc);
    [B,outliers_binar] = rmoutliers(rmse_from_med,'gesd','ThresholdFactor',thresholdFactor,'MaxNumOutliers',remove_max);



    rmse_from_med_for_plot = rmse_from_med;
    q3 = quantile(rmse_from_med_for_plot,0.75);
    t = (5 * q3);
    rmse_from_med_for_plot(rmse_from_med_for_plot > t) = t;



    app = outliers_analysis(video_data,rmse_from_med_for_plot,outliers_binar,'mse_from_mean');
    while app.done == 0
        pause(0.1);
    end
    outliers_binar_manual = app.bin_outliers;
    app.closeApp();


        
    [~,tmp_save_filename,~] =  fileparts(filename);
    tmp_save_filename = [tmp_save_folder '/' tmp_save_filename  '.mat'];
    
    
    save(tmp_save_filename,'outliers_binar','outliers_binar_manual')

end







