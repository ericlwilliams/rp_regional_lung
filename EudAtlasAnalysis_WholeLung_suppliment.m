function EudAtlasAnalysis_WholeLung_suppliment
tic; %close all;
% load results
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



% Lyman model
%     CGnki = CGnki.LymanModelAnalysisFittingExact_EUD();

%     CGnki.LymanModelGridTD50 = (0:0.1:CGnki.DoseBins_EUD(end))';
%     CGmsk.LymanModelGridTD50 = (0:0.1:CGmsk.DoseBins_EUD(end))';
%     CGcomb.LymanModelGridTD50 = (0:0.1:CGcomb.DoseBins_EUD(end))';
%     CGnki.LymanModelGridM = (0:0.01:10)'; CGnki.LymanModelGridM(1) = 0.001;
%     CGmsk.LymanModelGridM = (0:0.01:10)'; CGmsk.LymanModelGridM(1) = 0.001;
%     CGcomb.LymanModelGridM = (0:0.01:10)'; CGcomb.LymanModelGridM(1) = 0.001;

%     CGnki = CGnki.LymanModelAnalysisGridExact_EUD();
%     CGmsk = CGmsk.LymanModelAnalysisGridExact_EUD();
%     CGcomb = CGcomb.LymanModelAnalysisGridExact_EUD();

%     CGnki = CGnki.LymanModelAnalysisGridBin_EUD();
%     CGmsk = CGmsk.LymanModelAnalysisGridBin_EUD();
%     CGcomb = CGcomb.LymanModelAnalysisGridBin_EUD();

    CGnki = CGnki.LymanModelGoodnessOfFitAnalysisSimulationExact_EUD();
    CGmsk = CGmsk.LymanModelGoodnessOfFitAnalysisSimulationExact_EUD();
    CGcomb = CGcomb.LymanModelGoodnessOfFitAnalysisSimulationExact_EUD();

    CGnki = CGnki.LymanModelGoodnessOfFitAnalysisSimulationBin_EUD();
    CGmsk = CGmsk.LymanModelGoodnessOfFitAnalysisSimulationBin_EUD();
    CGcomb = CGcomb.LymanModelGoodnessOfFitAnalysisSimulationBin_EUD();

% Logistic Regression
%     CGnki.LogisticRegressionGridBeta = {(-10:0.1:2)', (-1:0.01:1)'};
%     CGmsk.LogisticRegressionGridBeta = {(-10:0.1:2)', (-1:0.01:1)'};
%     CGcomb.LogisticRegressionGridBeta = {(-10:0.1:2)', (-1:0.01:1)'};
    
%     CGnki = CGnki.LogisticRegressionAnalysisGridExact_EUD();
%     CGmsk = CGmsk.LogisticRegressionAnalysisGridExact_EUD();
%     CGcomb = CGcomb.LogisticRegressionAnalysisGridExact_EUD();

%     CGnki = CGnki.LogisticRegressionAnalysisGridBin_EUD();
%     CGmsk = CGmsk.LogisticRegressionAnalysisGridBin_EUD();
%     CGcomb = CGcomb.LogisticRegressionAnalysisGridBin_EUD();

    CGnki = CGnki.LogisticRegressionGoodnessOfFitAnalysisSimulationExact_EUD();
    CGmsk = CGmsk.LogisticRegressionGoodnessOfFitAnalysisSimulationExact_EUD();
    CGcomb = CGcomb.LogisticRegressionGoodnessOfFitAnalysisSimulationExact_EUD();

    CGnki = CGnki.LogisticRegressionGoodnessOfFitAnalysisSimulationBin_EUD();
    CGmsk = CGmsk.LogisticRegressionGoodnessOfFitAnalysisSimulationBin_EUD();
    CGcomb = CGcomb.LogisticRegressionGoodnessOfFitAnalysisSimulationBin_EUD();

% save results
%     xlsNKI = 'G:/MSKCC/Andy/2009R01/tom/NKI_linearDoseBins_WholeLung';
%     xlsMSK = 'G:/MSKCC/Andy/2009R01/tom/MSK_linearDoseBins_WholeLung';
%     xlsComb = 'G:/MSKCC/Andy/2009R01/tom/MSK_NKI_linearDoseBins_WholeLung';
%     if isunix
%         xlsNKI=strrep(xlsNKI,'G:','/media/SKI_G');
%         xlsMSK=strrep(xlsMSK,'G:','/media/SKI_G');
%         xlsComb=strrep(xlsComb,'G:','/media/SKI_G');
%     end
    save(xlsNKI,'CGnki');
    save(xlsMSK,'CGmsk');
    save(xlsComb,'CGcomb');
toc;