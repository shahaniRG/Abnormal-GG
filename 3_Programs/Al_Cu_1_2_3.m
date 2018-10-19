% This script calculates:
%    (1) Volume for each Grain
%    (2) Number of Neighbors for each Grain
%    (3) Misorientation per Adjacent Grain Interface
%    Input is Grain Id Map, Rodrigues Vector, Voxel Size

%Show what .h5 contains
    %h5disp('UMich_AlCu_GG.h5')
%Read in Rod Vector, Voxel Size, and Completeness
        rodV = h5read('Example_1.h5','/LabDCT/Data/Rodrigues');
        voxel_size = h5read('Example_1.h5','/LabDCT/Spacing').*1000;
        comp = double(h5read('Example_1.h5','/LabDCT/Data/Completeness'));

%(1) Volume per Grain
    %Remove grains that have less than min grain voxel & not in unique_gid
        numElement(numElement(:,2) < grain_size_mini,:) = [];
        numElement(~ismember(numElement(:,1),unique_gid),:) = [];
    %Calculate volume
        Vol = numElement(:,2)*voxel_size(1)*voxel_size(2)*voxel_size(3); %Voxel Length is 3 um...
        
%(2) Number of Neighbors per Grain    
    %Sum all neighbors of each grain
        numNeighbor = accumarray(adj(:),1);
    %Correspond grain ID to number of neighbors
        numNeighbor = [[1:length(numNeighbor)]',numNeighbor];
    %Remove 
        numNeighbor(numNeighbor(:,2) == 0,:) = [];
     clear grain_size_mini
%%     
%(3) Misorientation per Adjacent Grain Interface    
    %Calculate rodrigues vector per grain
        fprintf('Calculating Rodrigues Vector...\n')
        coords = zeros(max(unique_gid),3);
        comp_mean = zeros(max(unique_gid),1);
        RodV = coords;
        for i = unique_gid'
            [x,y,z] = ind2sub(size(gid_map),find(gid_map == i));
            coords(i,:) = round(mean([x,y,z])); %get coordinates of the center of mass
            comp_mean(i) = mean(comp(gid_map==i));
            RodV(i,1) = rodV(1,coords(i,1),coords(i,2),coords(i,3));
            RodV(i,2) = rodV(2,coords(i,1),coords(i,2),coords(i,3));
            RodV(i,3) = rodV(3,coords(i,1),coords(i,2),coords(i,3));
        end
        fprintf('Rodrigues Vector Finished\n')
%%
    clear unique_gid

    %Calculate misorientation
        cs = crystalSymmetry('cubic');
        misori = zeros(length(adj),1);
        gb_voxel = misori;
        fprintf('Calculating Misorientation...\n')
        tic
        parfor quickInd = 1:length(adj)
            i = adj(quickInd,1);
            j = adj(quickInd,2); 
            %Misorientation
                q1 = rodrigues2quat(vector3d(RodV(i,:)));
                o1 = orientation(q1, cs);
                q2 = rodrigues2quat(vector3d(RodV(j,:)));
                o2 = orientation(q2, cs);
                misori(quickInd) = angle(o1,o2)/degree;
            %Grain Boundary Voxel Size
                gb_voxel(quickInd) = gb_calc(gid_map,i,j);
        end
        toc
    %Remove zeros
        gb_voxel(misori < 0.1) = [];
        misori(misori < 0.1) = [];
        comp_mean = comp_mean(any(comp_mean,2),:);
        coords = coords(any(coords,2),:);
        RodV = RodV(any(RodV,2),:);
        fprintf('Success\n')