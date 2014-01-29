function Eud_AndyPaper
tic;
ticksz = 14;
fontsz = 14;
% load results
    % MSK
    xlsFile = 'G:/MSKCC/Andy/2009R01/tom/MSK_EUD_result';
    if isunix
        xlsFile=strrep(xlsFile,'G:','/media/SKI_G');
    end
    load(xlsFile,'CGobjs');
    CGmsk=CGobjs(1);

% plot atlas
    disp([CGmsk.LogisticRegressionMatBin_EUD.dev]);
    CGmsk.AtlasRotatedFig_EUD();
    CGmsk.AtlasCompactFig_EUD(fontsz,ticksz);
    CGmsk.LogLikelihoodFig_EUD();

% 
    
toc;