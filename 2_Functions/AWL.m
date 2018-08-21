function [shell_id] = AWL(adj,gid)
%Calculates shell ids
%Inputs: adj and center grain ids
%Output: shell ids
    a = ismember(adj,gid);
    a = a(:,1) == 1 | a(:,2) == 1;
    shell_id = adj(a,:);
    shell_id(shell_id == gid) = [];
end
