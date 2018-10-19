# Abnormal-GG deals with data processing of raw data from ACT/DCT scans from the Zeiss Xradia Versa 520 3D X-ray Microscopy abnormal grain growth experiments
# MTEX is a required Dependency for the code
    download and initialize MTEX (https://mtex-toolbox.github.io, once downloaded type startup_mtex)
# It is organized by 4 folders: 1) Input [Examples] 2) Functions, 3) Programs 4) Misc [Work in Progress]
    Most important functions are listed
  # Hierarchy of Utilization: What order to run programs/func
    1. Al_Cu_Clean_Up
    2. Al_Cu_1_2_3
    3. Dist_of_AlCu
    1-2. gidMap_123, gidMap_123_ext 
    1-3. grain_velocity, Grain_Velocity
    N/A. gid_rodV, imRAG, rot_gid_map, str_edge, gb_calc, avg_sn, align_gid_map
  # 1) Input (Examples)
    Example_1.h5 (Will add later...)
    Note: Utilize h5disp to look at entire .h5 file
  # 2) Functions
    align_gid_map => input two 3D gid maps, output a 3D gid map that is aligned both in center and rotation to the other (need to locate a straight edge)
    avg_sn => input number of neighbors for each grain & total number of shell grain neighbors for each grain, output avg shell grain neighbor for each unique number of shell neighbors
    gidMap_123 => input 3D gid map & minimum voxel size, output cleaned up gid map without exterior grains
    gidMap_123_ext => input 3D gid map & minimum voxel size, output cleaned up gid map with exterior grains
    gid_rodV => input rod vec & unique gid & 3D gid map, output rod vec & center of mass coord for each grain
    grain_velocity => input two 3D gid map with rod vec & comp & voxel limit & time change, output grain match & velocity
    imRAG => input 3D gid map, output adjacency matrix (grains that are neighbors)
    rot_gid_map => input degrees of rotation and 3D gid map, output of specified rotation degrees
    str_edge => input gid map slice, output coordinates of the straightest edge in gid map slice
    gb_calc => input gid map & gid numbers for adjacent grain, output number of voxels for gb (uses bwperim to subtract out gb)
  # 3) Programs
    Al_Cu_1_2_3 => (standalone program) calculates volume for each grain, number of neighbors, misorienation
    Al_Cu_Clean_up => (standalone program) cleans up the 3D gid map, you can edit whether you want interior or exterior grains
    Dist_of_AlCu => creates graphs of distribution of grain size & neighbors, weighted histogram of neighbor based on grain size & misorientation based on grain boundary voxels
    Grain_Velocity => (standalone program) Calculates grain velocity between two DCT images (need to be edited for specific data)
