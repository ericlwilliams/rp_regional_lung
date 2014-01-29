function EudAtlasDisplay_MSK_NKI_WholeLung
tic; %close all;
cm1 = colormap(jet(300)); cm1=cm1(1:256,:); %cm1(end,:) = 0.5;
cm2 = colormap(jet(10));
figureWidth = 6; % in inches
xticknum=10;
logn = [0.8; 0.9; 0.5; 0.8; 0.7];
ticksz = 14;
fontsz = 14;
tickszorg = 16;
fontszorg = 16;

% show logistic model

% % load results
%     xlsNKI = 'G:/MSKCC/Andy/2009R01/tom/NKI_linearDoseBins';
%     xlsMSK = 'G:/MSKCC/Andy/2009R01/tom/MSK_linearDoseBins';
%     xlsComb = 'G:/MSKCC/Andy/2009R01/tom/MSK_NKI_linearDoseBins';
%     if isunix
%         xlsNKI=strrep(xlsNKI,'G:','/media/SKI_G');
%         xlsMSK=strrep(xlsMSK,'G:','/media/SKI_G');
%         xlsComb=strrep(xlsComb,'G:','/media/SKI_G');
%     end
%     load(xlsNKI,'CGobjs','xlsSheets');
%     CGnki = CGobjs; xlsNKI = xlsSheets;
%     load(xlsMSK,'CGobjs','xlsSheets');
%     CGmsk = CGobjs; xlsMSK = xlsSheets;
%     load(xlsComb,'CGobjs','xlsSheets');
%     CGcomb = CGobjs; xlsComb = xlsSheets;
% 
% % find the whole lung
%     f=cellfun(@(x) strcmpi('Whole',x),xlsNKI);
%     CGnki = CGnki(f);
%     f=cellfun(@(x) strcmpi('Whole',x),xlsMSK);
%     CGmsk = CGmsk(f);
%     f=cellfun(@(x) strcmpi('Whole',x),xlsComb);
%     CGcomb = CGcomb(f);
    xlsNKI = 'G:/MSKCC/Andy/2009R01/tom/NKI_linearDoseBins_WholeLung';
    xlsMSK = 'G:/MSKCC/Andy/2009R01/tom/MSK_linearDoseBins_WholeLung';
    xlsComb = 'G:/MSKCC/Andy/2009R01/tom/MSK_NKI_linearDoseBins_WholeLung';
    if isunix
        xlsNKI=strrep(xlsNKI,'G:','/media/SKI_G');
        xlsMSK=strrep(xlsMSK,'G:','/media/SKI_G');
        xlsComb=strrep(xlsComb,'G:','/media/SKI_G');
    end
    load(xlsNKI);
    load(xlsMSK);
    load(xlsComb);

% % generate atlas for Andy
%     fn = 'G:/MSKCC/Andy/2009R01/tom/Table4Andy.xls';
%     if isunix
%         fn=strrep(fn,'G:','/media/SKI_G');
%     end
% 
%     shn = 'NKI_gEUD_exact';
%     CGnki.WriteXls4AndyExact_EUD(fn,shn);
%     shn = 'NKI_gEUD_bin';
%     CGnki.WriteXls4AndyBin_EUD(fn,shn);
% 
%     shn = 'MSKCC_gEUD_exact';
%     CGmsk.WriteXls4AndyExact_EUD(fn,shn);
%     shn = 'MSKCC_gEUD_bin';
%     CGmsk.WriteXls4AndyBin_EUD(fn,shn);
% 
%     shn = 'Comb_gEUD_exact';
%     CGcomb.WriteXls4AndyExact_EUD(fn,shn);
%     shn = 'Comb_gEUD_bin';
%     CGcomb.WriteXls4AndyBin_EUD(fn,shn);

% plot DVH -> gEUD
    figure(1); clf reset;
    CGnki.ptGrp(1).DiffDVHCurve_fig();
    xlabel(''); ylabel('');

    figure(2); clf reset;
    CGnki.ptGrp(1).EUDCurve_a_fig('o-');
    xlabel(''); ylabel('');

% plot gEUD curves
    figure(1); clf reset; hold on;
    CGnki.EUDCurvesFig_a_EUD();
    xlabel(''); ylabel('');
    figure(2); clf reset; hold on;
    CGcomb.EUDCurvesSummary_a_EUD();
    xlabel(''); ylabel('');

% atlas
    figure(1); clf reset;
    CGnki.AtlasCompactFig_EUD(fontsz,ticksz);
    xlabel(''); ylabel('');
    figure(2); clf reset;
    CGmsk.AtlasCompactFig_EUD(fontsz,ticksz);
    xlabel(''); ylabel('');
    figure(3); clf reset;
    CGcomb.AtlasCompactFig_EUD(fontsz,ticksz);
    xlabel(''); ylabel('');

