function EudAtlasAnalysis_plot
tic;
ticksz = 24;
fontsz = 32;
% load results
    % NKI 
        xlsFile = 'G:/MSKCC/Andy/2009R01/tom/NKI_linearDoseBins';
        if isunix
            xlsFile=strrep(xlsFile,'G:','/media/SKI_G');
        end
        load(xlsFile,'CGobjs','xlsSheets');
        CGnki=CGobjs; xlsnki=xlsSheets;

    % MSK
        xlsFile='G:/MSKCC/Andy/2009R01/tom/MSK_linearDoseBins';
        if isunix
            xlsFile=strrep(xlsFile,'G:','/media/SKI_G');
        end
        load(xlsFile,'CGobjs','xlsSheets');
        CGmsk=CGobjs; xlsmsk=xlsSheets;

    % combine nki and msk data    
        xlsFile='G:/MSKCC/Andy/2009R01/tom/MSK_NKI_linearDoseBins';
        if isunix
            xlsFile=strrep(xlsFile,'G:','/media/SKI_G');
        end
        load(xlsFile,'CGobjs','xlsSheets');
        CGcom=CGobjs; xlscom=xlsSheets;

% plot curves
    % matching pairs
        matchpairs={
            'Whole','Whole'
            'Contra','contra'
            'Ipsi','ipsi'
            'Superior','cranial'
            'Inferior','caudal'
            }; % msk, nki

    % plot curves
        p05=repmat(0.05,size(CGobjs(1).lgn));
        for k=1:length(matchpairs)
                % locate the sheet in each set
                    [~,fmsk]=ismember(matchpairs{k,1},xlsmsk);
                    [~,fnki]=ismember(matchpairs{k,2},xlsnki);
                    [~,fcom]=ismember(matchpairs{k,1},xlscom);
                    if isequal(fmsk,0) || isequal(fnki,0) || isequal(fcom,0)
                        error(['one of the matching pair ',matchpairs{k,:},' not found in atlas data set']);
                    end
                    
                % results
                    % msk
                    s_msk_exact=[CGmsk(fmsk).LogisticRegressionMatExact_EUD.stats]; p_msk_exact=[s_msk_exact.p]; d_msk_exact=[CGmsk(fmsk).LogisticRegressionMatExact_EUD.dev]./[s_msk_exact.dfe];
                    [~,pmskminexactloc]=min(p_msk_exact(2,:));
                    pmskminexactlnn=CGmsk(fmsk).lgn(pmskminexactloc);
                    d_msk_exact68=d_msk_exact(pmskminexactloc)+1/s_msk_exact(pmskminexactloc).dfe; d_msk_exact95=d_msk_exact(pmskminexactloc)+4/s_msk_exact(pmskminexactloc).dfe;
                    bmskexact68=[s_msk_exact.beta]+[s_msk_exact.se]; bmskexact95=[s_msk_exact.beta]+2*[s_msk_exact.se];
                    
                    s_msk_bin=[CGmsk(fmsk).LogisticRegressionMatBin_EUD.stats]; p_msk_bin=[s_msk_bin.p]; d_msk_bin=[CGmsk(fmsk).LogisticRegressionMatBin_EUD.dev]./[s_msk_bin.dfe];
                    pmskminbin=min(p_msk_bin(2,:)); pmskminbinloc=find(p_msk_bin(2,:)==pmskminbin);
                    pmskminbinlnn=CGmsk(fmsk).lgn(pmskminbinloc);
                    d_msk_bin68=d_msk_bin(pmskminbinloc)+1/s_msk_bin(pmskminbinloc).dfe; d_msk_bin95=d_msk_bin(pmskminbinloc)+4/s_msk_bin(pmskminbinloc).dfe;
                    bmskbin68=[s_msk_bin.beta]+[s_msk_bin.se]; bmskbin95=[s_msk_bin.beta]+2*[s_msk_bin.se];
                    
                    % nki
                    s_nki_exact=[CGnki(fnki).LogisticRegressionMatExact_EUD.stats]; p_nki_exact=[s_nki_exact.p]; d_nki_exact=[CGnki(fnki).LogisticRegressionMatExact_EUD.dev]./[s_nki_exact.dfe];
                    pnkiminexact=min(p_nki_exact(2,:)); pnkiminexactloc=find(p_nki_exact(2,:)==pnkiminexact);
                    pnkiminexactlnn=CGnki(fnki).lgn(pnkiminexactloc);
                    d_nki_exact68=d_nki_exact(pnkiminexactloc)+1/s_nki_exact(pnkiminexactloc).dfe; d_nki_exact95=d_nki_exact(pnkiminexactloc)+4/s_nki_exact(pnkiminexactloc).dfe;
                    bnkiexact68=[s_nki_exact.beta]+[s_nki_exact.se]; bnkiexact95=[s_nki_exact.beta]+2*[s_nki_exact.se];
                    
                    s_nki_bin=[CGnki(fnki).LogisticRegressionMatBin_EUD.stats]; p_nki_bin=[s_nki_bin.p]; d_nki_bin=[CGnki(fnki).LogisticRegressionMatBin_EUD.dev]./[s_nki_bin.dfe];
                    pnkiminbin=min(p_nki_bin(2,:)); pnkiminbinloc=find(p_nki_bin(2,:)==pnkiminbin);
                    pnkiminbinlnn=CGnki(fnki).lgn(pnkiminbinloc);
                    d_nki_bin68=d_nki_bin(pnkiminbinloc)+1/s_nki_bin(pnkiminbinloc).dfe; d_nki_bin95=d_nki_bin(pnkiminbinloc)+4/s_nki_bin(pnkiminbinloc).dfe;
                    bnkibin68=[s_nki_bin.beta]+[s_nki_bin.se]; bnkibin95=[s_nki_bin.beta]+2*[s_nki_bin.se];

                    % combine
                    s_com_exact=[CGcom(fcom).LogisticRegressionMatExact_EUD.stats]; p_com_exact=[s_com_exact.p]; d_com_exact=[CGcom(fcom).LogisticRegressionMatExact_EUD.dev]./[s_com_exact.dfe];
                    pcomminexact=min(p_com_exact(2,:)); pcomminexactloc=find(p_com_exact(2,:)==pcomminexact);
                    pcomminexactlnn=CGcom(fcom).lgn(pcomminexactloc);
                    d_com_exact68=d_com_exact(pcomminexactloc)+1/s_com_exact(pcomminexactloc).dfe; d_com_exact95=d_com_exact(pcomminexactloc)+4/s_com_exact(pcomminexactloc).dfe;
                    bcomexact68=[s_com_exact.beta]+[s_com_exact.se]; bcomexact95=[s_com_exact.beta]+2*[s_com_exact.se];
                    
                    s_com_bin=[CGcom(fcom).LogisticRegressionMatBin_EUD.stats]; p_com_bin=[s_com_bin.p]; d_com_bin=[CGcom(fcom).LogisticRegressionMatBin_EUD.dev]./[s_com_bin.dfe];
                    pcomminbin=min(p_com_bin(2,:)); pcomminbinloc=find(p_com_bin(2,:)==pcomminbin);
                    pcomminbinlnn=CGcom(fcom).lgn(pcomminbinloc);
                    d_com_bin68=d_com_bin(pcomminbinloc)+1/s_com_bin(pcomminbinloc).dfe; d_com_bin95=d_com_bin(pcomminbinloc)+4/s_com_bin(pcomminbinloc).dfe;
                    bcombin68=[s_com_bin.beta]+[s_com_bin.se]; bcombin95=[s_com_bin.beta]+2*[s_com_bin.se];
                    
                % plot results
                    disp(matchpairs{k,1});
                    % deviance
                    figure(1); plot(-CGnki(fnki).lgn,(d_nki_exact'),'s-','linewidth',3); hold on; plot(-CGnki(fnki).lgn,(d_nki_bin'),'*--','linewidth',3);
                    plot(-CGmsk(fmsk).lgn,(d_msk_exact'),'r.-','linewidth',3); plot(-CGmsk(fmsk).lgn,(d_msk_bin'),'ro--','linewidth',3); 
                    plot(-CGcom(fcom).lgn,(d_com_exact'),'k^-','linewidth',3); plot(-CGcom(fcom).lgn,(d_com_bin'),'kv--','linewidth',3);
                    plot(-CGcom(fcom).lgn,repmat(d_com_exact68,size(CGcom(fcom).lgn)),'c--','linewidth',3); plot(-CGcom(fcom).lgn,repmat(d_com_exact95,size(CGcom(fcom).lgn)),'c-','linewidth',3);
                    plot(-CGcom(fcom).lgn(pcomminexactloc), d_com_exact(pcomminexactloc),'kO','linewidth',10); hold off; grid on;
