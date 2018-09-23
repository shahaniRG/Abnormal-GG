gid_map1 = h5read('UMich_AlCu_GG.h5','/LabDCT/Data/GrainId');
gid_map2 = h5read('UMich_AlCu_GG_1.h5','/LabDCT/Data/GrainId');
gid_map3 = h5read('UMich_AlCu_GG3.h5','/LabDCT/Data/GrainId');
voxel_size1 = h5read('UMich_AlCu_GG.h5','/LabDCT/Spacing').*1000;
voxel_size2 = h5read('UMich_AlCu_GG_1.h5','/LabDCT/Spacing').*1000;
voxel_size3 = h5read('UMich_AlCu_GG3.h5','/LabDCT/Spacing').*1000;

[~, Vol1, numNeighbor1, ~, ~] = gidMap_123(gid_map1,[],voxel_size1);
[~, Vol1e, numNeighbor1e, ~, ~] = gidMap_123_ext(gid_map1,[],voxel_size1);

[~, Vol2, numNeighbor2, ~, ~] = gidMap_123(gid_map2,[],voxel_size2);
[~, Vol2e, numNeighbor2e, ~, ~] = gidMap_123_ext(gid_map2,[],voxel_size2);

[~, Vol3, numNeighbor3, ~, ~] = gidMap_123(gid_map3,[],voxel_size3);
[~, Vol3e, numNeighbor3e, ~, ~] = gidMap_123_ext(gid_map3,[],voxel_size3);

clear voxel_size1 voxel_size2 voxel_size3
%%
figure(1)
subplot(1,2,1)
meanvolume = [mean(Vol1) mean(Vol1e);  mean(Vol2) mean(Vol2e);...
    mean(Vol3) mean(Vol3e);];
bar(meanvolume)
title('Average Grain Volume Comparison','fontsize',20)
set(gca,'xticklabel',{'T0 (Jun)','T0 (Nancy)','T2 (Jun)'},'fontsize',15);
ylabel('Grain Volume (um^3)')
legend('w/o Ext', 'w/ Ext','Location','eastoutside')
subplot(1,2,2)
maxm = [max(Vol1) max(Vol1e);  max(Vol2) max(Vol2e);...
    max(Vol3) max(Vol3e);];
bar(maxm)
title('Grain Volume Maximum Comparison','fontsize',20)
set(gca,'xticklabel',{'T0 (Jun)','T0 (Nancy)','T2 (Jun)'},'fontsize',15);
ay = gca;
ay.YRuler.Exponent = 0;
ylabel('Grain Volume (um^3)')
legend('w/o Ext', 'w/ Ext','Location','eastoutside')
%%
% Weighted Histogram of Neighbor based on Grain Size
figure(2)
    x_axis = linspace(0, 200, 20);
    title('Neighbor Statistics weighted by Grain Size','fontsize',15)
    subplot(1,3,1)
    [h1, ~, ~, ~] = histcn(numNeighbor1(:,2), x_axis, ...
        'AccumData',Vol1/sum(Vol1));
    h1(20,1) = 0;
    [h1e, ~, ~, ~] = histcn(numNeighbor1e(:,2), x_axis, ...
        'AccumData',Vol1e/sum(Vol1e));
    b1 = bar(x_axis,[h1,h1e]);
    ylabel('Percent of Grain Volume','fontsize',12)
    xlabel('Number of Neighbors','fontsize',11)
    ylim([0 0.4])

    subplot(1,3,2)
    [h2, ~, ~, ~] = histcn(numNeighbor2(:,2), x_axis, ...
        'AccumData',Vol2/sum(Vol2));
    [h2e, ~, ~, ~] = histcn(numNeighbor2e(:,2), x_axis, ...
        'AccumData',Vol2e/sum(Vol2e));
    b2 = bar(x_axis(1:end-1),[h2,h2e]);
    xlabel('Number of Neighbors','fontsize',11)
    ylim([0 0.4])
    
    subplot(1,3,3)
    [h3, ~, ~, ~] = histcn(numNeighbor3(:,2), x_axis, ...
        'AccumData',Vol3/sum(Vol3));
    [h3e, ~, ~, ~] = histcn(numNeighbor2e(:,2), x_axis, ...
        'AccumData',Vol2e/sum(Vol2e));
    b3 = bar(x_axis(1:end-1),[h3,h3e]);
    xlabel('Number of Neighbors','fontsize',11)
    ylim([0 0.4])
    legend('w/o Ext', 'w/ Ext','Location','northeast')