% p-value of goodness of fit w.r.t number of groups
    disp('p-value of goodness of fit: Lyman Model:');
    disp(CGnki.LymanModelGoodnessOfFitSimulationExact_EUD.p_value);
    disp(CGnki.LymanModelGoodnessOfFitSimulationBin_EUD.p_value);
    disp(CGmsk.LymanModelGoodnessOfFitSimulationExact_EUD.p_value);
    disp(CGmsk.LymanModelGoodnessOfFitSimulationBin_EUD.p_value);
    disp(CGcomb.LymanModelGoodnessOfFitSimulationExact_EUD.p_value);
    disp(CGcomb.LymanModelGoodnessOfFitSimulationBin_EUD.p_value);
    disp('p-value of goodness of fit: LogisticRegression:');
    disp(CGnki.LogisticRegressionGoodnessOfFitSimulationExact_EUD.p_value);
    disp(CGnki.LogisticRegressionGoodnessOfFitSimulationBin_EUD.p_value);
    disp(CGmsk.LogisticRegressionGoodnessOfFitSimulationExact_EUD.p_value);
    disp(CGmsk.LogisticRegressionGoodnessOfFitSimulationBin_EUD.p_value);
    disp(CGcomb.LogisticRegressionGoodnessOfFitSimulationExact_EUD.p_value);
    disp(CGcomb.LogisticRegressionGoodnessOfFitSimulationBin_EUD.p_value);
%     figure(1); clf reset;
%     CGnki.LogisticRegressionGoodnessOfFitFig('loga');
%     xlabel(''); ylabel('');
%     figure(2); clf reset;
%     CGnki.LymanModelGridGoodnessOfFitFig('loga');
%     xlabel(''); ylabel('');
%     figure(1); clf reset;
%     CGmsk.LogisticRegressionGoodnessOfFitFig('loga');
%     xlabel(''); ylabel('');
%     figure(2); clf reset;
%     CGmsk.LymanModelGridGoodnessOfFitFig('loga');
%     xlabel(''); ylabel('');
%     figure(1); clf reset;
%     CGcomb.LogisticRegressionGoodnessOfFitFig('loga');
%     xlabel(''); ylabel('');
%     figure(2); clf reset;
%     CGcomb.LymanModelGridGoodnessOfFitFig('loga');
%     xlabel(''); ylabel('');
    
