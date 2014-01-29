function EudAtlasAnalysis_Astro
tic; %close all;
cm = colormap(jet(300)); cm=cm(1:256,:);
figureWidth = 6; % in inches
xticknum=10;
logn = [0.8; 0.9; 0.5; 0.8; 0.7];
ticksz = 26;
fontsz = 36;
tickszorg = 16;
fontszorg = 16;

% show logistic model

% load results
%     xlsFile = 'G:/MSKCC/Andy/2009R01/tom/MSK_LR_logDoseBins';
%     xlsFile = 'G:/MSKCC/Andy/2009R01/tom/MSK_NKI_LR_logDoseBins';
    xlsFile = 'G:/MSKCC/Andy/2009R01/tom/NKI_linearDoseBins';
%     xlsFile = 'G:/MSKCC/Andy/2009R01/tom/MSK_linearDoseBins';
    xlsFile = 'G:/MSKCC/Andy/2009R01/tom/MSK_NKI_linearDoseBins';
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
        
        % plot a DVH
        figure(1);
        plot(CGobjs(k).ptGrp(1).DoseBins_LQ, CGobjs(k).ptGrp(1).VolDiff,'LineWidth',1);
%             pos=get(gcf,'Position'); set(gcf,'Position',[pos(1:2), 900/3*4, 900]);
%         xlabel('Dose (Gy)','fontsize',fontsz); ylabel('Volume fraction','fontsize',fontsz); 
%         set(gca,'fontsize',ticksz);
        set(gca,'xminortick','on','yminortick','on');
        
        figure(2);
        plot(CGobjs(k).ptGrp(1).EUD,CGobjs(k).ptGrp(1).lgn, 'o-','LineWidth',1);
        set(gca,'YTickLabel',num2str(CGobjs(k).lgn(end:-2:1)));
%             pos=get(gcf,'Position'); set(gcf,'Position',[pos(1:2), 900/3*4, 900]);
%         xlabel('gEUD (Gy)','fontsize',fontsz); ylabel('log_1_0(a)','fontsize',fontsz);
%         set(gca,'fontsize',ticksz);
        set(gca,'xminortick','on','yminortick','on');

        % plot EUD vs. lgn
        f=[CGobjs(k).ptGrp.flgCensor]; g=find(f);
        figure(3); clf reset; hold on;
        for m = 1:length(g)
            plot(CGobjs(k).ptGrp(g(m)).EUD, CGobjs(k).ptGrp(g(m)).lgn,'LineWidth',1);
        end
        g=find(~f);
        for m = 1:length(g)
            plot(CGobjs(k).ptGrp(g(m)).EUD,CGobjs(k).ptGrp(g(m)).lgn, 'r','LineWidth',1);
        end
        set(gca,'YTickLabel',num2str(CGobjs(k).lgn(end:-2:1)));
%             pos=get(gcf,'Position'); set(gcf,'Position',[pos(1:2), 900/3*4, 900]);
        set(gca,'xminortick','on','yminortick','on');
%         ylabel('log_1_0(a)','fontsize',fontsz); xlabel('gEUD (Gy)','fontsize',fontsz); set(gca,'fontsize',ticksz);
        
        % generate atlas
        figure(100); clf reset;
        CGobjs(k).AtlasRotatedFig_EUD();

%         CGobjs(k).AtlasFig_EUD();
            xlabel('gEUD doses (Gy)','fontsize',fontsz); ylabel('log_1_0a','fontsize',fontsz);
        set(gca,'fontsize',ticksz);
        set(gca,'YTickLabel',num2str(CGobjs(k).lgn(end:-2:1)));
        
        % respond function
        n=find(CGobjs(k).lgn==logn(k)); % lgn
        % exact EUDs
        sts = CGobjs(k).LogisticRegressionMatExact_EUD(n).stats;
        euds = [CGobjs(k).ptGrp.EUD]; euds = euds(n,:);
        x = 0:max(euds);
        [yfit,dylo,dyhi] = glmval(sts.beta,x,'logit',sts);
        % binned EUDs
        stsb = CGobjs(k).LogisticRegressionMatBin_EUD(n).stats;
        if sts.beta(2)<=0 || stsb.beta(2)<=0
            disp('negative correlation');
        end
        [yfitb,dylob,dyhib] = glmval(stsb.beta,x,'logit',stsb);
        % plot curve
        figure(2); clf reset; hold on;
        plot(x,yfit,'r--','linewidth',3); 
        plot(x,yfitb,'linewidth',3);
        legend('Exact EUD','Binned EUD','Location','NorthWest');
        % plot confidence
        plot(x,yfit-dylo,'r--','linewidth',3);
        plot(x,yfit+dyhi,'r--','linewidth',3);
        plot(x,yfitb-dylob,'--','linewidth',3);
        plot(x,yfitb+dyhib,'--','linewidth',3);
        hold off; grid on;
        % qudratile of gEUDs
        numintv = 4;
        [sortQ,indxQ,indxorg] = EqualIntervals(euds,numintv);
        meaneud = zeros(numintv,1);
        prob = zeros(numintv,1);
        stdprob = zeros(numintv,1);
        erroru = zeros(numintv,1);
        errorl = zeros(numintv,1);
        f = ~f(indxorg);
        for m = 1 : numintv
            meaneud(m) = mean(sortQ(indxQ==m));
            numcomp = sum(f(indxQ==m)); numtotal = length(find(indxQ==m));
            prob(m) = numcomp/numtotal;
            stdprob(m) = sqrt(numtotal*prob(m)*(1-prob(m)))/numtotal;
            erroru(m) = betainv( .84, numcomp+1, numtotal - numcomp + 1 );
            errorl(m) = betainv( .16, numcomp+1, numtotal - numcomp + 1 );
        end
        figure(4); clf reset; hold on;
        plot(x,yfitb,'linewidth',3); 
        plot(x,yfit,'c','linewidth',3); 
        errorbar(meaneud,prob,max(0,prob-errorl),max(0,erroru-prob),'r*','linewidth',3,'markersize',18);
%         legend({'Atlas EUD','Exact EUD','RP rate'},'fontsize',tickszorg,'location','northwest');
%         xlabel('gEUD (Gy)','fontsize',fontszorg); ylabel('RP probability','fontsize',fontszorg);
        set(gca,'fontsize',tickszorg);
        
        plot(x,yfitb-dylob,'--','linewidth',3);
        plot(x,yfitb+dyhib,'--','linewidth',3);
        plot(x,yfit-dylo,'c--','linewidth',3);
        plot(x,yfit+dyhi,'c--','linewidth',3);
        hold off; grid on;
%             pos=get(gcf,'Position'); set(gcf,'Position',[pos(1:2), 900/3*4, 900]);
            
%         % check the atlas at 
%         m=1; plot(CGobjs(k).ptGrp(m).lgn, CGobjs(k).ptGrp(m).EUD);
%         hold on;
%         for m=2:CGobjs(k).numGrp
%         end
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
        
        set(gca,'YTick',1:length(CGobjs(k).lgn)); set(gca,'YTickLabel',CGobjs(k).lgn);
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

        set(gca,'YTick',1:length(CGobjs(k).lgn)); set(gca,'YTickLabel',CGobjs(k).lgn);
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
        
        set(gca,'YTick',1:length(CGobjs(k).lgn)); set(gca,'YTickLabel',CGobjs(k).lgn);
        ylabel('log n');

        title({[xlsSheets{k},' lung, lower 68% confidence limit on complication probability']});
    end
toc;