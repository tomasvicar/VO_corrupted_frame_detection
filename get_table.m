clc;clear all;close all force;


tmp_save_folder = 'D:/data_vo_tmp';


filenames = subdir('D:/data_vo_registered/*.avi');
filenames = {filenames(:).name};

has_not_660_ = cellfun(@(x) contains(x,'_660_')==0, filenames, UniformOutput=true) ;
filenames = filenames(has_not_660_);

filenames_for_table = {};

 outliers_ind = cell(1,length(filenames));
% rng(42)
% perm = randperm(length(filenames));
for k = 1:length(filenames)
    
%     filename = filenames(perm(k)).name;
    filename = filenames{k};

    disp([num2str(k) ' / ' num2str(length(filenames))])
    disp(filename)


    [~,tmp_save_filename,~] =  fileparts(filename);

    filenames_for_table = [filenames_for_table, tmp_save_filename];

    tmp_save_filename = [tmp_save_folder '/' tmp_save_filename  '.mat'];

    out_liears = load(tmp_save_filename);
    outliers= out_liears.outliers_binar_manual;
    

    ind = find(outliers);
    outliers_ind{k} = num2str(ind);


end



filenames = filenames_for_table';
outliers_ind = outliers_ind';

T = table(filenames,outliers_ind);

writetable(T ,['corrupted_frames.xlsx'])

