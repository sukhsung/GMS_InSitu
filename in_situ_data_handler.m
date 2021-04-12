addpath('bfmatlab')

%% TaS2 Insitu Heating
img_scale = 0.5;


src_dir = '/media/hlab/gohymin/20210411_CrSBr/Region2_E_thick/2130_CrSBr_DTS_p30_n30_speed_2percent_C2_150_SA_10_CL_660mm';
dataname = '2130_CrSBr_DTS_p30_n30_speed_2percent_C2_150_SA_10_CL_660mm';
save_dir = '/media/hlab/gohymin/20210411_CrSBr/Processed/Region2_E_thick/2130_CrSBr_DTS_p30_n30_speed_2percent_C2_150_SA_10_CL_660mm';
mkdir(save_dir);

writeDM4SeriesToTiff(src_dir, save_dir, dataname, img_scale)