% Lyman model
    % maps - TD50 & m
    az=150; el=30;
    figure(1); clf reset; colormap(cm2);
    CGnki.LymanModelGridExactFig_TD50_m_EUD('loga',15);
    set(gca,'YLim',[0.2,1.6]);
    %     view(az,el);
    xlabel(''); ylabel(''); zlabel('');
    figure(2); clf reset; colormap(cm2);
    CGnki.LymanModelGridBinFig_TD50_m_EUD('loga',15);
    set(gca,'YLim',[0.2,1.6]);
    %     view(az,el);
    xlabel(''); ylabel(''); zlabel('');
    figure(1); clf reset; colormap(cm2);
    CGmsk.LymanModelGridExactFig_TD50_m_EUD('loga',15);
    set(gca,'YLim',[0.2,1.8]);
    %     view(az,el);
    xlabel(''); ylabel(''); zlabel('');
    figure(2); clf reset; colormap(cm2);
    CGmsk.LymanModelGridBinFig_TD50_m_EUD('loga',15);
    set(gca,'YLim',[0.2,1.4]);
    %     view(az,el);
    xlabel(''); ylabel(''); zlabel('');
    figure(1); clf reset; colormap(cm2);
    CGcomb.LymanModelGridExactFig_TD50_m_EUD('loga',25);
    set(gca,'YLim',[0.2,1.4]);
    %     view(az,el);
    xlabel(''); ylabel(''); zlabel('');
    figure(2); clf reset; colormap(cm2);
    CGcomb.LymanModelGridBinFig_TD50_m_EUD('loga',25);
    set(gca,'YLim',[0.2,1.4]);
    %     view(az,el);
    xlabel(''); ylabel(''); zlabel('');

    % maps - TD50 & a
    figure(1); clf reset; colormap(cm2);
    CGnki.LymanModelGridExactFig_TD50_a_EUD(15);
    set(gca,'XLim',[-1,0.8]);
    xlabel(''); ylabel(''); zlabel('');
    figure(2); clf reset; colormap(cm2);
    CGnki.LymanModelGridBinFig_TD50_a_EUD(15);
    set(gca,'XLim',[-1,0.8]);
    xlabel(''); ylabel(''); zlabel('');
    figure(1); clf reset; colormap(cm2);
    CGmsk.LymanModelGridExactFig_TD50_a_EUD(15);
    set(gca,'XLim',[-1,0.8]);
    xlabel(''); ylabel(''); zlabel('');
    figure(2); clf reset; colormap(cm2);
    CGmsk.LymanModelGridBinFig_TD50_a_EUD(15);
    set(gca,'XLim',[-1,0.8]);
    xlabel(''); ylabel(''); zlabel('');
    figure(1); clf reset; colormap(cm2);
    CGcomb.LymanModelGridExactFig_TD50_a_EUD(25);
    set(gca,'XLim',[-1,0.8]);
    xlabel(''); ylabel(''); zlabel('');
    figure(2); clf reset; colormap(cm2);
    CGcomb.LymanModelGridBinFig_TD50_a_EUD(25);
    set(gca,'XLim',[-1,0.8]);
    xlabel(''); ylabel(''); zlabel('');

    % maps - m & a
    az=-140; el=40;
    figure(1); clf reset; colormap(cm2);
    CGnki.LymanModelGridExactFig_m_a_EUD(15);
    set(gca,'XLim',[-1,0]); set(gca,'YLim',[0.1,1.2]);
    %     view(az,el);
    xlabel(''); ylabel(''); zlabel('');
    figure(2); clf reset; colormap(cm2);
    CGnki.LymanModelGridBinFig_m_a_EUD(15);
    set(gca,'XLim',[-1,0]); set(gca,'YLim',[0.1,1.2]);
    %     view(az,el);
    xlabel(''); ylabel(''); zlabel('');
    figure(1); clf reset; colormap(cm2);
    CGmsk.LymanModelGridExactFig_m_a_EUD(15);
    set(gca,'XLim',[-1,0]); set(gca,'YLim',[0.1,1.2]);
    %     view(az,el);
    xlabel(''); ylabel(''); zlabel('');
    figure(2); clf reset; colormap(cm2);
    CGmsk.LymanModelGridBinFig_m_a_EUD(15);
    set(gca,'XLim',[-1,0]); set(gca,'YLim',[0.1,1.2]);
    %     view(az,el);
    xlabel(''); ylabel(''); zlabel('');
    figure(1); clf reset; colormap(cm2);
    CGcomb.LymanModelGridExactFig_m_a_EUD(25);
    set(gca,'XLim',[-1,0]); set(gca,'YLim',[0.1,1.2]);
    %     view(az,el);
    xlabel(''); ylabel(''); zlabel('');
    figure(2); clf reset; colormap(cm2);
    CGcomb.LymanModelGridBinFig_m_a_EUD(25);
    set(gca,'XLim',[-1,0]); set(gca,'YLim',[0.1,1.2]);
    %     view(az,el);
    xlabel(''); ylabel(''); zlabel('');

    % curves - a
    figure(1); clf reset;
    CGnki.LymanModelGridExactFig_a_loglikelihood('bs--',2);
    CGmsk.LymanModelGridExactFig_a_loglikelihood('rs--',2);
    CGcomb.LymanModelGridExactFig_a_loglikelihood('ks--',2);
    CGnki.LymanModelGridBinFig_a_loglikelihood('b.-',2);
    CGmsk.LymanModelGridBinFig_a_loglikelihood('r.-',2);
    CGcomb.LymanModelGridBinFig_a_loglikelihood('k.-',2);
    xlabel(''); ylabel('');
            % set log10(n) at the top
            a1 = gca;
            a2 = copyobj(a1,gcf);
            set(a2,'Color','none');
            set(a2,'XAxisLocation','top');
            set(a2,'XTickLabel',num2str(CGcomb.lgn(end:-2:1)));

    % curves - TD50
    figure(2); clf reset;
    CGnki.LymanModelGridExactFig_TD50_loglikelihood('b--',2);
    CGmsk.LymanModelGridExactFig_TD50_loglikelihood('r--',2);
    CGcomb.LymanModelGridExactFig_TD50_loglikelihood('k--',2);
    CGnki.LymanModelGridBinFig_TD50_loglikelihood('b',2);
    CGmsk.LymanModelGridBinFig_TD50_loglikelihood('r',2);
    CGcomb.LymanModelGridBinFig_TD50_loglikelihood('k',2);
    set(gca,'XLim',[5,74]); set(gca,'YLim',[-0.5,-0.33]);
    xlabel(''); ylabel('');

    % curves - m
    figure(3); clf reset;
    CGnki.LymanModelGridExactFig_m_loglikelihood('b--',2);
    CGmsk.LymanModelGridExactFig_m_loglikelihood('r--',2);
    CGcomb.LymanModelGridExactFig_m_loglikelihood('k--',2);
    CGnki.LymanModelGridBinFig_m_loglikelihood('b',2);
    CGmsk.LymanModelGridBinFig_m_loglikelihood('r',2);
    CGcomb.LymanModelGridBinFig_m_loglikelihood('k',2);
    set(gca,'XLim',[0.2,1.2]); set(gca,'YLim',[-0.48,-0.32]);
    xlabel(''); ylabel('');

    % curves at specific a
