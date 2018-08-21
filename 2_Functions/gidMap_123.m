function [gid_map, Vol, numNeighbor, numElement, unique_gid] = gidMap_123(gid_map,grain_size_mini,voxel_size)
%gidMap_cleanUp removes the exterior grains of the DCT image
%It returns the volume, number of Neighbors, number of Elements, and the
%unique_gid
%   Input: gid_map, grain_size_mini
%   Output: gid_map, Vol, numNeighbor, numElement, unique_gid
%   Removes grains that touch cylinder sides
%   Removes grains that touch top and bottom face
%   Removes grains that have less than min grain voxel    
    if isempty(grain_size_mini)
        grain_size_mini = 10;
    end
%Clean Up
    %Remove grains that touch empty space
        gid_map = gid_map + 1;
        adj = imRAG(gid_map);
        a = adj == 1;
        a = a(:,1) == 1 | a(:,2) == 1;
        ext_gid1 = adj(a);
        gid_map = gid_map - 1;
        gid_map(ismember(gid_map, ext_gid1 - 1)) = 0;    
    %Remove grains that touch top and bottom face
        z_faces = gid_map(:,:,[1 end]);
        z_faces(z_faces == 0) = [];
        ext_gid2 = unique(z_faces);
        gid_map(ismember(gid_map, ext_gid2)) = 0;
    %Remove grains that have less than min grain voxel
        gid_mask = gid_map;
        gid_mask(gid_map == 0) = [];
        numElement = accumarray(gid_mask(:),1);
        numElement_in = [1:length(numElement)]';
        numElement = [numElement_in, numElement];
        numElement_in(numElement(:,2) >= grain_size_mini) = [];
        gid_map(ismember(gid_map,numElement_in)) = 0;
    %Adjacent Grains
        adj = imRAG(gid_map);
        adj((adj(:,1) > adj(:,2)),:) = [];
    %Find all unique grains
        unique_gid = unique(adj);
        
%Volume per Grain
    %Remove grains that have less than min grain voxel & not in unique_gid
        numElement(numElement(:,2) < grain_size_mini,:) = [];
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

