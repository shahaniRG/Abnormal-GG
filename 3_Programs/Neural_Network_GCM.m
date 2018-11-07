[gid_map, adj, numElement, unique_gid] = h5CU('Al35Cu_T5.h5',10);
[RodV,coords] = gid_rodV('Al35Cu_T5.h5', unique_gid, gid_map);
%Calculate misorientation
    cs = crystalSymmetry('cubic');
    misori = zeros(length(adj),1);
    fprintf('Calculating Misorientation...\n')
    tic
    for quickInd = 1:length(adj)
        i = adj(quickInd,1);
        j = adj(quickInd,2); 
        %Misorientation
            q1 = rodrigues2quat(vector3d(RodV(i,:)));
            o1 = orientation(q1, cs);
            q2 = rodrigues2quat(vector3d(RodV(j,:)));
            o2 = orientation(q2, cs);
            misori(quickInd) = angle(o1,o2)/degree;
    end
misori(isnan(misori)) = 0;     
mx = 62.8;
    %red is above 15 degrees and close to max 
    %blue is below 15 degrees and close to 0
    fprintf('Finished Calculating Misorientation\n')
    %%
hold all
for i = 1:size(adj,1)
    line = [coords(adj(i,2),:); coords(adj(i,1),:)];
    if misori(i) > 15
    colorid = [(0.5+0.5*(misori(i)/mx)) 0 0];
    else
    colorid = [0 0 (0.5+0.5*(misori(i)/15))];
    end
    plot3(line(:,1),line(:,2),line(:,3),'Color',colorid)
end
s = numElement(unique_gid);
scatter3(coords(unique_gid,1),coords(unique_gid,2),coords(unique_gid,3),s,'filled')

%colorbar([0 0 1],[1 0 0])