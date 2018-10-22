function [gid_map,adj,numElement,unique_gid] = h5CUrE(h5file,ming_thresh)
%Function to remove unwanted grains (exterior and min threshold)
%Input: h5file from 3D XRD, minimum threshold for grain size
%Output: gid_map, adj, numElement, unique_gid

gid_map = h5read(h5file,'/LabDCT/Data/GrainId');
    %Remove grains that touch cylinder sides
        gid_map = gid_map + 1;
        adjx = imRAG(gid_map);
        a = adjx == 1;
        a = a(:,1) == 1 | a(:,2) == 1;
        ext_gid1 = adjx(a);
        gid_map = gid_map - 1;
        gid_map(ismember(gid_map, ext_gid1 - 1)) = 0;
    %Remove grains that touch top and bottom face
        z_faces = gid_map(:,:,[1 end]);
        z_faces(z_faces == 0) = [];
        ext_gid2 = unique(z_faces);
        gid_map(ismember(gid_map,ext_gid2)) = 0;
    %Remove grains that have less than min grain voxel
        gid_mask = gid_map;
        gid_mask(gid_mask == 0) = [];
        numElement = accumarray(gid_mask(:),1);
        numElement_in = [1:length(numElement)]';
        numElement = [numElement_in, numElement];
        numElement_in(numElement(:,2) >= ming_thresh) = [];
        gid_map(ismember(gid_map,numElement_in)) = 0;
%Adjacent Grains
    adj = imRAG(gid_map);
    adj((adj(:,1) > adj(:,2)),:) = [];
%Find all unique grains
    unique_gid = unique(adj);
end

