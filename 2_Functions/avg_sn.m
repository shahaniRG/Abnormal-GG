function [M_q_n_avg, ucgn] = avg_sn(M_q_n,q_n)
%Averages Shell Neighbors for each unique number of shell neighbors
%Input: numNeighbor for center grain, Total num of shell g neighbors for each g, unique g
%Output: Average shell grain neighbor for each unique number of shell neighbors
ucgn = unique(q_n);
M_q_n_avg = zeros(length(ucgn),1);
k = 0;
    for i = ucgn'
        k = k + 1;
        a = ismember(q_n,i);
        shell_ids = M_q_n(a);
        M_q_n_avg(k) = round(mean(shell_ids));
    end
end