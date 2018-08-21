%Statistics of Grain Matching
%Need gid_match and numElement

gmlen = length(gid_match);
mis_mat = sum(gid_match(:,2) ~= 0 & (gid_match(:,1) ~= gid_match(:,2)))/gmlen;
no_mat = sum(gid_match(:,2) == 0)/gmlen;
perc_mat = sum(gid_match(:,1) == gid_match(:,2))/gmlen;

gmlen2 = length(numElement1);
no_mat2 = sum(~ismember(numElement1(:,1),numElement2(:,1)))/gmlen2;
perc_mat2 = sum(ismember(numElement1(:,1),numElement2(:,1)))/gmlen2;

subplot(1,2,1)
X = [no_mat,mis_mat,perc_mat];
p1 = pie(X);
title('Actual','fontsize',15);
labels= {'No match','Mismatch', 'Match'};
legend(labels,'Location','southoutside','Orientation','horizontal');

subplot(1,2,2)
X = [no_mat2, perc_mat2];
p2 = pie(X);
title('Ideal','fontsize',15);
labels= {'No match', 'Match'};
legend(labels,'Location','southoutside','Orientation','horizontal');