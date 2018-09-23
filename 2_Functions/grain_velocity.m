function [gid_match,numNeighbor1,numNeighbor2] = grain_velocity(gid_map1,gid_map2,rodV1,rodV2,comp1,comp2,voxel,dt)
%grain_velocity calculates the grain velocities between the two time periods
%   Functions needed: gidMap_123, gid_rodV
%   Input: gid_map1, gid_map2, rodV1, rodV2, voxel, dt(in minutes)
%   Output: gid_match

[gid_map1, Vol1, numNeighbor1, numElement1, unique_gid1] = gidMap_123(gid_map1, [],voxel);
[gid_map2, Vol2, numNeighbor2, ~, unique_gid2] = gidMap_123(gid_map2, [],voxel);

[RodV1, coords1, ~] = gid_rodV(rodV1, unique_gid1, gid_map1, comp1);
[RodV2, coords2, ~] = gid_rodV(rodV2, unique_gid2, gid_map2, comp2);

cs = crystalSymmetry('cubic');
gid_match = zeros(length(unique_gid1),3);
gid_match(:,1) = unique_gid1;
c1 = 0.6;
c2 = 0.4;
dt = dt*60;
unique_gid2_1 = [[1:length(unique_gid2)]', unique_gid2];

for i = 1:length(unique_gid1)
    coord_dist = sqrt((coords2(:,1) - coords1(i,1)).^2 ...
        + (coords2(:,2) - coords1(i,2)).^2 ...
        + (coords2(:,3) - coords1(i,3)).^2);
    dia = round(sqrt(numElement1(i,2)));
    cgid_list = unique_gid2_1(coord_dist <= 2.5*dia,:);
    coord_dist(coord_dist > 2.5*dia) = [];
    misori_list = zeros(size(cgid_list,2),1);
    n = 0;
    for j = cgid_list(:,1)'
        n = n + 1;
        q1 = rodrigues2quat(vector3d(RodV1(i,:)));
        o1 = orientation(q1,cs);
        q2 = rodrigues2quat(vector3d(RodV2(j,:)));
        o2 = orientation(q2,cs);
        misori_list(n) = angle(o1,o2)/degree;
    end
    ci_list = c1.*(misori_list./max(misori_list)) + c2.*(coord_dist./max(coord_dist));
    r = find(ci_list == min(ci_list));
    if min(ci_list) < 1
        gid_match(i,2) = cgid_list(r(1),2);
        gid_match(i,3) = (Vol2(unique_gid2_1(:,1) == cgid_list(r(1),1)) - Vol1(i))/dt;
    else
        gid_match(i,3) = -Vol1(i)/dt;
    end
end

