function [gid_map, Vol, numNeighbor, numElement, unique_gid] = h5CU_V_N(h5file,ming_thresh)
%This function keeps the exterior grains of the DCT image
%It returns the volume, number of Neighbors, number of Elements, and the
%unique_gid
%   Input: h5file, minimum threshold of grain size
%   Output: gid_map, Vol, numNeighbor, numElement, unique_gid
    voxel_size = h5read(h5file,'/LabDCT/Spacing').*1000;
    gid_map = h5read(h5file,'/LabDCT/Data/GrainId');
%Clean Up
    %Remove grains that have less than min grain voxel
        gid_mask = gid_map;
        gid_mask(gid_map == 0) = [];
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
        
%Volume per Grain
    %Remove grains that have less than min grain voxel & not in unique_gid
        numElement(numElement(:,2) < ming_thresh,:) = [];
        numElement(~ismember(numElement(:,1),unique_gid),:) = [];
    %Calculate volume
        Vol = numElement(:,2)*voxel_size(1)*voxel_size(2)*voxel_size(3);

%Number of Neighbors per Grain    
    %Sum all neighbors of each grain
        numNeighbor = accumarray(adj(:),1);
    %Correspond grain ID to number of neighbors
        numNeighbor = [[1:length(numNeighbor)]',numNeighbor];
    %Remove 
        numNeighbor(numNeighbor(:,2) == 0,:) = [];
end