%     figure(1); clf reset;
%     CGnki.LymanModelGridExactFig_TD50_loglikelihoodAtLoga_EUD(-1,'b--',2);
%     CGmsk.LymanModelGridExactFig_TD50_loglikelihoodAtLoga_EUD(-1,'r--',2);
%     CGcomb.LymanModelGridExactFig_TD50_loglikelihoodAtLoga_EUD(-1,'k--',2);
%     set(gca,'YLim',[-0.6,-0.3]);
%     figure(2); clf reset;
%     CGnki.LymanModelGridExactFig_m_loglikelihoodAtLoga_EUD(-1,'b--',2);
%     CGmsk.LymanModelGridExactFig_m_loglikelihoodAtLoga_EUD(-1,'r--',2);
%     CGcomb.LymanModelGridExactFig_m_loglikelihoodAtLoga_EUD(-1,'k--',2);
%     set(gca,'YLim',[-0.7,-0.3]);
%     figure(1); clf reset;
%     CGnki.LymanModelGridExactFig_TD50_loglikelihoodAtLoga_EUD(-0.3,'b--',2);
%     CGmsk.LymanModelGridExactFig_TD50_loglikelihoodAtLoga_EUD(-0.3,'r--',2);
%     CGcomb.LymanModelGridExactFig_TD50_loglikelihoodAtLoga_EUD(-0.3,'k--',2);
%     set(gca,'YLim',[-0.6,-0.3]);
%     figure(2); clf reset;
%     CGnki.LymanModelGridExactFig_m_loglikelihoodAtLoga_EUD(-0.3,'b--',2);
%     CGmsk.LymanModelGridExactFig_m_loglikelihoodAtLoga_EUD(-0.3,'r--',2);
%     CGcomb.LymanModelGridExactFig_m_loglikelihoodAtLoga_EUD(-0.3,'k--',2);
%     set(gca,'YLim',[-0.7,-0.3]);
%     figure(1); clf reset;
%     CGnki.LymanModelGridExactFig_TD50_loglikelihoodAtLoga_EUD(-0.9,'b--',2);
%     CGmsk.LymanModelGridExactFig_TD50_loglikelihoodAtLoga_EUD(-0.9,'r--',2);
%     CGcomb.LymanModelGridExactFig_TD50_loglikelihoodAtLoga_EUD(-0.9,'k--',2);
%     set(gca,'YLim',[-0.6,-0.3]);
%     figure(2); clf reset;
%     CGnki.LymanModelGridExactFig_m_loglikelihoodAtLoga_EUD(-0.9,'b--',2);
%     CGmsk.LymanModelGridExactFig_m_loglikelihoodAtLoga_EUD(-0.9,'r--',2);
%     CGcomb.LymanModelGridExactFig_m_loglikelihoodAtLoga_EUD(-0.9,'k--',2);
%     set(gca,'YLim',[-0.7,-0.3]);

    % response curve
    figure(1); clf reset; hold on;
    loga = CGnki.LymanModelGridResponseExactFig_a_EUD('loga','b',1);
    CGnki.LymanModelGridResponseBinFig_a_EUD(loga,'b.--',1);
    CGnki.ComplicationObservedFig_EUD(loga,4,'b*',1);
    hold off;
    xlabel(''); ylabel('');
    figure(2); clf reset; hold on;
    loga = CGmsk.LymanModelGridResponseExactFig_a_EUD('loga','r',1);
    CGmsk.LymanModelGridResponseBinFig_a_EUD(loga,'r.--',1);
    CGcomb.ComplicationObservedFig_EUD(loga,4,'r*',1);
    hold off;
    xlabel(''); ylabel('');
    figure(3); clf reset; hold on;
    loga = CGcomb.LymanModelGridResponseExactFig_a_EUD('loga','k',1);
    CGcomb.LymanModelGridResponseBinFig_a_EUD(loga,'k.--',1);
    CGcomb.ComplicationObservedFig_EUD(loga,4,'k*',1);
    hold off;
    set(gca,'YLim',[0,0.8])
    xlabel(''); ylabel('');

