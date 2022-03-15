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
for k = 1:length(filenames)
    
    filename = filenames(perm(k)).name;
    
    
%     vidObj = VideoReader(filename);
%     
%     video_num_frames = vidObj.NumFrames;
%     
%     video_data = zeros(vidObj.Height,vidObj.Width,video_num_frames, 'uint8');
%     
%     frame_ind = 0;
%     while hasFrame(vidObj)
%         frame_ind = frame_ind + 1;
%         frame = readFrame(vidObj);
%         video_data(:,:,frame_ind) = frame(:,:,1);
%     end
%     video_data = double(video_data)/255;
%     
%     shape = size(video_data);
%     shape_reduce = round(0.2 * shape);
%     shape_reduce = shape_reduce - mod(shape_reduce,2);
%     shape_small = shape - shape_reduce;
%     W_small = hamming(shape_small(1))*hamming(shape_small(2))';
%     W = padarray(W_small,[shape_reduce(1)/2 shape_reduce(2)/2],'both');
% 
% 
% 
%    
%     
%     
%     weighted_hists = zeros(256,size(video_data,3));
%     gradsums = zeros(1,size(video_data,3));
%     entropys = zeros(1,size(video_data,3));
%     for frame_ind = 1:size(video_data,3)
%     
%         frame_ind
%     
%         frame = video_data(:,:,frame_ind);
%     
%         [Gmag,Gdir] = imgradient(frame);
%         gradsums(frame_ind) = sum(Gmag(:) .* W(:) ) / sum(W(:));
% %         gradsums(frame_ind) = sum(Gmag(:).^2 .* W(:) ) / sum(W(:));
%         
% 
%     
%         weighted_hist = whist(uint8(frame(:)*255),W(:));
%         weighted_hists(:,frame_ind) = weighted_hist;
%     
%         weighted_hist(weighted_hist==0) = [];
%         weighted_hist = weighted_hist ./ sum(W(:));
%         entropys(frame_ind) = -sum(weighted_hist.*log2(weighted_hist));
%     
%     
%     end
% 
%     hist_diffs =  sqrt(sum((weighted_hists - median(weighted_hists,2)).^2,1));
% 
% 
%     median_image =  median(video_data,3);
%     data_min_med = video_data - repmat(median_image,[1,1,size(video_data,3)]);
%     W3 = repmat(W,[1,1,size(video_data,3)]);
%     mse_from_mean  =  squeeze(sqrt(sum( W3 .* (data_min_med.^2),[1,2])))';
% 
%     video_data = uint8(video_data*255);

    filaname_save = filename;
    filaname_save = [replace(filaname_save,'.avi','') 'tmp.mat'];

%     save(filaname_save,'video_data','hist_diffs','mse_from_mean','gradsums','entropys')
    load(filaname_save)


    remove_max = round(size(video_data,3)*0.2);
    thresholdFactor = 0.03;
    medfilt_size = 61;
   
    
    
    minus_med = mse_from_mean - my_medfilt1(mse_from_mean,medfilt_size);
    [B,TF] = rmoutliers(minus_med,'gesd','ThresholdFactor',thresholdFactor,'MaxNumOutliers',remove_max);

    
    minus_med = gradsums - my_medfilt1(gradsums,medfilt_size);
    [B,TF2] = rmoutliers(minus_med,'gesd','ThresholdFactor',thresholdFactor,'MaxNumOutliers',remove_max);     


    minus_med = entropys - my_medfilt1(entropys,medfilt_size);
    [B,TF3] = rmoutliers(minus_med,'gesd','ThresholdFactor',thresholdFactor,'MaxNumOutliers',remove_max);


%     app = outliers_analysis(video_data,hist_diffs,TF,'histdiff',gradsums,TF2,'gradsum',entropys,TF3,'entropy');
    app = outliers_analysis(video_data,mse_from_mean,TF,'mse_from_mean',gradsums,TF2,'gradsum',entropys,TF3,'entropy');

    while isvalid(app)
        pause(0.1);
    end

%      exportapp(app.UIFigure,[default_name(1:end-4) '_example.png'])
end







% hist_diffs_percentile = hist_diffs(hist_diffs < prctile(hist_diffs,90) );
% thresh = median(hist_diffs_percentile) +  std(hist_diffs_percentile);

% x = 1:length(hist_diffs);
% close all;
% plot(x,hist_diffs_minus_med)
% hold on
% plot(x(TF),hist_diffs_minus_med(TF),'r*')



% hold on;
% plot(1:length(hist_diffs),repmat(thresh,[1,length(hist_diffs)]))





