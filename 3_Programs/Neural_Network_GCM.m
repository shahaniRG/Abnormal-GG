[gid_map, adj, numElement, unique_gid] = h5CU('Al-Cu_400.h5',10);
[~,coords] = gid_rodV('Al-Cu_400.h5', unique_gid, gid_map);

