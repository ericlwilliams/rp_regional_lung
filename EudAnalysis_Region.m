function EudAnalysis_Region
tic; %close all;
% load results
    fn = 'Z:/elw/MATLAB/regions/data/EUD_regional_MSK_NKI.mat';
    if isunix
        fn = strrep(fn, 'G:', '/media/SKI_G');
    end
    
    % reload MSK/NKI data (outputs from Pt_MSK/NKI, combines them into 
    % EUD_regional_MSK_NKI.mat, and saves analysis data as calculated below
    if 0 
        %fn_msk='Z:/Fan/Andy/2009R01/meta/MSK_EUD_regional.mat'; % MSK data
        %fn_nki='Z:/Fan/Andy/2009R01/meta/NKI_EUD_regional.mat'; % NKI data
        fn_msk='Z:/elw/MATLAB/regions/meta/MSK_EUD_regional.mat'; % MSK data
        fn_nki='Z:/elw/MATLAB/regions/meta/NKI_EUD_regional.mat'; % NKI data
        if isunix
            fn_msk = strrep(fn_msk, 'G:', '/media/SKI_G');
            fn_nki = strrep(fn_nki, 'G:', '/media/SKI_G');
        end
        load(fn_msk,'Regions','CGobjs'); CGmsk = CGobjs;
        load(fn_nki,'CGobjs'); CGnki = CGobjs;
        CGcomb = CGmsk;
        for k = 1:length(CGobjs)
            CGcomb(k) = CGcomb(k).fAddPatient(CGnki(k).mGrp);
        end
        save(fn,'CGmsk','CGnki','CGcomb');
    end
    load(fn,'CGmsk','CGnki','CGcomb');

    numreg = length(CGmsk);
   

% generate EUD atlases
if 0
    eudstep = 0.5; % step size in atlas
    for k = 1:numreg
        CGmsk(k).mStepDose = eudstep;
        CGmsk(k) = CGmsk(k).fCalculateEUDBins();
        CGmsk(k) = CGmsk(k).fCrudeAtlas_EUD();

        CGnki(k).mStepDose = eudstep;
        CGnki(k) = CGnki(k).fCalculateEUDBins();
        CGnki(k) = CGnki(k).fCrudeAtlas_EUD();

        CGcomb(k).mStepDose = eudstep;
        CGcomb(k) = CGcomb(k).fCalculateEUDBins();
        CGcomb(k) = CGcomb(k).fCrudeAtlas_EUD();
    end
end

% Atlas analysis - probability of having >=20% RP rate & low 68% confidence
if 0
    for k = 1:numreg
        % probability
        CGmsk(k) = CGmsk(k).fBetaCumulativeProbability_EUD();
        CGnki(k) = CGnki(k).fBetaCumulativeProbability_EUD();
        CGcomb(k) = CGcomb(k).fBetaCumulativeProbability_EUD();
        % confidence
        CGmsk(k) = CGmsk(k).fBetaInverseProbability_EUD();
        CGnki(k) = CGnki(k).fBetaInverseProbability_EUD();
        CGcomb(k) = CGcomb(k).fBetaInverseProbability_EUD();
    end
end

% logistic regression analysis using matlab functions
if 0
    for k = 1:numreg
        CGmsk(k) = CGmsk(k).fLogisticRegressionExact_EUD();
        CGnki(k) = CGnki(k).fLogisticRegressionExact_EUD();
        CGcomb(k) = CGcomb(k).fLogisticRegressionExact_EUD();
    end
end

% logistic regression analysis for atlas using matlab functions
if 0
    for k = 1:numreg
        CGmsk(k) = CGmsk(k).fLogisticRegressionBin_EUD();
        CGnki(k) = CGnki(k).fLogisticRegressionBin_EUD();
        CGcomb(k) = CGcomb(k).fLogisticRegressionBin_EUD();
    end
end

% logistic regression grid analysis
if 0
    LogisticBetaRange = {(-10:0.1:10)'; (-1:0.01:1)'};
    for k = 1:numreg
        CGmsk(k).mLogisticRegressionGridBetaRange = LogisticBetaRange;
        CGnki(k).mLogisticRegressionGridBetaRange = LogisticBetaRange;
        CGcomb(k).mLogisticRegressionGridBetaRange = LogisticBetaRange;
        
        CGmsk(k) = CGmsk(k).fLogisticRegressionGridExact_EUD();
        CGnki(k) = CGnki(k).fLogisticRegressionGridExact_EUD();
        CGcomb(k) = CGcomb(k).fLogisticRegressionGridExact_EUD();
    end
end

% logistic regression grid analysis - goodness of fit
if 0
    for k = 1:numreg
        CGmsk(k) = CGmsk(k).fLogisticRegressionGoodnessOfFitSimulationExact_EUD();
        CGnki(k) = CGnki(k).fLogisticRegressionGoodnessOfFitSimulationExact_EUD();
        CGcomb(k) = CGcomb(k).fLogisticRegressionGoodnessOfFitSimulationExact_EUD();
    end
end

% Lyman grid analysis
if 1
    for k = 1:numreg
        CGmsk(k) = CGmsk(k).fLymanAnalysisGridExact_EUD();
        CGnki(k) = CGnki(k).fLymanAnalysisGridExact_EUD();
        CGcomb(k) = CGcomb(k).fLymanAnalysisGridExact_EUD();
    end
end
% Lyman binnned analysis
if 0
    for k = 1:numreg
        CGmsk(k) = CGmsk(k).fLymanAnalysisGridBin_EUD();
        CGnki(k) = CGnki(k).fLymanAnalysisGridBin_EUD();
        CGcomb(k) = CGcomb(k).fLymanAnalysisGridBin_EUD();
    end
end
% Lyman grid analysis - goodness of fit
if 0
    for k = 1:numreg
        CGmsk(k) = CGmsk(k).fLymanGoodnessOfFitSimulationExact_EUD();
        CGnki(k) = CGnki(k).fLymanGoodnessOfFitSimulationExact_EUD();
        CGcomb(k) = CGcomb(k).fLymanGoodnessOfFitSimulationExact_EUD();
    end
end

% save
if 0
    save(fn,'CGmsk','CGnki','CGcomb');
end

toc;