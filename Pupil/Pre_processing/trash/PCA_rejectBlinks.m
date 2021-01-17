clear all;
close all;

%% data loading
load('allPupilData.mat')

% all pupil data put into y
y = [];
conditionNum = [];
subjectNum =[];
taskNum =[];

for iSub  = 1 : size(allPupilData,1)
    y = [y; allPupilData{iSub,1}.PLR];
    conditionNum = [conditionNum; allPupilData{iSub,1}.condition'];
    subjectNum = [subjectNum;iSub*ones(size(allPupilData{iSub,1}.PLR,1),1)];
end

newY = y;

%% calcurating average and standard deviation
ave = mean(newY,1);
stdVal = std(newY,[],1);
stdVal = stdVal.^2;

%% plotting original pupil data
% figure;
% plot(x,newY,'-'); hold on;
% xlabel('Time');
% ylabel('Pupil diameter(mm)');
% set(gca,'FontName','Times New Roman','FontSize',14);
% title(['Original pupil data']);
% xlim([startTime endTime]);
% ylim([-4 6]);
%
% figure;
% plot(x,gradient(newY),'-'); hold on;
% xlabel('Time');

%% PCA analysis
[coeff,score,latent]=pca(double(newY));

%% plotting first and second CP
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

viscircles([averageX averageY],stdX*3)
set(gca,'FontName','Times New Roman','FontSize',14);
axis equal;
box on;

%% caluclation Euclidean distance from the center of whole value
ind = find(abs(score(:,1)) > (stdX*3));
ind = [ind; find(abs(score(:,2)) > (stdY*3))];
ind = unique(ind);

%% plotting the transformed data
% figure;

reconst=score*coeff';
reconst=reconst+repmat(ave,size(reconst,1),1);
%
% plot(x,(reconst(ind,:)));
% xlabel('Time');
% ylabel('Pupil diameter(mm)');
% xlim([startTime endTime]);
% ylim([-4 6]);
% title(['Inverse transformed data']);
% set(gca,'FontName','Times New Roman','FontSize',14);

% reconstY =reconst(ind,:);
% conditionNum=conditionNum(ind,:);
% subjectNum=subjectNum(ind,:);

reconst(ind,:) =[];
conditionNum(ind,:)=[];
subjectNum(ind,:)=[];
reconstY=reconst;

% figure;
% plot(x,gradient(reconstY),'-'); hold on;
% xlabel('Time');

% FX = gradient(reconstY);
% rejctNum = [];
% for j = 1:size(FX,1)
%     if ~isempty( find(abs(FX(j,50:end)) > 0.05))
%         rejctNum = [rejctNum;j];
%     end
% end
%  reconstY(rejctNum,:)=[];
%  conditionNum(rejctNum,:)=[];
%  subjectNum(rejctNum,:)=[];

%% plotting the transformed data classified by CP
% varRatio = 0;
% figure;
% for i = 1:5
%     subplot(1,5,i)
%     % calculation of cumulative contribution ratio
%     varRatio = varRatio + latent(i)/sum(latent);
%
%     % plotting data
%     reconst=score(:,1:i)*coeff(:,1:i)';
%     reconst=reconst+repmat(ave,size(reconst,1),1);
%     %     reconst=reconst.*repmat(stdVal,size(reconst,1),1);
%
%     plot(x,reconst(ind,:));hold on
%
%     title(['numOfCP=' num2str(i) ' (' num2str(varRatio) ')']);
%     xlabel('Time');
%     ylabel('Pupil diameter(mm)');
%     xlim([startTime endTime]);
%     ylim([-2 2])
%     set(gca,'FontName','Times New Roman','FontSize',14);
%
% end

for iSub = 1:size(allPupilData,1)
    ind = find(subjectNum == iSub);
    newAllPupilData{iSub,1}.PLR = reconstY(ind,:);
    newAllPupilData{iSub,1}.condition = conditionNum(ind);
end

allPupilData = newAllPupilData;
% save('colorGlareInterpPCA','allPupilData')