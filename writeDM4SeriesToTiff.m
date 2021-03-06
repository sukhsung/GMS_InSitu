%Noah Schnitzer 
%20180514 Initial script based on dm4movie2stack by SSH
%Modified to write single precision tiffstack directly by SSH

%source_directory: path to dm4 directory which contains Hour_00 (and all
%subfolders

%prefactor:begining of file name. e.g. primatic

%bit_depth: desired bit depth of final tiff.

%max_percentile: For outlier removal, top x percentile are chopped off. Set
%to 100 for no removal

%tiff_path: path to output tiff file

%frame_averaging: number of frames (>=1) to average over-- 1 keeps all
%information

%image_scale: scale for imresize-- 1 keeps dims, >1 -> larger, <1 ->
%smaller


function writeDM4SeriesToTiff(source_dir, save_dir, dataname, image_scale)
    files = dir(fullfile(source_dir,'/*/*/*/*.dm4'));
    numFiles = length(files);
    disp_counter = 10;
    finished = false;
    ind = 1;
    % Read First Image to determine metadata
    while ind <= numFiles && ~finished
        if contains(files(ind).name, dataname) && files(ind).name(1) ~= '.'  % Checking for a proper file
            img = bfopen_im( fullfile(files(ind).folder,'/',files(ind).name) );
            [nr,nc] = size(imresize(img, image_scale,'bilinear'));            
            finished = true;
        end
        ind = ind+1;
    end 
    
    tiffObj = Tiff( fullfile(save_dir, [dataname,'.tif']), 'w8'); %w8: tag for writing BigTIFF
    % Tiff Tags
    tagstruct.Photometric = Tiff.Photometric.MinIsBlack;    %0 is black
    tagstruct.Compression = Tiff.Compression.None;           %Lossless LZW Compression
    tagstruct.BitsPerSample = 32;                            %32bit
    tagstruct.SamplesPerPixel = 1;                          %BW image
    tagstruct.ImageWidth = nc;                              %Image size
    tagstruct.ImageLength = nr;                             %Image size
    tagstruct.PlanarConfiguration = Tiff.PlanarConfiguration.Chunky;
    tagstruct.SampleFormat = Tiff.SampleFormat.IEEEFP;        %FLoating point
    
    for ind = 1:numFiles % First pass to find global min max
        if rem(ind,disp_counter) == 0
            fprintf('%d out of %d done\n',ind,numFiles)
        end
        if contains(files(ind).name, dataname) && files(ind).name(1) ~= '.'  % Checking for a proper file
            img = bfopen_im( fullfile(files(ind).folder,'/',files(ind).name) );
            
            img_rsz = (imresize(img, image_scale,'bilinear'));            
            setTag(tiffObj,tagstruct)       %Set tag for each image
            write(tiffObj,img_rsz); %Write image
            tiffObj.writeDirectory          %Move to next slice

            
            
        end
    end 
    
    
   
    close(tiffObj);
end



