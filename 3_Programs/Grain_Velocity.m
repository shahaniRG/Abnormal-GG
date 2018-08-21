%This script calculates grain velocity between two DCT images
%Preface
    %Read in Grain Id Map, rodrigues Vector, comp, and voxel size
        gid_map1 = h5read('UMich_AlCu_GG.h5','/LabDCT/Data/GrainId');
        gid_map2 = h5read('UMich_AlCu_GG3.h5','/LabDCT/Data/GrainId');
        rodV1 = h5read('UMich_AlCu_GG.h5','/LabDCT/Data/Rodrigues');
        rodV2 = h5read('UMich_AlCu_GG2.h5','/LabDCT/Data/Rodrigues');
        voxel1 = h5read('UMich_AlCu_GG.h5','/LabDCT/Spacing').*1000;
        
        size_gm1 = size(gid_map1);
        size_gm2 = size(gid_map2);
    %Time of Anneal(in minutes)
        %dt = 8;
        
    %Clean Up gid maps
        [gid_map1, Vol1, numNeighbor1, numElement1, unique_gid1] = gidMap_123(gid_map1, [],voxel1);
        [gid_map2, Vol2, numNeighbor2, numElement2, unique_gid2] = gidMap_123(gid_map2, [],voxel1);
        %%
        [RodV1, coords1] = gid_rodV(rodV1, unique_gid1, gid_map1);
        [RodV2, coords2] = gid_rodV(rodV2, unique_gid2, gid_map2);
        fprintf('Clean Up Finished\n')
    %Match Coords2 to Coords1 system
        coords2(:,1) = coords2(:,1) + round((size_gm1(1)-size_gm2(1))/2);
        coords2(:,2) = coords2(:,2) + round((size_gm1(2)-size_gm2(2))/2);
        %%
%Calculate Grain Velocity
    fprintf('Started...\n')
    cs = crystalSymmetry('cubic');
    dt = 8*60;
    unique_gid2_1 = [[1:length(unique_gid2)]', unique_gid2];
    gid_match = zeros(length(unique_gid1),4);
    gid_match(:,4) = NaN;
    gid_match(:,1) = unique_gid1;
    dh = size_gm1(3) - size_gm2(3);
    
    for i = 1:length(unique_gid1)
        rad = round((numElement1(i,2).^(1/3))/2) + 5;
        dht = abs(coords2(:,3) - coords1(i,3));
        if coords1(i,3) >= size_gm2(3) || coords1(i,3) <= dh
            cgid_list = unique_gid2_1(dht < 2*rad,:);
        else
            cgid_list = unique_gid2_1(dht < rad,:);
        end
        misori_list = zeros(size(cgid_list,1),1);
        n = 0;
        for j = cgid_list(:,1)'
            n = n + 1;
            q1 = rodrigues2quat(vector3d(RodV1(i,:)));
            o1 = orientation(q1,cs);
            q2 = rodrigues2quat(vector3d(RodV2(j,:)));
            o2 = orientation(q2,cs);
            misori_list(n) = angle(o1,o2)/degree;
        end
            r = find(misori_list == min(misori_list));
        if isempty(misori_list) || min(misori_list) > 1
            gid_match(i,3) = -Vol1(i)/dt;
        elseif min(misori_list) < 1
            gid_match(i,2) = cgid_list(r(1),2);
            gid_match(i,3) = (Vol2(unique_gid2 == cgid_list(r(1),2)) - Vol1(i))/dt;
            xy1 = [coords1(i,1), coords1(i,2)];
            xy2 = [coords2(r(1),1), coords2(r(1),2)];
            gid_match(i,4) = round(atan2d(xy2(1)*xy1(2)-xy1(1)*xy2(2), dot(xy2,xy1)));
        end
    end
    fprintf('Finished\n')