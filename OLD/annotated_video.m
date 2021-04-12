function [] = annotated_video()
    annotated_video_aragonite_6
end
function [] = annotated_video_aragonite_6(tiff_stack_path, tiff_indices, curve_path, curve_indices, output_path,bit_depth, frame_rate)
    tiff_stack_path = '/Volumes/hlab_MP5/pa6_crop_v0.tif';%'/Volumes/hlab_MP4/nacre_28_10_5.tif';
    tiff_indices = 190:560;%1054;%1071 frames
    curve_path = '/Volumes/hlab_MP5/700nm 06 DC.csv';
    output_path = 'aragonite_annotated_6.avi';
    bit_depth = 16;
    frames_per_second = 50;
    frame_rate = 10;
    not_white = [.99999 1 1];
    
    
    rotation_angle = 0; %degrees
    x0_crop = 1;
    y0_crop = 1;
    x1_crop = 2048;
    y1_crop = 2048;
    
    
    

    curve = dlmread(curve_path);
    
    
    %curve = curve(curve_indices,:);
    
    t1 = 190;
    t2 = 549;
    c1 = 348;
    c2 = 1759;
    
    
    m = (c2-c1)/(t2-t1); %describes curve / tiff indices
    b = c1-t1*m;%-32950.47; %offset for tiff index = 0
    C = round(m.*tiff_indices + b);
    
    curve(c2:end,1) = nan;
    curve(c2:end,2) = nan;
    
    curve(end:C(end),:) = (curve(end,:)'*ones(1,C(end)-length(curve)+1))';
    
    vidObj = VideoWriter([output_path],'Uncompressed AVI');
    vidObj.FrameRate = frame_rate;
    open(vidObj)

    %fig = figure('rend', 'painters','pos',[100 100 600 600]);
    
    tiffObj = Tiff(tiff_stack_path,'r');
    
    for it = 2:tiff_indices((1)) %skipping 1 b/c start at first frame
        tiffObj.nextDirectory;
    end

    for it = 1:length(tiff_indices)
        
        fig = figure('rend', 'painters','pos',[100 100 600 510]);

        ax1 = axes('Position',[0 0 1 1]);
        
        
        if ~tiffObj.lastDirectory
        tiffObj.currentDirectory
        
        img = double(tiffObj.read());
        img = flip(img,1);
        img = imrotate(img,rotation_angle);
        img = img(y0_crop:y1_crop,x0_crop:x1_crop );
        imagesc(img/2^bit_depth,[.45 .95]);
        colormap gray;
        hold on
        rectangle('Position',[40 40 260 25],'FaceColor',not_white,'EdgeColor',not_white);
        text(40,100, '500 nm' ,'FontSize',20,'Color',not_white);
        
        time = it/frames_per_second;
        min = num2str(floor(time/60));
        sec = num2str(floor(mod(time,60)));
        if(length(sec) == 1)
           sec = ['0' sec]; 
        end
        time_str = [min ':' sec];
        text(40,180,time_str, 'FontSize',20,'Color',not_white);
        set(gca,'XTick',[])
        set(gca,'YTick',[])

        ax3 = axes('Position',[0.57 0.15 0.34 0.25]);
        p = plot(curve(C(1:it),1)-curve(C(1),1),curve(C(1:it),2),'Color', not_white, 'LineWidth',4);
        ax3.XLim = [0 max(curve(1:C(end),1))];
        ax3.YLim = [0 max(curve(1:C(end),2))];
        xlabel('Displacement (nm)');
        ylabel('Force (\muN)');
        set(gca,'Color','none');
        set(gca,'XColor',not_white);
        set(gca,'YColor',not_white);
        set(gca,'ZColor',not_white);
        set(gca,'FontSize',20);
        set(gca,'LineWidth',1); %width of axis lines
        box off

        drawnow;
        print('cur','-djpeg','-r150')
    
        writeVideo(vidObj,imread('cur.jpg'));
        %delete(p);
        
        tiffObj.nextDirectory;
        close all;
        end
    end
    close(vidObj)
    
end

function [] = annotated_video_aragonite(tiff_stack_path, tiff_indices, curve_path, curve_indices, output_path,bit_depth, frame_rate)
    tiff_stack_path = '/Volumes/hlab_MP5/11_crop_v0.tif';%'/Volumes/hlab_MP4/nacre_28_10_5.tif';
    tiff_indices = 18:100;%1054;%1071 frames
    curve_path = '/Volumes/hlab_MP5/aragonite_11_croped_red_2.csv';
    curve_indices = [1:11735];%[30000:65449,1:2];
    output_path = 'aragonite_annotated_11.avi';
    bit_depth = 16;
    frames_per_second = 12.5;
    frame_rate = 10;
    not_white = [.99999 1 1];
    
    
    rotation_angle = 0; %degrees
    x0_crop = 1;
    y0_crop = 1;
    x1_crop = 4096;
    y1_crop = 4096;
    
    
    

    curve = dlmread(curve_path);
    
    
    %curve = curve(curve_indices,:);
    
    m = 16.737; %describes curve / tiff indices
    b = -156;%-32950.47; %offset for tiff index = 0
    C = round(m.*tiff_indices + b);
    
    curve(end:C(end),:) = (curve(end,:)'*ones(1,C(end)-length(curve)+1))';
    
    vidObj = VideoWriter([output_path],'Uncompressed AVI');
    vidObj.FrameRate = frame_rate;
    open(vidObj)

    %fig = figure('rend', 'painters','pos',[100 100 600 600]);
    
    tiffObj = Tiff(tiff_stack_path,'r');
    
    for it = 2:tiff_indices((1)) %skipping 1 b/c start at first frame
        tiffObj.nextDirectory;
    end

    for it = 1:length(tiff_indices)
        
        fig = figure('rend', 'painters','pos',[100 100 600 510]);

        ax1 = axes('Position',[0 0 1 1]);
        
        
        if ~tiffObj.lastDirectory
        tiffObj.currentDirectory
        
        img = double(tiffObj.read());
        img = flip(img,1);
        img = imrotate(img,rotation_angle);
        img = img(y0_crop:y1_crop,x0_crop:x1_crop );
        imshow(img/2^bit_depth);
        hold on
        rectangle('Position',[40 3920 260 25],'FaceColor',not_white,'EdgeColor',not_white);
        text(40,4000, '1 \mum' ,'FontSize',20,'Color',not_white);
        
        time = it/frames_per_second;
        min = num2str(floor(time/60));
        sec = num2str(floor(mod(time,60)));
        if(length(sec) == 1)
           sec = ['0' sec]; 
        end
        time_str = [min ':' sec];
        text(40,3850,time_str, 'FontSize',20,'Color',not_white);
        
        ax3 = axes('Position',[0.57 0.15 0.34 0.25]);
        p = plot(curve(C(1:it),1),curve(C(1:it),2),'Color', not_white, 'LineWidth',4);
        ax3.XLim = [0 max(curve(1:C(end),1))];
        ax3.YLim = [0 max(curve(1:C(end),2))];
        xlabel('Displacement (nm)');
        ylabel('Force (\muN)');
        set(gca,'Color','none');
        set(gca,'XColor',not_white);
        set(gca,'YColor',not_white);
        set(gca,'ZColor',not_white);
        set(gca,'FontSize',20);
        set(gca,'LineWidth',1); %width of axis lines
        box off

        drawnow;
        print('cur','-djpeg','-r150')
    
        writeVideo(vidObj,imread('cur.jpg'));
        %delete(p);
        
        tiffObj.nextDirectory;
        close all;
        end
    end
    close(vidObj)
    
end

function [] = annotated_video_nacre(tiff_stack_path, tiff_indices, curve_path, curve_indices, output_path,bit_depth, frame_rate)
    tiff_stack_path = '/Volumes/Noah/JiseokGim/process_testing/28_crop_v0.tif';%'/Volumes/hlab_MP4/nacre_28_10_5.tif';
    tiff_indices = 54:3342;%1655:4941; %3352
    curve_path = '/Volumes/hlab_MP4/28_compressive_crack_thin_crop.csv';
    curve_indices = [1:65451];%[30000:65449,1:2];
    output_path = 'nacre_annotated.avi';
    bit_depth = 16;
    frames_per_second = 10;
    frame_rate = 10;
    not_white = [.99999 1 1];
    
    rotation_angle = -67; %degrees
    x0_crop = 176;
    y0_crop = 578;
    x1_crop = x0_crop + 1854;
    y1_crop = y0_crop + 1248;
    
    
    

    curve = dlmread(curve_path);
    %curve = curve(curve_indices,:);
    
    m = 19.904;%19.9151; %describes curve / tiff indices
    b = -1071.37;%-32950.47; %offset for tiff index = 0
    C = round(m.*tiff_indices + b);
    
    
    vidObj = VideoWriter([output_path],'Uncompressed AVI');
    vidObj.FrameRate = frame_rate;
    open(vidObj)

    %fig = figure('rend', 'painters','pos',[100 100 600 600]);
    
    tiffObj = Tiff(tiff_stack_path,'r');
    
    for it = 2:tiff_indices((1)) %skipping 1 b/c start at first frame
        tiffObj.nextDirectory;
    end

    for it = 1:length(tiff_indices)
        
        fig = figure('rend', 'painters','pos',[100 100 600 400]);

        ax1 = axes('Position',[0 0 1 1]);
        
        
        if ~tiffObj.lastDirectory
        tiffObj.currentDirectory
        
        img = double(tiffObj.read());
        img = imrotate(img,rotation_angle,'crop');
        img = img(y0_crop:y1_crop,x0_crop:x1_crop );
        imshow(img/2^bit_depth);
        hold on
        rectangle('Position',[10 10 310 25],'FaceColor','w');
        text(40,65, '500 nm' ,'FontSize',20,'Color',not_white);
        
        time = it/frames_per_second;
        min = num2str(floor(time/60));
        sec = num2str(floor(mod(time,60)));
        if(length(sec) == 1)
           sec = ['0' sec]; 
        end
        time_str = [min ':' sec];
        text(40,125,time_str, 'FontSize',20,'Color',not_white);
        
        ax3 = axes('Position',[0.63 0.15 0.34 0.25]);
        p = plot(curve(C(1:it),1),curve(C(1:it),2),'Color', not_white, 'LineWidth',4);
        ax3.XLim = [0 max(curve(1:C(end),1))];
        ax3.YLim = [0 max(curve(1:C(end),2))];
        xlabel('Displacement (nm)');
        ylabel('Force (\muN)');
        set(gca,'Color','none');
        set(gca,'XColor',not_white);
        set(gca,'YColor',not_white);
        set(gca,'ZColor',not_white);
        set(gca,'FontSize',20);
        set(gca,'LineWidth',1); %width of axis lines
        box off

        drawnow;
        print('cur','-djpeg','-r150')
    
        writeVideo(vidObj,imread('cur.jpg'));
        %delete(p);
        
        tiffObj.nextDirectory;
        close all;
        end
    end
    close(vidObj)
    
end


function [] = annotated_video_prismatic(tiff_stack_path, tiff_indices, curve_path, curve_indices, output_path,bit_depth, frame_rate)
    tiff_stack_path = '/Volumes/hlab_MP2/process_testing/23_crop_v0.tif';%'/Volumes/hlab_MP4/nacre_28_10_5.tif';
    tiff_indices = 81:820;%1054;%1071 frames
    curve_path = '/Volumes/hlab_MP2/prismatic_23 crop.csv';
    curve_indices = [1:11735];%[30000:65449,1:2];
    output_path = 'prismatic_annotated_3.avi';
    bit_depth = 16;
    frames_per_second = 10;
    frame_rate = 10;
    not_white = [.99999 1 1];
    
    
    rotation_angle = -20; %degrees
    x0_crop = 308;
    y0_crop = 544;
    x1_crop = x0_crop + 1918;
    y1_crop = y0_crop + 1638;
    
    
    

    curve = dlmread(curve_path);
    
    
    %curve = curve(curve_indices,:);
    
    m = 16.1337; %describes curve / tiff indices
    b = -1302;%-32950.47; %offset for tiff index = 0
    C = round(m.*tiff_indices + b);
    
    curve(end:C(end),:) = (curve(end,:)'*ones(1,C(end)-length(curve)+1))';
    
    vidObj = VideoWriter([output_path],'Uncompressed AVI');
    vidObj.FrameRate = frame_rate;
    open(vidObj)

    %fig = figure('rend', 'painters','pos',[100 100 600 600]);
    
    tiffObj = Tiff(tiff_stack_path,'r');
    
    for it = 2:tiff_indices((1)) %skipping 1 b/c start at first frame
        tiffObj.nextDirectory;
    end

    for it = 1:length(tiff_indices)
        
        fig = figure('rend', 'painters','pos',[100 100 600 510]);

        ax1 = axes('Position',[0 0 1 1]);
        
        
        if ~tiffObj.lastDirectory
        tiffObj.currentDirectory
        
        img = double(tiffObj.read());
        img = flip(img,1);
        img = imrotate(img,rotation_angle);
        img = img(y0_crop:y1_crop,x0_crop:x1_crop );
        imshow(img/2^bit_depth);
        hold on
        rectangle('Position',[10 1530 260 25],'FaceColor',not_white,'EdgeColor',not_white);
        text(40,1585, '1 \mum' ,'FontSize',20,'Color',not_white);
        
        time = it/frames_per_second;
        min = num2str(floor(time/60));
        sec = num2str(floor(mod(time,60)));
        if(length(sec) == 1)
           sec = ['0' sec]; 
        end
        time_str = [min ':' sec];
        text(40,1475,time_str, 'FontSize',20,'Color',not_white);
        
        ax3 = axes('Position',[0.63 0.15 0.34 0.25]);
        p = plot(curve(C(1:it),1),curve(C(1:it),2),'Color', not_white, 'LineWidth',4);
        ax3.XLim = [0 max(curve(1:C(end),1))];
        ax3.YLim = [0 max(curve(1:C(end),2))];
        xlabel('Displacement (nm)');
        ylabel('Force (\muN)');
        set(gca,'Color','none');
        set(gca,'XColor',not_white);
        set(gca,'YColor',not_white);
        set(gca,'ZColor',not_white);
        set(gca,'FontSize',20);
        set(gca,'LineWidth',1); %width of axis lines
        box off

        drawnow;
        print('cur','-djpeg','-r150')
    
        writeVideo(vidObj,imread('cur.jpg'));
        %delete(p);
        
        tiffObj.nextDirectory;
        close all;
        end
    end
    close(vidObj)
    
end

