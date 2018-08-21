function [to_sum] = AWLmq(adj,gid,numNeighbor,AWL_i,mr_thn_1)
%Obtains the total number of shell neighbors for the jth shell (aka edges)
%Input: adjacency matrix (adj), center grain or shell grain id (gid),
%       number of Neighbors list for each grain (numNeighbor),
%       the jth shell (AWL_i), and put empty for the last ([])
numNeighbor_list = numNeighbor(:,2);
numNeighbor_id = numNeighbor(:,1);
    if AWL_i < 1
        error('AWL_i must be equal to or greater than 1')
    elseif AWL_i == 1 && isempty(mr_thn_1)
        to_sum = zeros(length(gid),1);
        n = 0;
        for i = gid'
            n = n + 1;
            gid2 = AWL(adj, i);
            b = ismember(numNeighbor_id,gid2);
            to_sum(n) = sum(numNeighbor_list(b));
        end
    elseif AWL_i > 1 && isempty(mr_thn_1)
        AWL_i = AWL_i - 1;
        to_sum = zeros(length(gid),1);
        n = 0;
        for i = gid'
            n = n + 1;
            gid2 = AWL(adj,i);
            to_sum2 = AWLmq(adj,gid2',numNeighbor,AWL_i,i);
            to_sum(n) = sum(to_sum2);
        end
    elseif AWL_i == 1 && ~isempty(mr_thn_1)
        to_sum = zeros(length(gid),1);
        n = 0;
        for i = gid'
            n = n + 1;
            gid2 = AWL(adj, i);
            gid2(ismember(gid2,gid)|(gid2 == i)) = [];
            b = ismember(numNeighbor_id,gid2);
            to_sum(n) = sum(numNeighbor_list(b));
        end
    elseif AWL_i > 1 && ~isempty(mr_thn_1)
        AWL_i = AWL_i - 1;
        to_sum = zeros(length(gid),1);
        n = 0;
        for i = gid'
            n = n + 1;
            gid2 = AWL(adj,i);
            gid2(ismember(gid2,gid)|(gid2 == mr_thn_1)) = [];
            to_sum2 = AWLmq(adj,gid2',numNeighbor,AWL_i,i);
            to_sum(n) = sum(to_sum2);
        end 
    end
end