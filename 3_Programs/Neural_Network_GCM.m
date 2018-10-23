[gid_map, adj, numElement, unique_gid] = h5CU('Al-Cu_400.h5',10);
[RodV,coords] = gid_rodV('Al-Cu_400.h5', unique_gid, gid_map);
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
mx = max(misori); %red is close to max, blue is close to 0

hold all
for i = 1:size(adj,1)
    line = [coords(adj(i,2),:); coords(adj(i,1),:)];
    colorid = [(misori(i)/mx) 0 (1-misori(i)/mx)];
    plot3(line(:,1),line(:,2),line(:,3),'Color',colorid)
end