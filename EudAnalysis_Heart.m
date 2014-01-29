function EudAnalysis_Heart
tic; %close all;
% load results
    fn = 'Z:/elw/MATLAB/regions/data/MSK_heart';
    if isunix
        fn = strrep(fn, 'G:', '/media/SKI_G');
    end
    
    if 1 % start over
        fn_meta = 'Z:/elw/MATLAB/regions/meta/MSK_heart';
        if isunix
            fn_meta = strrep(fn_meta, 'G:', '/media/SKI_G');
        end
        load(fn_meta,'CGobjs'); CGmsk = CGobjs;
        save(fn,'CGmsk');
    end
    load(fn,'CGmsk');

% compute EUD
if 1
    CGmsk = CGmsk.fCalculateEUD();
end

% generate EUD atlases
if 0
    eudstep = 0.5; % step size in atlas
    CGmsk.mStepDose = eudstep;
    CGmsk = CGmsk.fCalculateEUDBins();
    CGmsk = CGmsk.fCrudeAtlas_EUD();
end

% Atlas analysis - probability of having >=20% RP rate & low 68% confidence
if 0
        % probability
        CGmsk = CGmsk.fBetaCumulativeProbability_EUD();
        % confidence
        CGmsk = CGmsk.fBetaInverseProbability_EUD();
end

% logistic regression analysis using matlab functions
if 0
        CGmsk = CGmsk.fLogisticRegressionExact_EUD();
end

% logistic regression analysis for atlas using matlab functions
if 0
        CGmsk = CGmsk.fLogisticRegressionBin_EUD();
end

% logistic regression grid analysis
if 0
    LogisticBetaRange = {(-10:0.1:10)'; (-1:0.01:1)'};
        CGmsk.mLogisticRegressionGridBetaRange = LogisticBetaRange;
        CGmsk = CGmsk.fLogisticRegressionGridExact_EUD();
end

% logistic regression grid analysis - goodness of fit
if 0
        CGmsk = CGmsk.fLogisticRegressionGoodnessOfFitSimulationExact_EUD();
end

% Lyman grid analysis
if 0
        CGmsk = CGmsk.fLymanAnalysisGridExact_EUD();
end

% Lyman grid analysis - goodness of fit
if 0
        CGmsk = CGmsk.fLymanGoodnessOfFitSimulationExact_EUD();
end

% save
if 0
    save(fn,'CGmsk');
end

toc;