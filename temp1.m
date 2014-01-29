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
%     xlsMSK = 'G:/MSKCC/Andy/2009R01/tom/MSK_linearDoseBins_WholeLung';
%     xlsComb = 'G:/MSKCC/Andy/2009R01/tom/MSK_NKI_linearDoseBins_WholeLung';
%     if isunix
%         xlsNKI=strrep(xlsNKI,'G:','/media/SKI_G');
%         xlsMSK=strrep(xlsMSK,'G:','/media/SKI_G');
%         xlsComb=strrep(xlsComb,'G:','/media/SKI_G');
%     end
    load(xlsNKI);
%     load(xlsMSK);
%     load(xlsComb);

% recompute gEUD for larger range of n

% Lmany model
%     CGnki = CGnki.LymanModelAnalysisFittingExact_EUD();

%     CGnki = CGnki.LymanModelAnalysisGridExact_EUD();
%     CGmsk = CGmsk.LymanModelAnalysisGridExact_EUD();
%     CGcomb = CGcomb.LymanModelAnalysisGridExact_EUD();

%     CGnki = CGnki.LymanModelAnalysisGridBin_EUD();
%     CGmsk = CGmsk.LymanModelAnalysisGridBin_EUD();
%     CGcomb = CGcomb.LymanModelAnalysisGridBin_EUD();

% save results
%     xlsNKI = 'G:/MSKCC/Andy/2009R01/tom/NKI_linearDoseBins_WholeLung';
%     xlsMSK = 'G:/MSKCC/Andy/2009R01/tom/MSK_linearDoseBins_WholeLung';
%     xlsComb = 'G:/MSKCC/Andy/2009R01/tom/MSK_NKI_linearDoseBins_WholeLung';
%     if isunix
%         xlsNKI=strrep(xlsNKI,'G:','/media/SKI_G');
%         xlsMSK=strrep(xlsMSK,'G:','/media/SKI_G');
%         xlsComb=strrep(xlsComb,'G:','/media/SKI_G');
%     end
%     save(xlsNKI,'CGnki');
%     save(xlsMSK,'CGmsk');
%     save(xlsComb,'CGcomb');
toc;