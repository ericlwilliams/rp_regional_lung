function LogEudAtlasAnalysis_plot
tic; %close all;
cm = colormap(jet(256));
figureWidth = 6; % in inches
xticknum=10;

% load results
    xlsFile = 'G:/MSKCC/Andy/2009R01/tom/NKI_logDoseBins';
%     xlsFile = 'G:/MSKCC/Andy/2009R01/tom/MSK_logDoseBins';
%     xlsFile = 'G:/MSKCC/Andy/2009R01/tom/MSK_NKI_logDoseBins';
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
        
        % dose ticks using log scales
        doses=CGobjs(k).DoseBins_EUD; % logdosebins=log10(doses);
        logdose(1)=floor(log10(doses(1))); logdose(2)=ceil(log10(doses(end))); % dose range in log scale
        logdoseintervals=logdose(1):logdose(2); % dose intervals in log scale, e.g., -1~1, 1~2, etc.
        doseticks=10^logdoseintervals(1); % dose at the left edge
        for m = 1:length(logdoseintervals)-1
            dosebins=linspace(10^logdoseintervals(m),10^logdoseintervals(m+1),10); % 10 equal spaced ticks in each interval
            doseticks=[doseticks,dosebins(2:end)]; % combine the new ticks with the current ones
        end
        f = (doseticks>=doses(1)) & (doseticks<=doses(end)); % remove doses not covered by the actual doses
        doseticks = doseticks(f);
        
        % atlas
%         doses=CGobjs(k).DoseBins_EUD; logdosebins=log10(doses);
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
        cbs = get(cb,'YTick');
        set(cb,'YTick',0:max(cbs)/10:max(cbs));
        set(cb,'YTickLabel',0:0.1:1);
%         set(gcf,'Unit','inches');
%         pos=get(gcf,'Position'); set(gcf,'Position',[pos(1:2), figureWidth*pos(3)/pos(4),figureWidth]);
        
%         xlim=get(gca,'XLim');
%         xtick=linspace(xlim(1),xlim(2),xticknum);
%         set(gca,'XTick',xtick);
%         xticklabel=linspace(logdosebins(1),logdosebins(end),xticknum); xticklabel=round((10.^xticklabel)*10)/10;
%         set(gca,'XTickLabel',xticklabel);
%         xlabel('EUD dose (Gy)','fontsize',16);
        xlim=get(gca,'XLim');
        xtick = xlim(1) + (xlim(2)-xlim(1))/(log10(doses(end))-log10(doses(1)))*(log10(doseticks)-log10(doses(1)));
        set(gca,'XTick',xtick);
        set(gca,'XTickLabel',doseticks);
        
        set(gca,'YTick',1:length(CGobjs(k).lnn)); set(gca,'YTickLabel',CGobjs(k).lnn);
        ylabel('log n'); %set(gca,'fontsize',16);
        
        title([xlsSheets{k},' lung complications vs. total']);

        % 0.2 probability
        img=1-CGobjs(k).BetaCumulativeMat_EUD; img(end,end)=1; img(end-1,end)=0; img=img';
        figure(2); contourf(img); %contourf(flipud(rot90(CGobjs(k).BetaCumulativeMat_EUD,1)));
        
        cb = colorbar;
        cbs = get(cb,'YTick');
        set(cb,'YTick',0:max(cbs)/10:max(cbs));
        set(cb,'YTickLabel',0:0.1:1);
%         set(gcf,'Unit','inches');
%         pos=get(gcf,'Position'); set(gcf,'Position',[pos(1:2), figureWidth*pos(3)/pos(4),figureWidth]);

%         xlim=get(gca,'XLim');
%         xtick=linspace(xlim(1),xlim(2),xticknum);
        set(gca,'XTick',xtick);
        set(gca,'XTickLabel',doseticks);
%         xlabel('EUD dose (Gy)','fontsize',16);
        xlabel('EUD dose (Gy)');

        set(gca,'YTick',1:length(CGobjs(k).lnn)); set(gca,'YTickLabel',CGobjs(k).lnn);
%         ylabel('log n','fontsize',16); set(gca,'fontsize',16);
        ylabel('log n');

%         title({[xlsSheets{k},' lung'], 'the probability that observed complications arise from true rate > 20%'},'fontsize',16);
        title([xlsSheets{k},' lung, the probability that observed complications arise from true rate > 20%']);
        
        % low 0.68 probability
        img=CGobjs(k).BetaInverseMat_EUD'; img(end,end)=1; img(end-1,end)=0;
        figure(3); contourf(img); %contourf(flipud(rot90(CGobjs(k).BetaInverseMat,1)));
        
        cb = colorbar;
        cbs = get(cb,'YTick');
        set(cb,'YTick',0:max(cbs)/10:max(cbs));
        set(cb,'YTickLabel',0:0.1:1);
%         set(gcf,'Unit','inches');
%         pos=get(gcf,'Position'); set(gcf,'Position',[pos(1:2), figureWidth*pos(3)/pos(4),figureWidth]);

%         xlim=get(gca,'XLim');
%         xtick=linspace(xlim(1),xlim(2),xticknum);
        set(gca,'XTick',xtick);
        set(gca,'XTickLabel',doseticks);
        xlabel('EUD dose (Gy)');
        
        set(gca,'YTick',1:length(CGobjs(k).lnn)); set(gca,'YTickLabel',CGobjs(k).lnn);
        ylabel('log n');

        title({[xlsSheets{k},' lung, lower 68% confidence limit on complication probability']});
%         xsteps=0:CGobjs(k).GyStep:max(CGobjs(k).EUD(:)); xtickvec=10:10:xsteps(end); xtickstep=(size(CGobjs(k).BetaInverseMat,1)/xsteps(end)*10);
%         set(gca,'XTick',xtickstep:xtickstep:size(CGobjs(k).BetaInverseMat,1)); set(gca,'XTickLabel',xtickvec);
%         ytickvec=CGobjs(k).lnn; ytickstep=size(CGobjs(k).BetaInverseMat,2)/length(ytickvec);
%         set(gca,'YTick',ytickstep:ytickstep:size(CGobjs(k).BetaInverseMat,2)); set(gca,'YTickLabel',ytickvec);
%         colorbar;
%         title([CGobjs(k).xlsSheet,' lung, lower 68% confidence limit on complication probability']);
%         xlabel('EUD doses (Gy)'); ylabel('log n');
    end
toc;