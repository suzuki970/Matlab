function [ y rejctNum] = rejectBlink_PCA( y )

%% calcurating average and standard deviation
ave = mean(y,1);
stdVal = std(y,[],1);
stdVal = stdVal.^2;

%% PCA analysis
[coeff,score,latent]=pca(double(y));
stdX = std(score(:,1),[],1);
stdY = std(score(:,2),[],1);

% %% plotting first and second CP
figure;

averageX = mean(score(:,1));
averageY = mean(score(:,2));
stdX = std(score(:,1),[],1);
stdY = std(score(:,2),[],1);

% ellipsoid(0,0,0,stdX*3,stdY*3,0,50);hold on
plot(score(:,1),score(:,2),'.','MarkerSize',10);hold on
title(['Transformed data']);
xlabel('PC1');
ylabel('PC2');

viscircles([averageX averageY],stdX*2)
set(gca,'FontName','Times New Roman','FontSize',14);
axis equal;
box on;

%% caluclation Euclidean distance from the center of whole value
rejctNum = find(abs(score(:,1)) > (stdX*2));
rejctNum = [rejctNum; find(abs(score(:,2)) > (stdY*2))];
rejctNum = unique(rejctNum);


