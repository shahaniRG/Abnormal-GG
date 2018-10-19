function [gb_voxel] = gb_calc(gid_map,i,j)
%Calculate number of voxels for grain boundary
%Input : grain id map and grain id numbers for adjacent grains
%Output : number of voxels for the grain boundary

%Focus on grains i & j
    gidLocal = double(gid_map);
    gidLocal_j = gidLocal;
    gidLocal_ij = gidLocal;
    gidLocal(gidLocal ~= i) = 0;
    gidLocal_j(gidLocal_j ~= j) = 0;
    gidLocal_ij(gidLocal_ij ~= i & gidLocal_ij ~= j) = 0;

%Obtain the perimeter
    perim_i = bwperim(gidLocal);
    perim_j = bwperim(gidLocal_j);
    perim_ij = bwperim(gidLocal_ij);

%Add up grain boundary voxels
    gb = perim_i + perim_j - perim_ij;
    gb_voxel = sum(gb(:));
end

