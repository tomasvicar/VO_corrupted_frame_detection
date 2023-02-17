clc;clear all;close all force;


final_save_folder = '../outliers_tmp_finalres';

tmp_save_folder = '../outliers_tmp';


% filenames = subdir('D:/data_vo_registered2/*.avi');
% filenames = {filenames(:).name};

filenames = {};
filenames_tmp = subdir('../Sada_02/*_registered.avi');
filenames = [filenames,filenames_tmp(:).name];



% 
% has_not_660_ = cellfun(@(x) contains(x,'_660_')==0, filenames, UniformOutput=true) ;
% filenames = filenames(has_not_660_);

filenames_for_table = {};

%  outliers_ind = cell(1,length(filenames));
% rng(42)
% perm = randperm(length(filenames));
for k = 1:length(filenames)
    
%     filename = filenames(perm(k)).name;
    filename = filenames{k};

    disp([num2str(k) ' / ' num2str(length(filenames))])
    disp(filename)


    [~,tmp_save_filename,~] =  fileparts(filename);

%     filenames_for_table = [filenames_for_table, tmp_save_filename];
    name = tmp_save_filename;

    tmp_save_filename = [tmp_save_folder '/' tmp_save_filename  '.mat'];



    out_liears = load(tmp_save_filename);
    outliers= out_liears.outliers_binar_manual;
    



    ind = find(outliers);
%     outliers_ind{k} = num2str(ind);
    drawnow;

    s = struct();
    s.corrupted_frames = ind;
    s.note = 'index start from 1 (matlab notation)';

    json_data = jsonencode(s);

    fname = [final_save_folder '/' replace(replace(replace(name,'_registered',''),'_wl1',''),'_wl2','') '/Varia' '/' name '_corrupted_frames.json'];
    
    mkdir(fileparts(fname))

    fileID = fopen(fname,'w');
    fprintf(fileID, json_data);
    fclose(fileID);

end



