%Noah Schnitzer 
%20180514 Initial script based on dm4movie2stack by SSH
%Modified to write Motion JPEG 2000 Lossless avi directly by SSH

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


function writeDM4SeriesToAvi_Obsolete(source_directory, prefactor, bit_depth,  avi_path, frame_averaging,avi_skip_count, image_scale,frame_rate)
    if bit_depth == 8
        type = 'uint8';
    elseif bit_depth == 16
        type = 'uint16';
    else
        error('choose bit_depth of 16 or 8')
    end


    vidObj = VideoWriter(avi_path,'archival'); % 'archival' == lossless motion jpeg 2000
    vidObj.LosslessCompression = true;         % Enforce Lossless compression
    vidObj.FrameRate = frame_rate;             % Frame Rate 
    vidObj.MJ2BitDepth = bit_depth;            % bit depth
    open(vidObj)
    
    files = dir([source_directory,'/*/*/*/*.dm4']);
    numFiles = length(files);
    disp_counter = 10;
    
    mins= inf*ones(numFiles,1);
    maxs=-inf*ones(numFiles,1);
    
    
    for ind = 1:numFiles % First pass to find global min max
        if rem(ind,disp_counter) == 0
            fprintf('%d out of %d done\n',ind,numFiles)
        end
        if contains(files(ind).name, prefactor) && files(ind).name(1) ~= '.'  % Checking for a proper file
            img = bfopen_im([files(ind).folder,'/',files(ind).name]);
            
            mins(ind) = min(img(:));
            maxs(ind) = max(img(:));
            
            
        else
            files(ind)=[];
            numFiles = numFiles-1;
        end
    end 
    
    
    gl_min = min(mins);
    gl_max = max(maxs);
    
    [nr,nc] = size(img);
    img = zeros(nr,nc);
    count = 0;
    frame_count = 1;
    
    
    for ind = 1:numFiles % Second pass to convert data and save avi
        count = count + 1;
        if rem(ind,disp_counter) == 0
            fprintf('%d out of %d done\n',ind,numFiles)
        end
        if count > avi_skip_count
            img = img + bfopen_im([files(ind).folder,'/',files(ind).name]);
            if mod(frame_count,frame_averaging) == 0
                img = img/frame_averaging;
                
                img_rsz = imresize(img, image_scale,'bilinear');
                
                img_rsz = img_rsz - gl_min;
                img_rsz_uint = cast(img_rsz/gl_max*(2^bit_depth - 1),type);
                
                %write avi
                writeVideo(vidObj,img_rsz_uint)
                
                
                %reset img
                img = zeros(nr,nc);
            end
            frame_count = 1;
        end
    end
    close(vidObj)
end



