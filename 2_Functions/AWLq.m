function [qn,gidfinal,gid_back] = AWLq(adj,gid,numNeighbor,AWL_i,gidfinal,gid_back)
%Obtains the total number of shell grains for the jth shell
%Input: adjacency matrix (adj), center grain or shell grain id (gid),
%       number of Neighbors list for each grain (numNeighbor),
%       the jth shell (AWL_i), and put empty for the last two ([])
    if AWL_i < 1
        error('AWL_i must be equal to or greater than 1')
    elseif AWL_i == 1 && isempty(gid_back)
        qn = numNeighbor(:,2);
        gid_back = [];
        gidfinal = [];
    elseif AWL_i > 1 && isempty(gid_back)
        AWL_i = AWL_i - 1;
        qn = zeros(length(gid),1);
        n = 0;
        for i = gid'
            n = n + 1;
            gid2 = AWL(adj,i);
            [~,gidfinal,gidback]= AWLq(adj,gid2',numNeighbor,AWL_i,[],gid);
            gidfinal(ismember(gidfinal,gidback)) = [];
            qn(n) = length(unique(gidfinal));
        end
    elseif AWL_i == 1 && ~isempty(gid_back)
        for i = gid'
            gid2 = AWL(adj, i);
            gidfinal = [gidfinal,gid2];
            qn = [];
        end
        gid_back = gid;
    elseif AWL_i > 1 && ~isempty(gid_back)
        AWL_i = AWL_i - 1;
        n = 0;
        for i = gid'
            n = n + 1;
            gid2 = AWL(adj,i);
            gid_back = [gid_back; gid];
            qn = [];
            [~, gidfinal,gid_back] = AWLq(adj,gid2',numNeighbor,AWL_i,[],gid_back);
        end

    end
end