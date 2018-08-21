% Distribution of Grain Size
    figure
    subplot(3,2,1)
    h1 = histogram(Vol,50);
    title('Volume/Voxel Statistics','fontsize',15)
    ylabel('# Grains','fontsize',12)
    set(gca, 'YScale', 'log') %,'XScale','log')
    volume = gca;
    sqz = 0.12;
    set(volume, 'Position', get(volume, 'Position') + [0 sqz 0 -sqz ]);
    voxel = axes('Position', get(volume, 'Position') .* [1 1 1 0.001] - [0 0.10 0 0],'Color','none');
    volume.YLim = [0 10^5];
    scale_factor = 1/27; %Set scale for 2nd X-axis

    %Xaxis for Volume (um^3)
        volume.XAxis.Exponent = 0; 
        volume.XAxis.TickLabelFormat = '%6.0f'; 
        volume.XLim = [0 1700000];
        xlabel(volume,'Volume (um^3)','fontsize',12)
    %Xaxis for Voxel
        voxel.XAxis.Exponent = 0; 
        voxel.XAxis.TickLabelFormat = '%4.f';
        %voxel.XScale = 'log';
        voxel.XLim = volume.XLim.*scale_factor;
        xlabel(voxel,'Voxel','fontsize',12)
    %Table
        ha = subplot(3,2,3)
        names = {'Mean','Median','SD','Max'};
        names2 = {'Voxel','Vol'};
        Mean = mean(numElement(:,2));
        Mean2 = mean(Vol);
        Median = median(numElement(:,2));
        Median2 = median(Vol);
        SD = std(numElement(:,2));
        SD2 = std(Vol);
        Max = max(numElement(:,2));
        Max2 = max(Vol);
        all = [Mean,Median,SD,Max; Mean2,Median2,SD2,Max2];
        pos = get(ha,'Position');
        un = get(ha,'Units');
        delete(ha)
        t = uitable('Data',all,'ColumnName',names,'RowName',names2,...
            'Units',un,'Position',pos);
%Distribution of Neighbors
    subplot(3,2,2)
    h2 = histogram(numNeighbor(:,2),200);
    xlabel('Number of Neighbors','fontsize',12)
    ylabel('# Grains','fontsize',12)
    title('Neighbor Statistics','fontsize',15)
    set(gca, 'YScale', 'log')
    neighbors = gca;
    neighbors.YAxis.Exponent = 0;
    neighbors.YAxis.TickLabelFormat = '%6.0f';
    %neighbors.XLim = [0 50];
    ha = subplot(3,2,4)
    names = {'Mean','Median','SD','Max'};
    Mean = mean(numNeighbor(:,2));
    Median = median(numNeighbor(:,2));
    SD = std(numNeighbor(:,2));
    Max = max(numNeighbor(:,2));
    all = [Mean,Median,SD,Max];
    pos = get(ha,'Position');
    un = get(ha,'Units');
    delete(ha)
    t = uitable('Data',all,'ColumnName',names,'RowName',[],...
        'Units',un,'Position',pos);
% Weighted Histogram of Neighbor based on Grain Size
    subplot(3,2,[5 6])
    x_axis = linspace(0, 200, 30);
    [h3, ~, ~, ~] = histcn(numNeighbor(:,2), x_axis, ...
        'AccumData',Vol);
    b1 = bar(x_axis(1:end-1),h3','green');
    title('Neighbor Statistics weighted by Grain Size','fontsize',15)
    yyaxis left
    ylabel('Grain Volume','fontsize',12)
    yyaxis right
    ylabel('Vol. Fraction of Total Grain Volume', 'FontSize', 11);
    ylim([0 0.2]);
    xlabel('Number of Neighbors','fontsize',11)

%%
%Weighted Histogram of Misorientation based on Grain Boundary Voxels
    figure
    x_axis = linspace(0, 70, 20);
    [h4, ~, ~, ~] = histcn(misori, x_axis, ...
        'AccumData',gb_voxel./sum(gb_voxel));
    b1 = bar(x_axis(1:end-1),h4','red','barwidth',0.2);

    %With Mackenzie Distribution
        cs = crystalSymmetry('cubic');
        %Inputs of Binwidth and Number of Random numbers
            bin = 1;
            rndnum = input('Number of Random Numbers: ');
        %Create Random Euler Matrix    
            orient_rand = zeros(rndnum,1);
            orient_rand(:,1) = 2*pi()*rand(rndnum,1);
            orient_rand(:,2) = pi()*rand(rndnum,1);
            orient_rand(:,3) = 2*pi()*rand(rndnum,1);
        %Pre-Allocate Matrix and k
            misori_2 = zeros(rndnum,1);
            area = ones(rndnum,1);
        %Apply Crystal Symmetry to find rotation angle
            for i = 1:rndnum
                euler = orient_rand(i,:);
                o1 = orientation('Euler',euler, cs);
                o2 = [0,0,0];
                misori_2(i) = angle(o1,o2)/degree;
            end
    hold on   
    [h5, ~, ~, ~] = histcn(misori_2, x_axis, ...
        'AccumData',area./sum(area(:)));
    b2 = bar(x_axis(1:end-1),h5','green','FaceAlpha',0.2);
    
    ylabel('Voxel Fraction of Total Voxels','fontsize',15)
    xlabel('Disorientation (Deg)','fontsize',15)
    legend('Al-Cu','Random Orientation')