% logistic regression curves -- likelyhood & p-values
    % loglikely -- exact gEUD
    figure(1); clf reset; hold on;
    CGnki.LogisticRegressionLikelyhoodExactFig_a_EUD(-1,'bs--',2);
    CGmsk.LogisticRegressionLikelyhoodExactFig_a_EUD(-0.3,'rs--',2);
    CGcomb.LogisticRegressionLikelyhoodExactFig_a_EUD(-0.9,'ks--',2);
    % loglikely -- binned gEUD
    CGnki.LogisticRegressionLikelyhoodBinFig_a_EUD(-1,'b.-',2);
    CGmsk.LogisticRegressionLikelyhoodBinFig_a_EUD(-0.3,'r.-',2);
    CGcomb.LogisticRegressionLikelyhoodBinFig_a_EUD(-0.9,'k.-',2);
    xlabel(''); ylabel('');
    set(gca,'box','on');
    %     legend('NKI exact gEUD','NKI atlas gEUD','MSK exact gEUD','MSK atlas gEUD','MSK-NKI exact gEUD','MSK-NKI atlas gEUD','Location','NorthEastOutside');
    %     CGnki.LogisticRegressionLikelyhoodExactFig_a_EUD(-0.3,'bs--',2);
    %     CGmsk.LogisticRegressionLikelyhoodExactFig_a_EUD(-0.3,'rs--',2);
    %     CGcomb.LogisticRegressionLikelyhoodExactFig_a_EUD(-0.9,'ks--',2);

    % p-value -- exact gEUD
    figure(2); clf reset;
    CGnki.LogisticRegressionPvalueExactFig_a_EUD('bs--',2);
    CGmsk.LogisticRegressionPvalueExactFig_a_EUD('rs--',2);
    CGcomb.LogisticRegressionPvalueExactFig_a_EUD('ks--',2);
    % p-value -- binned gEUD
    CGnki.LogisticRegressionPvalueBinFig_a_EUD('b.-',2);
    CGmsk.LogisticRegressionPvalueBinFig_a_EUD('r.-',2);
    CGcomb.LogisticRegressionPvalueBinFig_a_EUD('k.-',2);
    xlabel(''); ylabel('');
    set(gca,'box','on');
    %     legend('NKI exact gEUD','NKI atlas gEUD','MSK exact gEUD','MSK atlas gEUD','MSK-NKI exact gEUD','MSK-NKI atlas gEUD','Location','NorthEastOutside');

    % responding function
    figure(1); clf reset; hold on;
    loga = CGnki.LogisticRegressionRespondingCurveExactFig_a_EUD('loga','b--',1);
    CGnki.LogisticRegressionRespondingCurveBinFig_a_EUD(loga,'b.-',1);
    CGnki.ComplicationObservedFig_EUD(loga,4,'b*',1);
    xlabel(''); ylabel('');
    figure(2); clf reset; hold on;
    loga = CGmsk.LogisticRegressionRespondingCurveExactFig_a_EUD('loga','r--',1);
    CGmsk.LogisticRegressionRespondingCurveBinFig_a_EUD(loga,'r.-',1);
    CGmsk.ComplicationObservedFig_EUD(loga,4,'r*',1);
    xlabel(''); ylabel('');
    figure(3); clf reset; hold on;
    loga = CGcomb.LogisticRegressionRespondingCurveExactFig_a_EUD('loga','k--',1);
    CGcomb.LogisticRegressionRespondingCurveBinFig_a_EUD(loga,'k.-',1);
    CGcomb.ComplicationObservedFig_EUD(loga,4,'k*',1);
    xlabel(''); ylabel('');

    % loglikely - grid
    % maps - b0 & b1
    figure(1); clf reset; colormap(cm2);
    CGnki.LogisticRegressionGridExactFig_b0_b1_EUD('loga');
    set(gca,'XLim',[-9, 0]); set(gca,'YLim',[-0.15,0.8]);
    xlabel(''); ylabel('');
    figure(2); clf reset; colormap(cm2);
    CGnki.LogisticRegressionGridBinFig_b0_b1_EUD('loga');
    set(gca,'XLim',[-9, 0]); set(gca,'YLim',[-0.15,0.8]);
    xlabel(''); ylabel('');
    figure(1); clf reset; colormap(cm2);
    CGmsk.LogisticRegressionGridExactFig_b0_b1_EUD('loga');
    set(gca,'XLim',[-9, 0]); set(gca,'YLim',[-0.15,0.8]);
    xlabel(''); ylabel('');
    figure(2); clf reset; colormap(cm2);
    CGmsk.LogisticRegressionGridBinFig_b0_b1_EUD('loga');
    set(gca,'XLim',[-9, 0]); set(gca,'YLim',[-0.15,0.8]);
    xlabel(''); ylabel('');
    figure(1); clf reset; colormap(cm2);
    CGcomb.LogisticRegressionGridExactFig_b0_b1_EUD('loga');
    set(gca,'XLim',[-9, 0]); set(gca,'YLim',[-0.15,0.8]);
    xlabel(''); ylabel('');
    figure(2); clf reset; colormap(cm2);
    CGcomb.LogisticRegressionGridBinFig_b0_b1_EUD('loga');
    set(gca,'XLim',[-9, 0]); set(gca,'YLim',[-0.15,0.8]);
    xlabel(''); ylabel('');

    % maps - b0 & a
    figure(1); clf reset; colormap(cm2);
    CGnki.LogisticRegressionGridExactFig_b0_a_EUD('loga');
    set(gca,'XLim',[-1,0.3]); set(gca,'YLim',[-9,-1.5]);
    xlabel(''); ylabel('');
    figure(2); clf reset; colormap(cm2);
    CGnki.LogisticRegressionGridBinFig_b0_a_EUD('loga');
    set(gca,'XLim',[-1,0.3]); set(gca,'YLim',[-9,-1.5]);
    xlabel(''); ylabel('');
    figure(1); clf reset; colormap(cm2);
    CGmsk.LogisticRegressionGridExactFig_b0_a_EUD('loga');
    set(gca,'XLim',[-1,0.3]); set(gca,'YLim',[-9,-1.5]);
    xlabel(''); ylabel('');
    figure(2); clf reset; colormap(cm2);
    CGmsk.LogisticRegressionGridBinFig_b0_a_EUD('loga');
    set(gca,'XLim',[-1,0.3]); set(gca,'YLim',[-9,-1.5]);
    xlabel(''); ylabel('');
    figure(1); clf reset; colormap(cm2);
    CGcomb.LogisticRegressionGridExactFig_b0_a_EUD('loga');
    set(gca,'XLim',[-1,0.3]); set(gca,'YLim',[-9,-1.5]);
    xlabel(''); ylabel('');
    figure(2); clf reset; colormap(cm2);
    CGcomb.LogisticRegressionGridBinFig_b0_a_EUD('loga');
    set(gca,'XLim',[-1,0.3]); set(gca,'YLim',[-9,-1.5]);
    xlabel(''); ylabel('');

    % maps - b1 & a
    figure(1); clf reset; colormap(cm2);
    CGnki.LogisticRegressionGridExactFig_b1_a_EUD('loga');
    set(gca,'YLim',[0,0.7]);
    xlabel(''); ylabel('');
    figure(2); clf reset; colormap(cm2);
    CGnki.LogisticRegressionGridBinFig_b1_a_EUD('loga');
    set(gca,'YLim',[0,0.7]);
    xlabel(''); ylabel('');
    figure(1); clf reset; colormap(cm2);
    CGmsk.LogisticRegressionGridExactFig_b1_a_EUD('loga');
    set(gca,'YLim',[0,0.7]);
    xlabel(''); ylabel('');
    figure(2); clf reset; colormap(cm2);
    CGmsk.LogisticRegressionGridBinFig_b1_a_EUD('loga');
    set(gca,'YLim',[0,0.7]);
    xlabel(''); ylabel('');
    figure(1); clf reset; colormap(cm2);
    CGcomb.LogisticRegressionGridExactFig_b1_a_EUD('loga');
    set(gca,'YLim',[0,0.7]);
    xlabel(''); ylabel('');
    figure(2); clf reset; colormap(cm2);
    CGcomb.LogisticRegressionGridBinFig_b1_a_EUD('loga');
    set(gca,'YLim',[0,0.7]);
    xlabel(''); ylabel('');

    % curves - a 
    figure(1); clf reset; hold on;
    CGnki.LogisticRegressionGridExactFig_a_loglikelhood_EUD('bs--',2);
    CGmsk.LogisticRegressionGridExactFig_a_loglikelhood_EUD('rs--',2);
    CGcomb.LogisticRegressionGridExactFig_a_loglikelhood_EUD('ks--',2);
    CGnki.LogisticRegressionGridBinFig_a_loglikelihood_EUD('b.-',2);
    CGmsk.LogisticRegressionGridBinFig_a_loglikelihood_EUD('r.-',2);
    CGcomb.LogisticRegressionGridBinFig_a_loglikelihood_EUD('k.-',2);
    xlabel(''); ylabel('');

    % curves - b0
    figure(2); clf reset; hold on;
    CGnki.LogisticRegressionGridExactFig_b0_loglikelihood_EUD('b--',2);
    CGmsk.LogisticRegressionGridExactFig_b0_loglikelihood_EUD('r--',2);
    CGcomb.LogisticRegressionGridExactFig_b0_loglikelihood_EUD('k--',2);
    CGnki.LogisticRegressionGridBinFig_b0_loglikelihood_EUD('b-',2);
    CGmsk.LogisticRegressionGridBinFig_b0_loglikelihood_EUD('r-',2);
    CGcomb.LogisticRegressionGridBinFig_b0_loglikelihood_EUD('k-',2);
    set(gca,'XLim',[-8.5,-0]);
    xlabel(''); ylabel('');

    % curves - b1
    figure(3); clf reset; hold on;
    CGnki.LogisticRegressionGridExactFig_b1_loglikelihood_EUD('b--',2);
    CGmsk.LogisticRegressionGridExactFig_b1_loglikelihood_EUD('r--',2);
    CGcomb.LogisticRegressionGridExactFig_b1_loglikelihood_EUD('k--',2);
    CGnki.LogisticRegressionGridBinFig_b1_loglikelihood_EUD('b-',2);
    CGmsk.LogisticRegressionGridBinFig_b1_loglikelihood_EUD('r-',2);
    CGcomb.LogisticRegressionGridBinFig_b1_loglikelihood_EUD('k-',2);
    set(gca,'XLim',[-0.1,0.65]); set(gca,'YLim',[-0.5,-0.32]);
    xlabel(''); ylabel('');

    % responding function
    figure(1); clf reset; hold on;
    loga = CGnki.LogisticRegressionGridRespondingCurveExactFig_a_EUD('loga','b--',2);
    CGnki.LogisticRegressionGridRespondingCurveBinFig_a_EUD(loga,'b.-',2);
    CGnki.ComplicationObservedFig_EUD(loga,4,'b.',2);
    xlabel(''); ylabel('');
    figure(2); clf reset; hold on;
    loga = CGmsk.LogisticRegressionGridRespondingCurveExactFig_a_EUD('loga','r--',2);
    CGmsk.LogisticRegressionGridRespondingCurveBinFig_a_EUD(loga,'r.-',2);
    CGmsk.ComplicationObservedFig_EUD(loga,4,'r.',2);
    xlabel(''); ylabel('');
    figure(3); clf reset; hold on;
    loga = CGcomb.LogisticRegressionGridRespondingCurveExactFig_a_EUD('loga','k--',2);
    CGcomb.LogisticRegressionGridRespondingCurveBinFig_a_EUD(loga,'k.-',2);
    CGcomb.ComplicationObservedFig_EUD(loga,4,'k.',2);
    xlabel(''); ylabel('');
    
