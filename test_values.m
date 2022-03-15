clc;clear all;close all force;



% wavelength = 470;
% wavelength = 525;
% wavelength = 580;
% wavelength = 595;
% wavelength = 660;

% filename = "D:\data_vo_rate\Sada_01_001\Sada_01_001_wavelength\Gacr_01_001_01_wavelength_m.avi";
% filename = replace(filename,'wavelength',num2str(wavelength));

filenames = subdir('D:/data_vo_registered/*.avi');

rng(42)
perm = randperm(length(filenames));
for k = 4:length(filenames)
    
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
    thresholdFactor = 0.5;
    medfilt_size = 71;
    crop_perc = 0.1;



    shape = size(video_data);
    shape_reduce = round(2 * crop_perc * shape);
    shape_reduce = shape_reduce - mod(shape_reduce,2);
    shape_small = shape - shape_reduce;
    W_small = hamming(shape_small(1))*hamming(shape_small(2))';
    W = padarray(W_small,[shape_reduce(1)/2 shape_reduce(2)/2],'both');
    W = uint8(W*255);

    
    median_image =  median(video_data,3);
    data_min_med = video_data - repmat(median_image,[1,1,size(video_data,3)]);
    W3 = repmat(W,[1,1,size(video_data,3)]);
    rmse_from_med =  squeeze(sqrt(sum( W3 .* (data_min_med.^2),[1,2])));
%     rmse_from_med =  squeeze(sqrt(sum( W3 .* abs(data_min_med),[1,2])));



    rmse_from_med = rmse_from_med - my_medfilt1(rmse_from_med,medfilt_size);





%     med3_filt =  medfilt3(video_data,[1,1,medfilt_size]);
%     data_min_med = video_data - med3_filt;
%     W3 = repmat(W,[1,1,size(video_data,3)]);
%     rmse_from_movmed  =  squeeze(sqrt(sum( W3 .* (data_min_med.^2),[1,2])))';
%     rmse_from_movmed  =  squeeze(sum( W3 .* (abs(data_min_med)),[1,2]))';



    [B,TF] = rmoutliers(rmse_from_med,'gesd','ThresholdFactor',thresholdFactor,'MaxNumOutliers',remove_max);
    app = outliers_analysis(video_data,rmse_from_med,TF,'mse_from_mean');

%     filaname_save = filename;
%     filaname_save = [replace(filaname_save,'.avi','') 'tmp.mat'];

%     save(filaname_save,'video_data','mse_from_mean')
%     load(filaname_save)


  
    


    

    while isvalid(app)
        pause(0.1);
    end

end







