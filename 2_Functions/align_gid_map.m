function [gid_map2] = align_gid_map(gid_map2,gid_map1)
%align_gid_map compares two gid maps, where gid_map2 aligns to gid_map1
%   Input: gid_map1, gid_map2, str_thresh
%   Output: gid_map2
%   Note: It is important to not have cleaned up both gid_maps beforehand

%Get sizes of gid maps
    size_gm1 = size(gid_map1);
    size_gm2 = size(gid_map2);

%Center gid_map2 on gid_map1
    %Locate center of gid maps and radius of gid_map2
        gid_mapt1 = gid_map1(:,:,round(size_gm1(3)/2));
        [c1, ~] = imfindcircles(double(gid_mapt1),[150 225],'ObjectPolarity',...
            'bright','Sensitivity',0.99);
        c1 = round(c1(1,:));
        gid_mapt2 = gid_map2(:,:,round(size_gm2(3)/2));
        [c2, r2] = imfindcircles(double(gid_mapt2),[150 225],'ObjectPolarity',...
            'bright','Sensitivity',0.99);
        c2 = round(c2(1,:));
    %Increase or decrease estimated radius size
        if c1(1) - r2 <= 0 || c1(2) - r2 <= 0 || c2(1) - r2 <= 0 || c2(2) - r2 <=0
            r2 = (round(r2(1)) - 10);
        else
            r2 = (round(r2(1)) + 10);
        end
    %Match gid_map2 size to gid_map1 for all slices
        gid_map2_1 = zeros(size_gm1(1),size_gm1(2),size_gm2(3));
        for i = 1:size_gm2(3)
            gid_map2_1((c1(2) - r2):(c1(2) + r2),...
                (c1(1) - r2):(c1(1) + r2),i) = gid_map2(...
                (c2(2) - r2):(c2(2) + r2), ...
                (c2(1) - r2):(c2(1) + r2),i);
        end
        gid_map2 = gid_map2_1;
    
%Determine angle alignment
    %Get straight edge coordinates
        xy1 = str_edge(gid_mapt1);
        xy2 = str_edge(gid_mapt2);
    %Calculate for angle between two coordinates
        dg = round(atan2d(xy2(1)*xy1(2)-xy1(1)*xy2(2),dot(xy2,xy1)));

%Rotate gid_map2 to match gid_map1
    for i = 1:size_gm2(3)
        b = imrotate(gid_map2(:,:,i),dg);
        w = size(b,1);
        l = size(b,2);
        if mod(w,2) == 0
            gid_map2(:,:,i) = b(((w/2) - 214):((w/2) + 214),...
                ((l/2) - 214):((l/2) + 214));
        else
            w = w - 1;
            l = w;
            gid_map2(:,:,i) = b(((w/2) - 214):((w/2) + 214),...
                ((l/2) - 214):((l/2) + 214));
        end
    end

end