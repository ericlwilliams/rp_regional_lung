function EUD_AtlasAnalysis_MSK
tic;
% load msk data
    xlsFile = 'G:/MSKCC/Andy/2009R01/meta/MSK_EUD_integration';
    if isunix
        xlsFile=strrep(xlsFile,'G:','/media/SKI_G');
    end
    load(xlsFile,'CGobjs','matchpairs');

% analysis
    for k = 1:size(matchpairs,1)
        CGobjs(k) = CGobjs(k).BetaCumulativeProbability_EUD();
        CGobjs(k) = CGobjs(k).BetaInverseProbability_EUD();
        CGobjs(k) = CGobjs(k).LogisticRegressionAnalysisExact_EUD();
        CGobjs(k) = CGobjs(k).LogisticRegressionAnalysisBin_EUD();
    end
    
% save result
    xlsFile = 'G:/MSKCC/Andy/2009R01/tom/MSK_EUD_result';
    if isunix
        xlsFile=strrep(xlsFile,'G:','/media/SKI_G');
    end
    
    CGstrct = ObjToStruct(CGobjs);
    save(xlsFile,'CGobjs','CGstrct');
toc;