% goodness of fit
%     % logistic
%     CGnki.LogisticRegressionHosmerLemeshowTestAnalysisExact_EUD('loga');
%     CGnki.LogisticRegressionGTestAnalysisExact_EUD('loga');
%     CGnki.LogisticRegressionPearsonTestAnalysisExact_EUD('loga');
%     CGmsk.LogisticRegressionHosmerLemeshowTestAnalysisExact_EUD('loga');
%     CGmsk.LogisticRegressionGTestAnalysisExact_EUD('loga');
%     CGmsk.LogisticRegressionPearsonTestAnalysisExact_EUD('loga');
%     CGcomb.LogisticRegressionHosmerLemeshowTestAnalysisExact_EUD('loga');
%     CGcomb.LogisticRegressionGTestAnalysisExact_EUD('loga');
%     CGcomb.LogisticRegressionPearsonTestAnalysisExact_EUD('loga');
% 
%     CGnki.LogisticRegressionHosmerLemeshowTestAnalysisBin_EUD('loga');
%     CGnki.LogisticRegressionGTestAnalysisBin_EUD('loga');
%     CGnki.LogisticRegressionPearsonTestAnalysisBin_EUD('loga');
%     CGmsk.LogisticRegressionHosmerLemeshowTestAnalysisBin_EUD('loga');
%     CGmsk.LogisticRegressionGTestAnalysisBin_EUD('loga');
%     CGmsk.LogisticRegressionPearsonTestAnalysisBin_EUD('loga');
%     CGcomb.LogisticRegressionHosmerLemeshowTestAnalysisBin_EUD('loga');
%     CGcomb.LogisticRegressionGTestAnalysisBin_EUD('loga');
%     CGcomb.LogisticRegressionPearsonTestAnalysisBin_EUD('loga');

