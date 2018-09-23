# Abnormal-GG deals with data processing of raw data from ACT/DCT scans from the Zeiss Xradia Versa 520 3D X-ray Microscopy abnormal grain growth experiments
# It is organized by 3 folders: 2) Functions, 3) Programs, 4) Output
  # 2) Functions
    # align_gid_map => input two 3D gid maps, output a 3D gid map that is aligned both in center and rotation to the other (need to locate a straight edge)
    # avg_sn => input number of neighbors for each grain & total number of shell grain neighbors for each grain, output avg shell grain neighbor for each unique number of shell neighbors
    # gidMap_123 => input 3D gid map & minimum voxel size, output cleaned up gid map without exterior grains
    # gidMap_123_ext => input 3D gid map & minimum voxel size, output cleaned up gid map with exterior grains
    # gid_rodV => input rod vec & unique gid & 3D gid map, output rod vec & center of mass coord for each grain
    # grain_velocity => input two 3D gid map with rod vec & comp & voxel limit & time change, output grain match & velocity
    # histcn => input number of bins & bin widths & an array, output weighted histogram
    # imRAG => input 3D gid map, output adjacency matrix (grains that are neighbors)
    # imshow3D => input 3D gid map, output visual slices of gid map
    # rot_gid_map => input degrees of rotation and 3D gid map, output of specified rotation degrees
    # str_edge => input gid map slice, output coordinates of the straightest edge in gid map slice
  # 3) Programs
    # Al_Cu_1_2_3 => (standalone program) calculates volume for each grain, number of neighbors, misorienation. Must use Al_Cu_Clean_up first
    # Al_Cu_Clean_up => (standalone program) cleans up the 3D gid map, you can edit whether you want interior or exterior grains
    # Dist_of_AlCu => creates graphs of distribution of grain size & neighbors, weighted histogram of neighbor based on grain size & misorientation based on grain boundary voxels
    # Grain_Velocity => (standalone program) Calculates grain velocity between two DCT images (need to be edited for specific data)
    # Grain_Velocity_Check => Takes in a gid map and alters it, then it tries to match grains from the original to the altered (this tests to see if the functions work for the specific gid map)
    # Stat_of_Grain_Match => Once you have gid_match and numElement, it creates a graph to see the pie chart for matched, unmatched, and mismatched vs the ideal. Gives the match rate
  # 4) Output
    # Output always changes
