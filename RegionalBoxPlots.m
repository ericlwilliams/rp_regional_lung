function RegionalBoxPlots
tic; %close all;

%% load MSK/NKI data (outputs from Pt_MSK/NKI,

% Only variables available in these classOutcomeAnalysis objects are:
% CGobj(N).mLymanN
% CGobj(N).mGrp.mLymanN
% CGobj(N).mGrp.mEUD
% CGobj(N).mGrp.mEUD
% CGobj(N).mGrp.mFlgCensor


fn_msk='Z:/elw/MATLAB/regions/meta/MSK_EUD_regional.mat'; % MSK data
fn_nki='Z:/elw/MATLAB/regions/meta/NKI_EUD_regional.mat'; % NKI data

load(fn_msk,'Regions','CGobjs'); 
CGmsk = CGobjs;

load(fn_nki,'CGobjs'); 
CGnki = CGobjs;

CGcomb = CGmsk;
for k = 1:length(CGobjs)
    CGcomb(k) = CGcomb(k).fAddPatient(CGnki(k).mGrp);
end

numreg = length(CGcomb)-2;
n_msk_pts = zeros(1,numreg);
n_nki_pts = zeros(1,numreg);

for j=1:numreg,
    n_msk_pts(j) = length(CGmsk(j).mGrp);
    n_nki_pts(j) = length(CGnki(j).mGrp);
end
%# TEST, make box plot




max_comb_pts = max(n_nki_pts)+max(n_msk_pts);
msk_means = NaN(max_comb_pts,numreg);
nki_means = NaN(max_comb_pts,numreg);
comb_means = NaN(max_comb_pts,numreg);

mLymanN=21;
msk_mean_euds = NaN(max_comb_pts,mLymanN,numreg);
nki_mean_euds = NaN(max_comb_pts,mLymanN,numreg);

region_means = NaN(max_comb_pts,3,numreg);

for k=1:numreg,
    %# MSK
    cur_msk_euds = [CGmsk(k).mGrp.mEUD];
    cur_msk_means = cur_msk_euds(11,:)';
     
    %# expand if necessary
    if (length(cur_msk_means) < max_comb_pts),
        tmp_msk_exp = NaN(max_comb_pts-length(cur_msk_means),1);
        cur_msk_means = vertcat(cur_msk_means,tmp_msk_exp);
    end
    
    msk_means(:,k)=cur_msk_means;
  
    msk_mean_euds(1:length(cur_msk_euds),:,k) = cur_msk_euds';
    
    %# NKI
    cur_nki_euds = [CGnki(k).mGrp.mEUD];
    cur_nki_means = cur_nki_euds(11,:)';
    
    %# expand if necessary
    if (length(cur_nki_means) < max_comb_pts),
        tmp_nki_exp = NaN(max_comb_pts-length(cur_nki_means),1);
        cur_nki_means = vertcat(cur_nki_means,tmp_nki_exp);
    end
    
    nki_means(:,k)=cur_nki_means;

    nki_mean_euds(1:length(cur_nki_euds),:,k) = cur_nki_euds';
    
    %# COMB
    cur_comb_euds = [CGcomb(k).mGrp.mEUD];
    cur_comb_means = cur_comb_euds(11,:)';
    
    %# expand if necessary
    if (length(cur_comb_means) < max_comb_pts),
        tmp_comb_exp = NaN(max_comb_pts-length(cur_comb_means),1);
        cur_comb_means = vertcat(cur_comb_means,tmp_comb_exp);
    end    
    comb_means(:,k)=cur_comb_means;

    %region_means(:,:,1) = msk_means;
end

%Regions = {'Whole'    'Ipsi'    'Contra'    'Superior'    'Inferior'
%'Left'  'Right'}';
Regions = {'Whole'    'Ipsi'    'Contra'    'Superior'    'Inferior'};

figure(1);
boxplot(msk_means,'Labels',Regions);
ylim([0 55]);
ylabel('Mean Dose to Lung Structure (Gy)');
title('MSKCC Patients');
hold on;
msk_means_mean = nanmean(msk_means);
plot(msk_means_mean,'*k');


figure(2);
boxplot(nki_means,'Labels',Regions);
ylim([0 55]);
ylabel('Mean Dose to Lung Structure (Gy)');
title('NKI Patients');
hold on;
nki_means_mean = nanmean(nki_means);
plot(nki_means_mean,'*k');


figure(3);
boxplot(comb_means,'Labels',Regions);
ylim([0 55]);
ylabel('Mean Dose to Lung Structure (Gy)');
title('MSKCC+NKI Patients');
hold on;
comb_means_mean = nanmean(comb_means);
plot(comb_means_mean,'*k');

disp(['%%%%%%%%%%%%%%%%%%%%%']);
disp(['Mean doses']);
for n=1:numreg,
    disp([Regions{n}]);
    disp(sprintf('\tMSK: %s (%s - %s)\n\tNKI: %s (%s - %s)\n\tCOMB %s (%s - %s)',...
        num2str(msk_means_mean(n)),...
        num2str(min(msk_means(:,n))),...
        num2str(max(msk_means(:,n))),...
        num2str(nki_means_mean(n)),...
        num2str(min(nki_means(:,n))),...
        num2str(max(nki_means(:,n))),...
        num2str(comb_means_mean(n)),...
        num2str(min(comb_means(:,n))),...
        num2str(max(comb_means(:,n)))));
end


msk_means_median = nanmedian(msk_means);
nki_means_median = nanmedian(nki_means);
comb_means_median = nanmedian(comb_means);

disp(['%%%%%%%%%%%%%%%%%%%%%']);
disp(['Median doses']);
for n=1:numreg,
    disp([Regions{n}]);
  
    disp(sprintf('\tMSK: %s\n\tNKI: %s\n\tCOMB %s',...
        num2str(msk_means_median(n)),...
        num2str(nki_means_median(n)),...
        num2str(comb_means_median(n))));
end

%% Calculate t-test for separation of means

[~,p_mean] = ttest2(msk_means,nki_means);

figure(4);
hold on;
plot(1:length(p_mean),p_mean,'b*');
set(gca,'XTickLabel',Regions);
xlim([0.5 (length(p_mean)+0.5)]);
plot([0.5 (length(p_mean)+0.5)], [0.05 0.05],'--r');
hold off;
p_euds = NaN(mLymanN,numreg); % leave out left/right for now!
for k=1:numreg,
    [~,cur_p_euds] = ttest2(msk_mean_euds(:,:,k),nki_mean_euds(:,:,k));
    p_euds(:,k) = cur_p_euds';
end

figure(5);
hold on;
h=plot(1:mLymanN,p_euds,'LineWidth',2);
plot([1 mLymanN], [0.05 0.05],'--r');
xlim([1 mLymanN]);
set(gca,'XTick',[1:2:21]);
set(gca,'XTickLabel',-1:0.2:1);
xlabel(['log10(a)']);
ylabel(['P-value T-test MSK/NKI gEUDs']);
legend(h,Regions);
hold off;

%% Calculate wilcoxon rank-sum for separation of means

p_median = zeros(1,numreg);

msk_rs_means = msk_means(1:n_msk_pts,:);
for j=1:numreg,

    nki_first_nan = find(isnan(nki_means(:,j)));
    nki_first_nan = nki_first_nan(1);
    nki_rs_means = nki_means(1:(nki_first_nan-1),j);

    [cur_p_median,~] = ranksum(msk_rs_means(:,j),nki_rs_means);    
    p_median(j)=cur_p_median;
end

figure(6);
hold on;
plot(1:length(p_median),p_median,'b*');
set(gca,'XTickLabel',Regions);
xlim([0.5 (numreg+0.5)]);
plot([0.5 (numreg+0.5)], [0.05 0.05],'--r');
hold off;
% p_median_euds = NaN(mLymanN,numreg-2); % leave out left/right for now!
% for k=1:(numreg-2),
%     [cur_p_median_euds,~] = ttest2(msk_mean_euds(:,:,k),nki_mean_euds(:,:,k));
%     p_median_euds(:,k) = cur_p_median_euds';
% end
% 
% figure(7);
% hold on;
% h=plot(1:mLymanN,p_median_euds,'LineWidth',2);
% plot([1 mLymanN], [0.05 0.05],'--r');
% xlim([1 mLymanN]);
% set(gca,'XTick',[1:2:21]);
% set(gca,'XTickLabel',-1:0.2:1);
% xlabel(['log10(a)']);
% ylabel(['P-value Rank Sum MSK/NKI gEUDs']);
% legend(h,Regions{1:(end-2)});
% hold off;
end