%     % Lyman
%     CGnki.LymanModelHosmerLemeshowTestAnalysisExact_EUD('loga');
%     CGnki.LymanModelGTestAnalysisExact_EUD('loga');
%     CGnki.LymanModelPearsonTestAnalysisExact_EUD('loga');
%     CGmsk.LymanModelHosmerLemeshowTestAnalysisExact_EUD('loga');
%     CGmsk.LymanModelGTestAnalysisExact_EUD('loga');
%     CGmsk.LymanModelPearsonTestAnalysisExact_EUD('loga');
%     CGcomb.LymanModelHosmerLemeshowTestAnalysisExact_EUD('loga');
%     CGcomb.LymanModelGTestAnalysisExact_EUD('loga');
%     CGcomb.LymanModelPearsonTestAnalysisExact_EUD('loga');
% 
%     CGnki.LymanModelHosmerLemeshowTestAnalysisBin_EUD('loga');
%     CGnki.LymanModelGTestAnalysisBin_EUD('loga');
%     CGnki.LymanModelPearsonTestAnalysisBin_EUD('loga');
%     CGmsk.LymanModelHosmerLemeshowTestAnalysisBin_EUD('loga');
%     CGmsk.LymanModelGTestAnalysisBin_EUD('loga');
%     CGmsk.LymanModelPearsonTestAnalysisBin_EUD('loga');
%     CGcomb.LymanModelHosmerLemeshowTestAnalysisBin_EUD('loga');
%     CGcomb.LymanModelGTestAnalysisBin_EUD('loga');
%     CGcomb.LymanModelPearsonTestAnalysisBin_EUD('loga');


% probability of having at least 20% RP rate
    figure(1); clf reset;
    CGnki.ProbabilityFig_EUD();
    xlabel(''); ylabel('');
    figure(2); clf reset;
    CGmsk.ProbabilityFig_EUD();
    xlabel(''); ylabel('');
    figure(3); clf reset;
    CGcomb.ProbabilityFig_EUD();
    xlabel(''); ylabel('');
% low 68% confidence
    figure(1); clf reset;
    CGnki.Low68pctConfidenceFig_EUD();
    xlabel(''); ylabel('');
    figure(2); clf reset;
    CGmsk.Low68pctConfidenceFig_EUD();
    xlabel(''); ylabel('');
    figure(3); clf reset;
    CGcomb.Low68pctConfidenceFig_EUD();
    xlabel(''); ylabel('');




        % dose ticks using linear scales
%         doses=CGobjs(k).DoseBins_EUD;
%         doseticks=linspace(doses(1),doses(end),xticknum);
%         doseticks=round(doseticks*10)/10;
% 
        img = CGobjs(k).PatientComp_EUD./CGobjs(k).PatientTotal_EUD; img=img';
        imgmsk = isfinite(img);
%         img3=repmat(img,[1,1,3]);
%         img1=img;
%         img=ceil(img*256); img(img==0)=1;
%         img1(imgmsk)=cm1(img(imgmsk),1); img1(~imgmsk)=0.5; img3(:,:,1)=img1;
%         img1(imgmsk)=cm1(img(imgmsk),2); img1(~imgmsk)=0.5; img3(:,:,2)=img1;
%         img1(imgmsk)=cm1(img(imgmsk),3); img1(~imgmsk)=0.5; img3(:,:,3)=img1;
%         figure(1); clf reset; colormap(cm1);
%         image(img3); axis xy;
%         
%         cb = colorbar;
%         cbYlim = get(cb,'YLim');
%         set(cb,'YTick',0:cbYlim(2)/10:cbYlim(2));
%         set(cb,'YTickLabel',0:0.1:1);
%         
%         xlim=get(gca,'XLim');
%         xtick=linspace(xlim(1),xlim(2),xticknum);
%         set(gca,'XTick',xtick);
%         set(gca,'XTickLabel',doseticks);
%         xlabel('EUD dose (Gy)');
%         
%         set(gca,'YTick',1:length(CGobjs(k).lgn)); set(gca,'YTickLabel',CGobjs(k).lgn);
%         ylabel('log n'); %set(gca,'fontsize',16);
%         
%         title([xlsSheets{k},' lung complications vs. total']);

        img = CGobjs(k).PatientComp_EUD./CGobjs(k).PatientTotal_EUD; img=img';
        mx = ceil(max(img(imgmsk))*256);
        figure(1); clf reset; colormap(cm1(1:mx,:));
        contourf(img); axis xy;
        cb = colorbar;
        set(gca,'YTick',1:length(CGobjs(k).lgn)); set(gca,'YTickLabel',-CGobjs(k).lgn);
        set(gca,'xminortick','on','yminortick','on');
        disp([xlsSheets{k},' lung complications vs. total']);
