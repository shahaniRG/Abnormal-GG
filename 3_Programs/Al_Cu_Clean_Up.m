%This script cleans up exterior grains

%Data Source
    %Read in Grain Id Map, Rod Vector, Voxel Size, and Completeness
        gid_map = h5read('Example_1.h5','/LabDCT/Data/GrainId');
    %Voxel Size Minimum
        grain_size_mini = 10;
%(0) Preface
    %Grain Id
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
            numElement_in(numElement(:,2) >= grain_size_mini) = [];
            gid_map(ismember(gid_map,numElement_in)) = 0;
    %Adjacent Grains
        adj = imRAG(gid_map);
        adj((adj(:,1) > adj(:,2)),:) = [];
    %Find all unique grains
        unique_gid = unique(adj);

clear x_faces y_faces z_faces xyz_faces numElement_in gid_mask ...
         ext_gid1 ext_gid2 a adjx
     fprintf('Gid_map Cleaned\n')