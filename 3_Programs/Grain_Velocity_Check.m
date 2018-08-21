%Check Grain Velocity Calculation
    %Read in Grain Id Map
        gid_map1 = h5read('UMich_AlCu_GG.h5','/LabDCT/Data/GrainId');
        gid_mask = gid_map1 == 0;
        gid_map22 = gid_map1;
        gid_map2 = zeros(size(gid_map1));
        se = strel('disk',2);
        for i = 1:size(gid_map1,3)
            gid_map2(:,:,i) = imdilate(gid_map1(:,:,i),se,'same');
        end
        gid_map2(gid_mask) = 0;
    %Read in Voxel size
        voxel1 = h5read('UMich_AlCu_GG.h5','/LabDCT/Spacing').*1000;
        voxel2 = voxel1;
    %Clean Up Grain Id    
        [gid_map1, Vol1, numNeighbor1, numElement1, unique_gid1] = gidMap_123(gid_map1,[],voxel1);
        [gid_map2, Vol2, numNeighbor2, numElement2, unique_gid2] = gidMap_123(gid_map2,[],voxel2);
    %Read in Rod Vector and Completeness
        rodV1 = h5read('UMich_AlCu_GG.h5','/LabDCT/Data/Rodrigues');
        rodV2 = rodV1;
        clear i voxel1 voxel2 gid_mask
        
%Orientation
    %Calculate rodrigues vector per grain
        fprintf('Calculating Rodrigues Vector 1...\n')
        [RodV1, coords1] = gid_rodV(rodV1, unique_gid1, gid_map1);
        fprintf('Rodrigues Vector 1 Finished\n')
        coords1 = coords1(any(coords1,2),:);
        RodV1 = RodV1(any(RodV1,2),:);
        
        unique_gid22 = unique(gid_map22);
        unique_gid22(1) = [];
        fprintf('Calculating Rodrigues Vector 1...\n')
        [RodV2, ~] = gid_rodV(rodV2, unique_gid22, gid_map22);
        fprintf('Rodrigues Vector 2 Finished\n')
        coords2 = zeros(max(unique_gid22),3);
        for i = unique_gid2'
            [x,y,z] = ind2sub(size(gid_map2),find(gid_map2 == i));
            coords2(i,:) = round(mean([x,y,z]));
        end
        RodV2(~ismember(unique_gid22,unique_gid2),:) = [];
        coords2(~ismember(unique_gid22,unique_gid2),:) = [];
        
%Grain Matching
    fprintf('Grain Matching Started\n')
    cs = crystalSymmetry('cubic');
    gid_match = zeros(length(unique_gid1),3);
    gid_match(:,1) = unique_gid1;
    dt = 8*60;
    %Find grains in dataset 2 that are 2.5 diameters away
    unique_gid2_1 = [[1:length(unique_gid2)]',unique_gid2];
    for i = 1:length(unique_gid1)
        coord_dist = sqrt((coords2(:,1) - coords1(i,1)).^2 ...
            + (coords2(:,2) - coords1(i,2)).^2 ...
            + (coords2(:,3) - coords1(i,3)).^2);
        dia = round(sqrt(numElement1(i,2))); %not longest diameter but sqrt of the numElements
        cgid_list = unique_gid2((coord_dist <= 3*dia),:);
        coord_dist(coord_dist > 3*dia) = [];
        misori_list = zeros(length(cgid_list),1);
        %Calculate misorientation between selected grain
        n = 0;
        for j = cgid_list(:,1)'
            n = n + 1;
            q1 = rodrigues2quat(vector3d(RodV1(i,:)));
            o1 = orientation(q1, cs);
            q2 = rodrigues2quat(vector3d(RodV2(j,:)));
            o2 = orientation(q2, cs);
            misori_list(n) = angle(o1,o2)/degree;
        end
        r = find(misori_list == min(misori_list));
        if min(misori_list) < 1
            gid_match(i,2) = cgid_list(r(1),2);
            gid_match(i,3) = (Vol2(unique_gid2 == cgid_list(r(1),1)) - Vol1(i))/dt;
        else
            gid_match(i,3) = -Vol1(i)/dt;
        end
    end
    fprintf('Finished')