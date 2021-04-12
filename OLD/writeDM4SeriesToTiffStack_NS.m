%Noah Schnitzer 
%20180514 Initial script based on dm4movie2stack by SSH


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


function writeDM4SeriesToTiffStack_NS(source_directory, prefactor, bit_depth, min_percentile, max_percentile, tiff_path, frame_averaging, image_scale,tiff_skip_count,np)

    tiffObj = Tiff([tiff_path],'w8'); %w8: tag for writing BigTIFF\
    tagstruct.Photometric = Tiff.Photometric.MinIsBlack;
    tagstruct.Compression = Tiff.Compression.None;
    tagstruct.BitsPerSample = bit_depth;
    tagstruct.SamplesPerPixel = 1;
    tagstruct.ImageWidth = np*image_scale;
    tagstruct.ImageLength = np*image_scale;
    tagstruct.PlanarConfiguration = Tiff.PlanarConfiguration.Chunky;
    tagstruct.SampleFormat = Tiff.SampleFormat.UInt;
    img = zeros(np,np);
    count = 0;
    frame_count = 1;
    level1 =dir(source_directory);
    for it1 = 1:length(level1)
       if level1(it1).name(1)=='H'
          path = [source_directory '/' level1(it1).name];

          level2 = dir(path);
          for it2 = 1:length(level2)
             if level2(it2).name(1)=='M'
                path = [source_directory '/' level1(it1).name '/' level2(it2).name];

                level3 = dir(path);
                for it3 = 1:length(level3)
                   if level3(it3).name(1)== 'S'
                       path = [source_directory '/' level1(it1).name '/' level2(it2).name '/' level3(it3).name];

                       level4 = dir([path '/' '*.*']);
                       for it4 = 1:length(level4)
                           if contains(level4(it4).name, prefactor) && count > tiff_skip_count && level4(it4).name(1) ~= '.' 
                               
                               img =  img + bfopen_im([path '/' level4(it4).name]);
                                if mod(frame_count,frame_averaging) == 0
                                    img = imresize(img, image_scale);
                                    img = img/frame_averaging;
                                    min_pct = my_prctile(img(:),min_percentile);
                                    max_pct = my_prctile(img(:),max_percentile);
                                    img(img > max_pct) = max_pct;
                                    img(img < min_pct) = min_pct;
                                    img = img - min(img(:));
                                    img = img/max(img(:));
                                    %img(img > global_max) = global_max;
                                    img = uint16(img.* 2^bit_depth); 
                                    %img = imrotate(img, angle);
                                    setTag(tiffObj,tagstruct);
                                    write(tiffObj,img);
                                    tiffObj.writeDirectory
                                    img = zeros(np,np);
                                end                               
                               
                                level4(it4).name 
                                

                                frame_count = frame_count+1
                                
                           elseif contains(level4(it4).name, prefactor)
                               count = count + 1;
                           end
                       end
                   end
                end
             end
          end
       end
    end

    close(tiffObj)

end




function brokedn_writeDM4SeriesToTiffStack_NS(source_directory, prefactor, bit_depth, max_percentile, tiff_path, frame_averaging, image_scale,tiff_skip_count)

    global_max = 0;
    global_min = 1e9;
    orig_max = 0;
    
    count = 0;
    %% First pass: get global max, min, median
    level1 =dir(source_directory);
    for it1 = 1:length(level1)
       if level1(it1).name(1)=='H'
          path = [source_directory '/' level1(it1).name];

          level2 = dir(path);
          for it2 = 1:length(level2)
             if level2(it2).name(1)=='M'
                path = [source_directory '/' level1(it1).name '/' level2(it2).name];

                level3 = dir(path);
                for it3 = 1:length(level3)
                   if level3(it3).name(1)== 'S'
                       path = [source_directory '/' level1(it1).name '/' level2(it2).name '/' level3(it3).name];

                       level4 = dir([path '/' '*.*']);
                       for it4 = 1:length(level4)
                           if contains(level4(it4).name, prefactor) && count > tiff_skip_count
                                level4(it4).name 
                                img = bfopen_im([path '/' level4(it4).name]);
                                local_max = prctile(img(:),max_percentile);
                                local_min = min(img(:));
                                local_full_max = max(img(:));


                                if orig_max < local_full_max
                                    orig_max = local_full_max;
                                end
                                if global_max < local_max
                                    global_max = local_max
                                end
                                if global_min > local_min
                                    global_min = local_min
                                    np = size(img,1);
                                end
                           elseif contains(level4(it4).name, prefactor)
                               
                               count = count + 1;
                           end
                       end
                   end
                end
             end
          end

       end
    end
    %% Second pass: normalize and write to file

    tiffObj = Tiff([tiff_path],'w8'); %w8: tag for writing BigTIFF\
    tagstruct.Photometric = Tiff.Photometric.MinIsBlack;
    tagstruct.Compression = Tiff.Compression.None;
    tagstruct.BitsPerSample = bit_depth;
    tagstruct.SamplesPerPixel = 1;
    tagstruct.ImageWidth = np*image_scale;
    tagstruct.ImageLength = np*image_scale;
    tagstruct.PlanarConfiguration = Tiff.PlanarConfiguration.Chunky;
    tagstruct.SampleFormat = Tiff.SampleFormat.UInt;

    count = 0;
    img = zeros(np, np);
    frame_count = 0;
    level1 =dir(source_directory);
    for it1 = 1:length(level1)
       if level1(it1).name(1)=='H'
          path = [source_directory '/' level1(it1).name];

          level2 = dir(path);
          for it2 = 1:length(level2)
             if level2(it2).name(1)=='M'
                path = [source_directory '/' level1(it1).name '/' level2(it2).name];

                level3 = dir(path);
                for it3 = 1:length(level3)
                   if level3(it3).name(1)== 'S'
                       path = [source_directory '/' level1(it1).name '/' level2(it2).name '/' level3(it3).name];

                       level4 = dir([path '/' '*.*']);
                       for it4 = 1:length(level4)
                           if contains(level4(it4).name, prefactor) && count > tiff_skip_count
                               img = img + bfopen_im([path '/' level4(it4).name]);
                                if mod(frame_count,frame_averaging) == 0
                                    img = imresize(img, image_scale);
                                    img = img/frame_count;
                                    img = img - global_min;
                                    img = img/global_max;
                                    img(img > global_max) = global_max;
                                    img = uint16(img.* 2^bit_depth);                 
                                    setTag(tiffObj,tagstruct);
                                    write(tiffObj,img);
                                    tiffObj.writeDirectory
                                    img = zeros(np, np);
                                end                               
                               
                                level4(it4).name 
                                

                                frame_count = frame_count+1
                                
                           elseif contains(level4(it4).name, prefactor)
                               count = count + 1;
                           end
                       end
                   end
                end
             end
          end
       end
    end

    close(tiffObj)

end
