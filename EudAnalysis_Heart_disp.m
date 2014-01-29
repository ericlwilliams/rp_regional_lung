function EudAnalysis_Heart_disp
tic; %close all;
% load results
    fn = 'Z:/Fan/Andy/2009R01/tom/MSK_heart.mat';
    if isunix
        fn = strrep(fn, 'G:', '/media/SKI_G');
    end
    load(fn,'CGmsk');

% prepare
    cm1 = colormap(jet(300)); cm1=cm1(1:256,:); %cm1(end,:) = 0.5;
    cm2 = colormap(jet(10));
    ticksz = 10;
    fontsz = 10;
    % log10(a) correction for figures
    LymanN = log10(CGmsk.mLymanN);
    CGmsk.mLymanN = LymanN;

% atlases
if 1
        figure(1); clf reset;
        CGmsk.fAtlasCompactFig_EUD(fontsz,ticksz);
        xlabel(''); ylabel('');
end

% probability of having >=20% RP rate
if 0
        figure(1); clf reset;
        CGmsk.fProbabilityFig_EUD();
        xlabel(''); ylabel('');
end
% low 68% confidence
if 0
        figure(2); clf reset;
        CGmsk.fLow68pctConfidenceFig_EUD();
        xlabel(''); ylabel('');
end

% G-value of goodness of fit
if 0
        disp(['G-value of goodness of fit: Lyman Model: ', num2str(CGmsk.mLymanGoodnessOfFitSim.p_value)]);

        disp(['G-value of goodness of fit: Logistic Regression: ', num2str(CGmsk.mLogisticRegressionGoodnessOfFitSim.p_value)]);
end

% Lyman model
% maps - TD50 & m
if 0
        figure(1); clf reset; colormap(cm2);
        CGmsk.fLymanGridExactFig_TD50_m_EUD();
        set(gca,'YLim',[0.1,2.2]);
        xlabel(''); ylabel('');
        set(gca,'box','on');
end
    
% maps - TD50 & a
if 0
        figure(1); clf reset; colormap(cm2);
        CGmsk.fLymanGridExactFig_TD50_a_EUD();
%         set(gca,'XLim',[-1,0.8]);
        xlabel(''); ylabel('');
        set(gca,'box','on');
end

% maps - m & a
if 0
        figure(1); clf reset; colormap(cm2);
        CGmsk.fLymanGridExactFig_m_a_EUD();
        set(gca,'YLim',[0.1,2.2]);
        xlabel(''); ylabel('');
        set(gca,'box','on');
end

% curves - a
if 0
        figure(1); clf reset; colormap(cm2);
        CGmsk.fLymanGridExactFig_a_loglikelihood('rs--',2);
        xlabel(''); ylabel('');
        set(gca,'box','on');
        % set log10(n) at the top
        a1 = gca;
        a2 = copyobj(a1,gcf);
        set(a2,'Color','none');
        set(a2,'XAxisLocation','top');
        set(a2,'XTickLabel',num2str(CGmsk.mLymanN(end:-2:1)));
end

% curves - TD50
if 0
        figure(2); clf reset; colormap(cm2);
        CGmsk.fLymanGridExactFig_TD50_loglikelihood('r--',2);
        set(gca,'YLim',[-0.5,-0.3]);
        xlabel(''); ylabel('');
        set(gca,'box','on');
end

% curves - m
if 0
        figure(3); clf reset; colormap(cm2);
        CGmsk.fLymanGridExactFig_m_loglikelihood('r--',2);
        set(gca,'XLim',[0.2,1.2]); set(gca,'YLim',[-0.48,-0.3]);
        xlabel(''); ylabel('');
        set(gca,'box','on');
end

% response curve
if 0
        figure(1); clf reset; colormap(cm2);
        loga = CGmsk.fLymanGridResponseExactFig_a_EUD('loga','r',1);
        CGmsk.fComplicationObservedFig_EUD(loga,4,'r*',1);
        xlabel(''); ylabel('');
        set(gca,'box','on');
end


% Logistic Regression
% likelyhood and p-values from matlab function
if 0
        figure(1); clf reset; colormap(cm2);
        CGmsk.fLogisticRegressionLikelyhoodExactFig_a_EUD('loga','r.-',2);
        xlabel(''); ylabel('');
        set(gca,'box','on');

        figure(2); clf reset; colormap(cm2);
        CGmsk.fLogisticRegressionPvalueExactFig_a_EUD('rs--',2);
        xlabel(''); ylabel('');
        set(gca,'box','on');
end
% responding function from matlab function
if 0
        figure(1); clf reset; colormap(cm2);
        loga = CGmsk.fLogisticRegressionRespondingCurveExactFig_a_EUD('loga','r',1); % plot fit
        CGmsk.fComplicationObservedFig_EUD(loga,4,'r*',1);% plot data on fit
        xlabel(''); ylabel('');
        set(gca,'box','on');
end

% maps - b0 & b1
if 0
        figure(1); clf reset; colormap(cm2);
        CGmsk.fLogisticRegressionGridExactFig_b0_b1_EUD();
        set(gca,'YLim',[-0.6,0.9]);
        xlabel(''); ylabel('');
        set(gca,'box','on');
end
    
% maps - b0 & a
if 0
        figure(1); clf reset; colormap(cm2);
        CGmsk.fLogisticRegressionGridExactFig_b0_a_EUD();
        set(gca,'YLim',[-10,4]);
        xlabel(''); ylabel('');
        set(gca,'box','on');
end

% maps - b1 & a
if 0
        figure(1); clf reset; colormap(cm2);
        CGmsk.fLogisticRegressionGridExactFig_b1_a_EUD();
        set(gca,'YLim',[-0.4,0.7]);
        xlabel(''); ylabel('');
        set(gca,'box','on');
end

% curves - a
if 0
        figure(1); clf reset; colormap(cm2);
        CGmsk.fLogisticRegressionGridExactFig_a_loglikelhood_EUD('rs--',2);
        xlabel(''); ylabel('');
        set(gca,'box','on');
end

% curves - b0
if 0
        figure(2); clf reset; colormap(cm2);
        CGmsk.fLogisticRegressionGridExactFig_b0_loglikelihood_EUD('r--',2);
        set(gca,'XLim',[-10,10]); set(gca,'YLim',[-0.5,-0.3]);
        xlabel(''); ylabel('');
        set(gca,'box','on');
end

% curves - b1
if 0
        figure(3); clf reset; colormap(cm2);
        CGmsk.fLogisticRegressionGridExactFig_b1_loglikelihood_EUD('r--',2);
        set(gca,'XLim',[-0.4,0.8]); set(gca,'YLim',[-0.5,-0.3]);
        xlabel(''); ylabel('');
        set(gca,'box','on');
end

% response curve
if 0
        figure(1); clf reset; colormap(cm2);
        loga = CGmsk.fLogisticRegressionGridRespondingCurveExactFig_a_EUD('loga','r',1);
        CGmsk.fComplicationObservedFig_EUD(loga,4,'r*',1);
        xlabel(''); ylabel('');
        set(gca,'box','on');
end
toc;