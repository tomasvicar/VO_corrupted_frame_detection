clc;clear all;close all force;



filenames = subdir('D:/data_vo_registered/*.avi');

rng(42)
perm = randperm(length(filenames));
for k = 9:length(filenames)
    
    filename = filenames(perm(k)).name;
    
    
    vidObj = VideoReader(filename);
    
    video_num_frames = vidObj.NumFrames;
    
    video_data = zeros(vidObj.Height,vidObj.Width,video_num_frames, 'uint8');
    
    frame_ind = 0;
    while hasFrame(vidObj)
        frame_ind = frame_ind + 1;
        frame = readFrame(vidObj);
        video_data(:,:,frame_ind) = frame(:,:,1);
    end




    remove_max = round(size(video_data,3)*0.2);
    
    crop_perc = 0.1;



    shape = size(video_data);
    shape_reduce = round(2 * crop_perc * shape);
    shape_reduce = shape_reduce - mod(shape_reduce,2);
    shape_small = shape - shape_reduce;
    W_small = hamming(shape_small(1))*hamming(shape_small(2))';
    W = padarray(W_small,[shape_reduce(1)/2 shape_reduce(2)/2],'both');


    
    
%     thresholdFactor = 0.03;
%     medfilt_size = 71;
%     median_image =  single(median(video_data,3));
%     data_min_med = single(video_data) - repmat(median_image,[1,1,size(video_data,3)]);
%     W3 = repmat(single(W),[1,1,size(video_data,3)]);
% %     rmse_from_med =  squeeze(sqrt(sum( W3 .* (data_min_med.^2),[1,2])));
% %     rmse_from_med =  squeeze(sqrt(sum( W3 .* abs(data_min_med),[1,2])));
% 
%     rmse_from_med = rmse_from_med - my_medfilt1(rmse_from_med,medfilt_size);



    thresholdFactor = 0.01;
    medfilt_size = 61;
    sparsity = 3;

    med3_filt =  medfilt3_time_sparse(video_data,medfilt_size,sparsity);
    data_min_med = single(video_data) - single(med3_filt);
    W3 = repmat(W,[1,1,size(video_data,3)]);
    rmse_from_med  =  squeeze(sqrt(sum( single(W3) .* (data_min_med.^2),[1,2])))';
%     rmse_from_med  =  squeeze(sum( single(W3) .* (abs(data_min_med)),[1,2]))';



    [B,TF] = rmoutliers(rmse_from_med,'gesd','ThresholdFactor',thresholdFactor,'MaxNumOutliers',remove_max);

    rmse_from_med_for_plot = rmse_from_med;
    q3 = quantile(rmse_from_med_for_plot,0.75);
    t = (5 * q3);
    rmse_from_med_for_plot(rmse_from_med_for_plot > t) = t;
    app = outliers_analysis(video_data,rmse_from_med_for_plot,TF,'mse_from_mean');

%     filaname_save = filename;
%     filaname_save = [replace(filaname_save,'.avi','') 'tmp.mat'];

%     save(filaname_save,'video_data','mse_from_mean')
%     load(filaname_save)


  
    


    

    while isvalid(app)
        pause(0.1);
    end

end







