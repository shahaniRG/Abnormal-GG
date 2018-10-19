%Calculate jth Shell and Neighbors of jth Shell
%Input adj, unique_gid, numNeighbor
    Mqn_1 = AWLmq(adj,unique_gid,numNeighbor,1,[]);
    qn_1 = AWLq(adj,unique_gid,numNeighbor,1,[],[]);
    Mqn_2 = AWLmq(adj,unique_gid,numNeighbor,2,[]);
    qn_2 = AWLq(adj,unique_gid,numNeighbor,2,[],[]);
    Mqn_3 = AWLmq(adj,unique_gid,numNeighbor,3,[]);
    qn_3 = AWLq(adj,unique_gid,numNeighbor,3,[],[]);
%Unique shell neighbor
            [Mqn_avg_1, ucgn_1] = avg_sn(Mqn_1, qn_1);
            [Mqn_avg_2, ucgn_2] = avg_sn(Mqn_2, qn_2);
            [Mqn_avg_3, ucgn_3] = avg_sn(Mqn_3, qn_3);
%Create Scatter Plot
    scatter(ucgn_1,Mqn_avg_1,'b','x')
    %hold on
%     scatter(ucgn_2,Mqn_avg_2,'r')
%     hold on
%     scatter(ucgn_3,Mqn_avg_3,'g','+')
%     set(gca,'xscale','log','yscale','log')
    xlabel('q(n)','fontsize',15)
    ylabel('M(n)*q(n)','fontsize',15)
    legend({'1st Shell','2nd Shell','3rd Shell'},'fontsize',15,'location','northeastoutside')