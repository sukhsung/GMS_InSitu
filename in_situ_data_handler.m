%% TaS2 Insitu Heating
img_scale = 0.5;


src_dir = '/Volumes/SSH-BLUE/Data/20210410_TaS2_Protochip/TaS2_Cooling_300C_80C_1Cps_exp_0p2';
dataname = 'TaS2_Cooling_300C_80C_1Cps_exp_0p2';
save_dir = '/Volumes/SSH-BLUE/Data/20210410_TaS2_Protochip/Processed/TaS2_Cooling_300C_80C_1Cps_exp_0p2';
mkdir(save_dir);

writeDM4SeriesToTiff(src_dir, save_dir, dataname, img_scale)


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