%                     title(matchpairs{k,1},'fontsize',18);
                    xlabel('log10(a)','fontsize',fontsz); ylabel('deviance per degree of freedom','fontsize',fontsz);
                    legend('NKI exact EUD','NKI atlas EUD ','MSK exact EUD','MSK atlas EUD','MSK-NKI exact EUD','MSK-NKI atlas EUD','68% CI','95% CI','Location','NorthEast','Location','southeast');
                    pos=get(gcf,'Position'); set(gcf,'Position',[pos(1:2), 720/3*4, 720]);
                    set(gca,'fontsize',ticksz);
                    % p-value
                    figure(2); semilogy(-CGnki(fnki).lgn, (p_nki_exact(2,:)'),'s-','linewidth',3); hold on; semilogy(-CGnki(fnki).lgn, (p_nki_bin(2,:)'),'*--','linewidth',3); 
                    semilogy(-CGmsk(fmsk).lgn, (p_msk_exact(2,:)'),'rs-','linewidth',3); semilogy(-CGmsk(fmsk).lgn, (p_msk_bin(2,:)'),'r*--','linewidth',3); 
                    semilogy(-CGcom(fcom).lgn, (p_com_exact(2,:)'),'ks--','linewidth',3); semilogy(-CGcom(fcom).lgn, (p_com_bin(2,:)'),'k*-','linewidth',3);
                    semilogy(-CGcom(fcom).lgn, p05,'m--','linewidth',3); hold off; grid on;
