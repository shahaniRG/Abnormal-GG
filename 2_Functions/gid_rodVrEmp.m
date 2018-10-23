function [RodV, coords] = gid_rodVrEmp(h5file, unique_gid, gid_map)
%gid_rodV gives a single rodrigues vector that respresents each grain
%   Input: h5file, unique_gid, gid_map, comp
%   Output: RodV, coords, comp_mean
rodV = h5read(h5file,'/LabDCT/Data/Rodrigues');
coords = zeros(max(unique_gid),3);
RodV = coords;
for i = unique_gid'
    [x,y,z] = ind2sub(size(gid_map),find(gid_map == i));
    coords(i,:) = round(mean([x,y,z])); %get coordinates of the center of mass
    RodV(i,1) = rodV(1,coords(i,1),coords(i,2),coords(i,3));
    RodV(i,2) = rodV(2,coords(i,1),coords(i,2),coords(i,3));
    RodV(i,3) = rodV(3,coords(i,1),coords(i,2),coords(i,3));
end
coords = coords(any(coords,2),:);
RodV = RodV(any(RodV,2),:);
end