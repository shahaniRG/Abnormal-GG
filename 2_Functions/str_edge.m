function [xy] = str_edge(gid_map_s)
%str_edge locates the straightest edge in the gid_map slice and returns the
%center point
%Input: gid_map_s
%Output: xy

    %Get boundary coordinates
        boundaries = bwboundaries(gid_map_s,'noholes');
        xy_list = unique(boundaries{1},'rows','stable');

    %Find maximum repeating consecutive coordinates for x and y
        px = find([1,(diff(xy_list(:,1))~=0)',1]);
        px = max(diff(px));
        py = find([1,(diff(xy_list(:,2))~=0)',1]);
        py = max(diff(py));
    
    %Determine range of curvature fitting
        halfWidth = max([px py]);
        wsize = halfWidth*2;
        xy_len = length(xy_list);
        xyc_len = xy_len + wsize;
    
    %Create a list of coordinates that represents a continuous boundary
        xyc_list = zeros(xy_len+wsize,2);
        xyc_list(1:halfWidth,:) = xy_list((xy_len-halfWidth+1):xy_len,:);
        xyc_list((xyc_len-halfWidth+1):xyc_len,:) = xy_list(1:halfWidth,:);
        xyc_list((halfWidth+1):(xyc_len-halfWidth),:) = xy_list;

    %Find the coordinates of the straight edge
        reg = zeros(length(xy_list),1);
        k = 0;
        for i = (halfWidth + 1):(length(xyc_list)-halfWidth)
            k = k+1;
            pXY = xyc_list((i-halfWidth):(i+halfWidth-1),:);
            x = pXY(:,1); y = pXY(:,2);
            mdl = fitlm(x, y);
            reg(k) = mdl.Rsquared.Adjusted;
        end
        xy = xy_list((reg == max(reg)),:);
end