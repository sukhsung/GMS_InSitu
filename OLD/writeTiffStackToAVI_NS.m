%Noah Schnitzer 
%20180514 Initial script based on tiffStack2avi by SSH

%tiff_path:path to source tiff file
%avi_path:path to output avi file
%bit_depth:bit depth of source tiff, for normalization
%frame_rate:sets frames per second of video
%remove_outliers:toggles filloutliers functionality
%skip_count: number of frames to skip at the begining of tiff stack before
%begining video

function writeTiffStackToAVI_NS(tiff_path, avi_path, bit_depth, frame_rate, remove_outliers, skip_count, xrange, yrange)
    frame_start = 1;
    
    frame_stop = 1052;


    tiffObj = Tiff(tiff_path,'r');
    vidObj = VideoWriter([avi_path]);
    vidObj.FrameRate = frame_rate;
    open(vidObj)
    count = 0;
    while ~tiffObj.lastDirectory
        count = count + 1;
        if ~tiffObj.lastDirectory && ( count < skip_count || (count <frame_start) || (count > frame_stop) )
            tiffObj.nextDirectory
            tiffObj.currentDirectory
        end
        cur_im = double(tiffObj.read);
        if remove_outliers
            cur_im = filloutliers(cur_im,'nearest','movmedian',7);
        end
        cur_im = cur_im/2^bit_depth;%cur_im/max(cur_im(:));
        if nargin > 7
            writeVideo(vidObj,cur_im(xrange,yrange));
        else
            writeVideo(vidObj,cur_im);        
        end
        if ~tiffObj.lastDirectory
            tiffObj.nextDirectory
            tiffObj.currentDirectory
        end
    end

    close(vidObj)

end