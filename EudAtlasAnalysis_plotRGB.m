function EudAtlasAnalysis_plotRGB
tic; %close all;
cm = colormap(jet(300)); cm=cm(1:256,:);
figureWidth = 6; % in inches
xticknum=10;

% load results
    xlsFile = 'G:/MSKCC/Andy/2009R01/tom/MSK_LR_logDoseBins';
    xlsFile = 'G:/MSKCC/Andy/2009R01/tom/MSK_NKI_LR_logDoseBins';
    xlsFile = 'G:/MSKCC/Andy/2009R01/tom/NKI_linearDoseBins';
%     xlsFile = 'G:/MSKCC/Andy/2009R01/tom/MSK_linearDoseBins';
%     xlsFile = 'G:/MSKCC/Andy/2009R01/tom/MSK_NKI_linearDoseBins';
    if isunix
        xlsFile=strrep(xlsFile,'G:','/media/SKI_G');
    end
    load(xlsFile,'CGobjs','xlsSheets');
    
% plot sheets
    for k=1:length(CGobjs)
        disp(xlsSheets(k))
        if isempty(CGobjs(k).BetaCumulativeMat_EUD) % no data, skip it
            continue;
        end
        
        % dose ticks using linear scales
        doses=CGobjs(k).DoseBins_EUD;
        doseticks=linspace(doses(1),doses(end),xticknum);
        doseticks=round(doseticks*10)/10;
        
        % atlas
        img = CGobjs(k).PatientComp_EUD./CGobjs(k).PatientTotal_EUD; img=img';
        imgmsk = isfinite(img);
        img3=repmat(img,[1,1,3]);
        img1=img;
        img=ceil(img*256); img(img==0)=1;
        img1(imgmsk)=cm(img(imgmsk),1); img1(~imgmsk)=0.5; img3(:,:,1)=img1;
        img1(imgmsk)=cm(img(imgmsk),2); img1(~imgmsk)=0.5; img3(:,:,2)=img1;
        img1(imgmsk)=cm(img(imgmsk),3); img1(~imgmsk)=0.5; img3(:,:,3)=img1;
        figure(1); cla; colormap(cm);
        image(img3); axis xy;
        
        cb = colorbar;
        cbYlim = get(cb,'YLim');
        set(cb,'YTick',0:cbYlim(2)/10:cbYlim(2));
        set(cb,'YTickLabel',0:0.1:1);
        
        xlim=get(gca,'XLim');
        xtick=linspace(xlim(1),xlim(2),xticknum);
        set(gca,'XTick',xtick);
        set(gca,'XTickLabel',doseticks);
        xlabel('EUD dose (Gy)');
        
        set(gca,'YTick',1:length(CGobjs(k).lnn)); set(gca,'YTickLabel',CGobjs(k).lnn);
        ylabel('log n'); %set(gca,'fontsize',16);
        
        title([xlsSheets{k},' lung complications vs. total']);

        % 0.2 probability
        img=1-CGobjs(k).BetaCumulativeMat_EUD; img=img';
        img3 = repmat(img,[1,1,3]);
        img1 = img;
        img = ceil(img*256); img(img==0)=1;
        img1(imgmsk) = cm(img(imgmsk),1); img1(~imgmsk)=0.5; img3(:,:,1)=img1;
        img1(imgmsk)=cm(img(imgmsk),2); img1(~imgmsk)=0.5; img3(:,:,2)=img1;
        img1(imgmsk)=cm(img(imgmsk),3); img1(~imgmsk)=0.5; img3(:,:,3)=img1;
        figure(2); cla; colormap(cm);
        image(img3); axis xy;
        
        cb = colorbar;
        cbYlim = get(cb,'YLim');
        set(cb,'YTick',0:cbYlim(2)/10:cbYlim(2));
        set(cb,'YTickLabel',0:0.1:1);

        xlim=get(gca,'XLim');
        xtick=linspace(xlim(1),xlim(2),xticknum);
        set(gca,'XTick',xtick);
        set(gca,'XTickLabel',doseticks);
        xlabel('EUD dose (Gy)');

        set(gca,'YTick',1:length(CGobjs(k).lnn)); set(gca,'YTickLabel',CGobjs(k).lnn);
        ylabel('log n');

        title([xlsSheets{k},' lung, the probability that observed complications arise from true rate > 20%']);
        
        % low 0.68 probability
        img=CGobjs(k).BetaInverseMat_EUD';
        img3 = repmat(img,[1,1,3]);
        img1 = img;
        img = ceil(img*256); img(img==0)=1;
        img1(imgmsk) = cm(img(imgmsk),1); img1(~imgmsk)=0.5; img3(:,:,1)=img1;
        img1(imgmsk)=cm(img(imgmsk),2); img1(~imgmsk)=0.5; img3(:,:,2)=img1;
        img1(imgmsk)=cm(img(imgmsk),3); img1(~imgmsk)=0.5; img3(:,:,3)=img1;
        figure(3); cla; colormap(cm);
        image(img3); axis xy;
%         img=CGobjs(k).BetaInverseMat_EUD'; img(end,end)=1; img(end-1,end)=0;
%         figure(3); contourf(img); %contourf(flipud(rot90(CGobjs(k).BetaInverseMat,1)));
        
        cb = colorbar;
        cbYlim = get(cb,'YLim');
        set(cb,'YTick',0:cbYlim(2)/10:cbYlim(2));
        set(cb,'YTickLabel',0:0.1:1);
%         set(gcf,'Unit','inches');
%         pos=get(gcf,'Position'); set(gcf,'Position',[pos(1:2), figureWidth*pos(3)/pos(4),figureWidth]);

        xlim=get(gca,'XLim');
        xtick=linspace(xlim(1),xlim(2),xticknum);
        set(gca,'XTick',xtick);
        set(gca,'XTickLabel',doseticks);
        xlabel('EUD dose (Gy)');
        
        set(gca,'YTick',1:length(CGobjs(k).lnn)); set(gca,'YTickLabel',CGobjs(k).lnn);
        ylabel('log n');

        title({[xlsSheets{k},' lung, lower 68% confidence limit on complication probability']});
    end
toc;