%                     title(matchpairs{k,1},'fontsize',fontsz);
                    xlabel('log10(a)','fontsize',fontsz); ylabel('p-value','fontsize',fontsz);
                    legend('NKI exact EUD','NKI atlas EUD','MSK exact EUD','MSK atlas EUD','MSK-NKI exact EUD','MSK-NKI atlas EUD','p-value = 0.05','Location','SouthEast');
                    pos=get(gcf,'Position'); set(gcf,'Position',[pos(1:2), 720/3*4, 720]);
                    set(gca,'fontsize',ticksz);
                    % p-value explain
                    figure(3); semilogy(-CGmsk(fmsk).lgn, (p_msk_exact(2,:)'),'rs-','linewidth',3);
                    set(gca,'fontsize',18); grid on; set(gca,'YLim',[0.001 1]);
                    figure(4); semilogy(-CGmsk(fmsk).lgn, (p_msk_bin(2,:)'),'r*--','linewidth',3); 
                    set(gca,'fontsize',18); grid on;
                    figure(5); clf reset;
                    semilogy(-CGmsk(fmsk).lgn, (p_msk_exact(2,:)'),'rs-','linewidth',3); hold on;
                    semilogy(-CGmsk(fmsk).lgn, (p_msk_bin(2,:)'),'r*--','linewidth',3); 
                    legend({'Exact gEUD','Atlas gEUD'},'Location','southeast');
                    set(gca,'fontsize',18); hold off; grid on;
%                     
%                     disp(['minimum p-value: nki = ', num2str(pnkiminexact),'(',num2str(pnkiminexactlnn),...
%                         ') msk= ',num2str(pmskminexact),'(',num2str(pmskminexactlnn),...
%                         ') com= ',num2str(pcomminexact),'(',num2str(pcomminexactlnn),')']);
%                     disp(['68% confidence: nki = ', num2str(bnkiexact68(2,pnkiminexactloc)),'(',num2str(pnkiminexactlnn),...
%                         ') msk= ',num2str(bmskexact68(2,pmskminexactloc)),'(',num2str(pmskminexactlnn),...
%                         ') com= ',num2str(bcomexact68(2,pcomminexactloc)),'(',num2str(pcomminexactlnn),')']);
%                     disp(['68% confidential limit: (exact)  ',num2str(bcomexact68(2,:))]);
%                     disp(['68% confidential limit: (bined)  ',num2str(bcombin68(2,:))]);
                    
                    disp('msk');
                    disp(['coefficients:']); disp(num2str([s_msk_exact.beta]));
                    disp('standard error'); disp(num2str([s_msk_exact.se]));
                    disp('68% limit'); disp(num2str([s_msk_exact.beta]+[s_msk_exact.se]));
                    disp(' '); disp('combination');
                    disp(['coefficients:']); disp(num2str([s_com_exact.beta]));
                    disp('standard error'); disp(num2str([s_com_exact.se]));
                    disp('68% limit'); disp(num2str([s_com_exact.beta]+[s_com_exact.se]))
        end
toc;