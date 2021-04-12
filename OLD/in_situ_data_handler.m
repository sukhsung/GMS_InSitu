%% TaS2 Insitu Heating
bit_depth = 16;
frame_rate = 25;
frame_averaging = 1;
image_scale = 1/4;
tiff_skip_count = 0;

% %% test drive
% source_dir = '/Volumes/hlab_MP5/201904230_TaS2_InSituTEMDIff/test';
% prefactor = 'Indium Coalescence Test - 18';
% tiff_path = '/Volumes/hlab_MP5/201904230_TaS2_InSituTEMDIff/test.tif';
% writeDM4SeriesToTiff(source_dir, prefactor,  tiff_path, frame_averaging,tiff_skip_count, image_scale)
% 


%% driver
source_dir = '/Volumes/hlab_MP5/201904230_TaS2_InSituTEMDIff/Indium Coalescence Test - 19';
prefactor = 'Indium Coalescence Test - 19';
tiff_path = '/Users/sukhyun/19_tiffstack.tif';
writeDM4SeriesToTiff(source_dir, prefactor,  tiff_path, frame_averaging,tiff_skip_count, image_scale)
source_dir = '/Volumes/hlab_MP5/201904230_TaS2_InSituTEMDIff/Indium Coalescence Test - 20';
prefactor = 'Indium Coalescence Test - 20';
tiff_path = '/Users/sukhyun/20_tiffstack.tif';
writeDM4SeriesToTiff(source_dir, prefactor,  tiff_path, frame_averaging,tiff_skip_count, image_scale)
% 
% 
% source_dir = '/Volumes/hlab_MP5/201904230_TaS2_InSituTEMDIff/Indium Coalescence Test - 19';
% prefactor = 'Indium Coalescence Test - 19';
% tiff_path = '/Volumes/hlab_MP5/201904230_TaS2_InSituTEMDIff/19_tiffstack.tif';
% writeDM4SeriesToTiff(source_dir, prefactor,  tiff_path, frame_averaging,tiff_skip_count, image_scale)

%source_dir = '/Volumes/SSH/20190624_TaS2_insituheat/1';
%prefactor = '1';
%tiff_path = '/Users/sukhyun/1_tiffstack.tif';
%writeDM4SeriesToTiff(source_dir, prefactor,  tiff_path, frame_averaging,tiff_skip_count, image_scale)

%writeTiffStackToAVI_NS(tiff_path, avi_path, bit_depth, frame_rate, remove_outliers, avi_skip_count,crop_x,crop_y);