%         ylabel('log n'); %set(gca,'fontsize',16);
        
%         title([xlsSheets{k},' lung complications vs. total']);

        % 0.2 probability
%         img=1-CGobjs(k).BetaCumulativeMat_EUD; img=img';
%         img3 = repmat(img,[1,1,3]);
%         img1 = img;
%         img = ceil(img*256); img(img==0)=1;
%         img1(imgmsk) = cm1(img(imgmsk),1); img1(~imgmsk)=0.5; img3(:,:,1)=img1;
%         img1(imgmsk)=cm1(img(imgmsk),2); img1(~imgmsk)=0.5; img3(:,:,2)=img1;
%         img1(imgmsk)=cm1(img(imgmsk),3); img1(~imgmsk)=0.5; img3(:,:,3)=img1;
%         figure(2); clf reset; colormap(cm1);
%         image(img3); axis xy;
%         
%         cb = colorbar;
%         cbYlim = get(cb,'YLim');
%         set(cb,'YTick',0:cbYlim(2)/10:cbYlim(2));
%         set(cb,'YTickLabel',0:0.1:1);
% 
%         xlim=get(gca,'XLim');
%         xtick=linspace(xlim(1),xlim(2),xticknum);
%         set(gca,'XTick',xtick);
%         set(gca,'XTickLabel',doseticks);
%         xlabel('EUD dose (Gy)');
% 
%         set(gca,'YTick',1:length(CGobjs(k).lgn)); set(gca,'YTickLabel',CGobjs(k).lgn);
%         ylabel('log n');
% 
%         title([xlsSheets{k},' lung, the probability that observed complications arise from true rate > 20%']);
        
        img=1-CGobjs(k).BetaCumulativeMat_EUD; img=img';
        mx = ceil(max(img(imgmsk))*256);
        img(~imgmsk) = NaN;
        figure(2); clf reset; colormap(cm1(1:mx,:));
        contourf(img); axis xy;
        cb = colorbar;
        set(gca,'YTick',1:length(CGobjs(k).lgn)); set(gca,'YTickLabel',-CGobjs(k).lgn);
        set(gca,'xminortick','on','yminortick','on');
        disp([xlsSheets{k},' lung, the probability that observed complications arise from true rate > 20%']);

        % low 0.68 probability
%         img=CGobjs(k).BetaInverseMat_EUD';
%         img3 = repmat(img,[1,1,3]);
%         img1 = img;
%         img = ceil(img*256); img(img==0)=1;
%         img1(imgmsk) = cm1(img(imgmsk),1); img1(~imgmsk)=0.5; img3(:,:,1)=img1;
%         img1(imgmsk)=cm1(img(imgmsk),2); img1(~imgmsk)=0.5; img3(:,:,2)=img1;
%         img1(imgmsk)=cm1(img(imgmsk),3); img1(~imgmsk)=0.5; img3(:,:,3)=img1;
%         figure(3); clf reset; colormap(cm1);
%         image(img3); axis xy;
% %         img=CGobjs(k).BetaInverseMat_EUD'; img(end,end)=1; img(end-1,end)=0;
% %         figure(3); contourf(img); %contourf(flipud(rot90(CGobjs(k).BetaInverseMat,1)));
%         
%         cb = colorbar;
%         cbYlim = get(cb,'YLim');
%         set(cb,'YTick',0:cbYlim(2)/10:cbYlim(2));
%         set(cb,'YTickLabel',0:0.1:1);
% %         set(gcf,'Unit','inches');
% %         pos=get(gcf,'Position'); set(gcf,'Position',[pos(1:2), figureWidth*pos(3)/pos(4),figureWidth]);
% 
%         xlim=get(gca,'XLim');
%         xtick=linspace(xlim(1),xlim(2),xticknum);
%         set(gca,'XTick',xtick);
%         set(gca,'XTickLabel',doseticks);
%         xlabel('EUD dose (Gy)');
%         
%         set(gca,'YTick',1:length(CGobjs(k).lgn)); set(gca,'YTickLabel',CGobjs(k).lgn);
%         ylabel('log n');
% 
%         title({[xlsSheets{k},' lung, lower 68% confidence limit on complication probability']});

        img=CGobjs(k).BetaInverseMat_EUD';
        mx = ceil(max(img(imgmsk))*256);
        img(~imgmsk) = NaN;
        figure(3); clf reset; colormap(cm1(1:mx,:));
        contourf(img); axis xy;
        cb = colorbar;
        set(gca,'YTick',1:length(CGobjs(k).lgn)); set(gca,'YTickLabel',-CGobjs(k).lgn);
        set(gca,'xminortick','on','yminortick','on');
        disp([xlsSheets{k},' lung, lower 68% confidence limit on complication probability']);

        % logestic regression curves
        

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
        
toc;