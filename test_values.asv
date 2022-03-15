clc;clear all;close all



% wavelength = 470;
% wavelength = 525;
wavelength = 580;
% wavelength = 595;
% wavelength = 660;

filename = "D:\data_vo_rate\Sada_01_001\Sada_01_001_wavelength\Gacr_01_001_01_wavelength_m.avi";
filename = replace(filename,'wavelength',num2str(wavelength));


vidObj = VideoReader(filename);

video_num_frames = vidObj.NumFrames;

video_data = zeros(vidObj.Height,vidObj.Width,video_num_frames, 'uint8');

frame_ind = 0;
while hasFrame(vidObj)
    frame_ind = frame_ind + 1;
    frame = readFrame(vidObj);
    video_data(:,:,frame_ind) = frame(:,:,1);
end
video_data = double(video_data)/255;

W = hamming(size(video_data,1))*hamming(size(video_data,2))';


weighted_hists = zeros(256,size(video_data,3));
gradsums = zeros(1,size(video_data,3));
entropys = zeros(1,size(video_data,3));
for frame_ind = 1:size(video_data,3)

    frame_ind

    frame = video_data(:,:,frame_ind);

    [Gmag,Gdir] = imgradient(frame);
    gradsums(frame_ind) = sum(Gmag(:) .* W(:) ) / sum(W(:));
    

    weighted_hist = whist(uint8(frame(:)*255),W(:));
    weighted_hists(:,frame_ind) = weighted_hist;

    weighted_hist(weighted_hist==0) = [];
    weighted_hist = weighted_hist ./ sum(W(:));
    entropys(frame_ind) = -sum(weighted_hist.*log2(weighted_hist));


end

hist_diffs =  sqrt(sum((weighted_hists - median(weighted_hists,2)).^2,1));


% hist_diffs(rand(size(hist_diffs))>0.9) = max(hist_diffs(:));

hist_diffs_minus_med = hist_diffs - medfilt1(hist_diffs,50,'truncate');
remove_max = round(length(hist_diffs_minus_med)*0.2);
[B,TF] = rmoutliers(hist_diffs_minus_med,'gesd','ThresholdFactor',0.5,'MaxNumOutliers',remove_max);


x = 1:length(hist_diffs);
close all;
plot(x,hist_diffs_minus_med)
hold on
plot(x(TF),hist_diffs_minus_med(TF),'r*')




% hist_diffs_percentile = hist_diffs(hist_diffs < prctile(hist_diffs,90) );
% thresh = median(hist_diffs_percentile) +  std(hist_diffs_percentile);




% hold on;
% plot(1:length(hist_diffs),repmat(thresh,[1,length(hist_diffs)]))





