function EudAnalysis_Region_disp
tic; %close all;
    figure_loc = 'Z:/elw/MATLAB/regions/figures/latest/';
    regs = {'whole' 'ipsi' 'contra' 'sup' 'inf' 'left' 'right'};
% load results
    fn = 'Z:/elw/MATLAB/regions/data/EUD_regional_MSK_NKI.mat';
    fn_msk='Z:/elw/MATLAB/regions/meta/MSK_EUD_regional.mat'; % MSK data
    if isunix
        fn = strrep(fn, 'G:', '/media/SKI_G');
        fn_msk = strrep(fn_msk, 'G:', '/media/SKI_G');
    end
    load(fn,'CGmsk','CGnki','CGcomb');
    load(fn_msk,'Regions');
    numreg = length(CGmsk);

% prepare
    cm1 = colormap(jet(300)); cm1=cm1(1:256,:); %cm1(end,:) = 0.5;
    cm2 = colormap(jet(10));
    ticksz = 10;
    fontsz = 10;
    % log10(a) correction for figures
    k = 1; LymanN = log10(CGmsk(k).mLymanN);
    for k = 1:numreg
        CGmsk(k).mLymanN = LymanN;
        CGnki(k).mLymanN = LymanN;
        CGcomb(k).mLymanN = LymanN;
    end

% atlases
if 0
    for k = 1:numreg
        disp(' '); disp(Regions{k});
        figure(1); clf reset;
        CGmsk(k).fAtlasCompactFig_EUD(fontsz,ticksz);
        xlabel(''); ylabel('');
        figure(2); clf reset;
        CGnki(k).fAtlasCompactFig_EUD(fontsz,ticksz);
        xlabel(''); ylabel('');
        figure(3); clf reset;
        CGcomb(k).fAtlasCompactFig_EUD(fontsz,ticksz);
        xlabel(''); ylabel('');
    end
end

% probability of having >=20% RP rate
if 0
    for k = 1:numreg
        disp(' '); disp(Regions{k});
        figure(1); clf reset;
        CGmsk(k).fProbabilityFig_EUD();
        xlabel(''); ylabel('');
        figure(2); clf reset;
        CGnki(k).fProbabilityFig_EUD();
        xlabel(''); ylabel('');
        figure(3); clf reset;
        CGcomb(k).fProbabilityFig_EUD();
        xlabel(''); ylabel('');
    end
end
% low 68% confidence
if 0
    for k = 1:numreg
        disp(' '); disp(Regions{k});
        figure(1); clf reset;
        CGmsk(k).fLow68pctConfidenceFig_EUD();
        xlabel(''); ylabel('');
        figure(2); clf reset;
        CGnki(k).fLow68pctConfidenceFig_EUD();
        xlabel(''); ylabel('');
        figure(3); clf reset;
        CGcomb(k).fLow68pctConfidenceFig_EUD();
        xlabel(''); ylabel('');
    end
end

% G-value of goodness of fit
if 0
    for k = 1:numreg
        disp(['p-value of goodness of fit: Lyman Model: ', Regions{k}, ': ',...
            num2str([CGmsk(k).mLymanGoodnessOfFitSim.p_value, CGnki(k).mLymanGoodnessOfFitSim.p_value, CGcomb(k).mLymanGoodnessOfFitSim.p_value])]);

        disp(['p-value of goodness of fit: Logistic Regression: ', Regions{k}, ': ',...
            num2str([CGmsk(k).mLogisticRegressionGoodnessOfFitSim.p_value, CGnki(k).mLogisticRegressionGoodnessOfFitSim.p_value, CGcomb(k).mLogisticRegressionGoodnessOfFitSim.p_value])]);
    end
end

% Lyman model
% maps - TD50 & m
if 0
    for k = 1:numreg
        disp(' '); disp(Regions{k});
        figure(1); clf reset; colormap(cm2);
        CGmsk(k).fLymanGridExactFig_TD50_m_EUD();
        set(gca,'YLim',[0.1,2.2]);
        xlabel(''); ylabel('');
        set(gca,'box','on');
        figure(2); clf reset; colormap(cm2);
        CGnki(k).fLymanGridExactFig_TD50_m_EUD();
        set(gca,'YLim',[0.1,2.2]);
        xlabel(''); ylabel('');
        set(gca,'box','on');
        figure(3); clf reset; colormap(cm2);
        CGcomb(k).fLymanGridExactFig_TD50_m_EUD();
        set(gca,'YLim',[0.1,2.2]);
        xlabel(''); ylabel('');
        set(gca,'box','on');
    end
end
    
% maps - TD50 & a
if 0
    for k = 1:numreg
        disp(' '); disp(Regions{k});
        figure(1); clf reset; colormap(cm2);
        CGmsk(k).fLymanGridExactFig_TD50_a_EUD();
%         set(gca,'XLim',[-1,0.8]);
        xlabel(''); ylabel('');
        set(gca,'box','on');
        figure(2); clf reset; colormap(cm2);
        CGnki(k).fLymanGridExactFig_TD50_a_EUD();
%         set(gca,'XLim',[-1,0.8]);
        xlabel(''); ylabel('');
        set(gca,'box','on');
        figure(3); clf reset; colormap(cm2);
        CGcomb(k).fLymanGridExactFig_TD50_a_EUD();
%         set(gca,'XLim',[-1,0.8]);
        xlabel(''); ylabel('');
        set(gca,'box','on');
    end
end

% maps - m & a
if 0
    for k = 1:numreg
        disp(' '); disp(Regions{k});
        figure(1); clf reset; colormap(cm2);
        CGmsk(k).fLymanGridExactFig_m_a_EUD();
        set(gca,'YLim',[0.1,2.2]);
        xlabel(''); ylabel('');
        set(gca,'box','on');
        figure(2); clf reset; colormap(cm2);
        CGnki(k).fLymanGridExactFig_m_a_EUD();
        set(gca,'YLim',[0.1,2.2]);
        xlabel(''); ylabel('');
        set(gca,'box','on');
        figure(3); clf reset; colormap(cm2);
        CGcomb(k).fLymanGridExactFig_m_a_EUD();
        set(gca,'YLim',[0.1,2.2]);
        xlabel(''); ylabel('');
        set(gca,'box','on');
    end
end

% curves - a
if 0
    for k = 1:numreg
        disp(' '); disp(Regions{k});
        figure(1); clf reset; colormap(cm2);
        CGmsk(k).fLymanGridExactFig_a_loglikelihood('rs--',2);
        CGnki(k).fLymanGridExactFig_a_loglikelihood('bs--',2);
        CGcomb(k).fLymanGridExactFig_a_loglikelihood('ks--',2);
        xlabel(''); ylabel('');
        set(gca,'box','on');
        % set log10(n) at the top
        a1 = gca;
        a2 = copyobj(a1,gcf);
        set(a2,'Color','none');
        set(a2,'XAxisLocation','top');
        set(a2,'XTickLabel',num2str(CGcomb(k).mLymanN(end:-2:1)));
    end
end

% binned curves - a
if 0
    for k = 1:numreg
        disp(' '); disp(Regions{k});
        figure(1); clf reset; colormap(cm2);
        CGmsk(k).fLymanGridBinFig_a_loglikelihood('rs--',2);
        CGnki(k).fLymanGridBinFig_a_loglikelihood('bs--',2);
        CGcomb(k).fLymanGridBinFig_a_loglikelihood('ks--',2);
        xlabel(''); ylabel('');
        set(gca,'box','on');
        % set log10(n) at the top
        a1 = gca;
        a2 = copyobj(a1,gcf);
        set(a2,'Color','none');
        set(a2,'XAxisLocation','top');
        set(a2,'XTickLabel',num2str(CGcomb(k).mLymanN(end:-2:1)));
    end
end

% binned and exact curves -a
if 0
    for k = 1:numreg
        disp(' '); disp(Regions{k});
        figure(1); clf reset; colormap(cm2);
        disp('Exact MSK');
        CGmsk(k).fLymanGridExactFig_a_loglikelihood('rs--',2);
        disp('Exact NKI');
        CGnki(k).fLymanGridExactFig_a_loglikelihood('bs--',2);
        disp('Exact Comb');
        CGcomb(k).fLymanGridExactFig_a_loglikelihood('ks--',2);
        
        disp('Atlas MSK');
        CGmsk(k).fLymanGridBinFig_a_loglikelihood('r.-',2);
        disp('Atlas NKI');
        CGnki(k).fLymanGridBinFig_a_loglikelihood('b.-',2);
        disp('Atlas Comb');
        CGcomb(k).fLymanGridBinFig_a_loglikelihood('k.-',2);
        
        xlabel(''); ylabel('');
        set(gca,'box','on');
        % set log10(n) at the top
        a1 = gca;
        a2 = copyobj(a1,gcf);
        set(a2,'Color','none');
        set(a2,'XAxisLocation','top');
        set(a2,'XTickLabel',num2str(CGcomb(k).mLymanN(end:-2:1)));
    end
end

% curves - TD50
if 0
    for k = 1:numreg
        disp(' '); disp(Regions{k});
     
        figure(2); clf reset; colormap(cm2);
        disp('Exact MSK TD50');
        CGmsk(k).fLymanGridExactFig_TD50_loglikelihood('r--',2);
        disp('Exact NKI TD50');
        CGnki(k).fLymanGridExactFig_TD50_loglikelihood('b--',2);
        disp('Exact Comb TD50');
        CGcomb(k).fLymanGridExactFig_TD50_loglikelihood('k--',2);
        
        disp('Atlas MSK TD50');
        CGmsk(k).fLymanGridBinFig_TD50_loglikelihood('r.-',2);
        disp('Atlas NKI TD50');
        CGnki(k).fLymanGridBinFig_TD50_loglikelihood('b.-',2);
        disp('Atlas Comb TD50');
        CGcomb(k).fLymanGridBinFig_TD50_loglikelihood('k.-',2);
        
        
        
        set(gca,'YLim',[-0.5,-0.3]);
        xlabel(''); ylabel('');
        set(gca,'box','on');
    end
end

% curves - m
if 0
    for k = 1:numreg
        disp(' '); disp(Regions{k});
        figure(3); clf reset; colormap(cm2);
        
        disp('Exact MSK m');
        CGmsk(k).fLymanGridExactFig_m_loglikelihood('r--',2);
        
        disp('Exact NKI m');
        CGnki(k).fLymanGridExactFig_m_loglikelihood('b--',2);
        disp('Exact Comb m');
        CGcomb(k).fLymanGridExactFig_m_loglikelihood('k--',2);
        
        disp('Atlas MSK m');
        CGmsk(k).fLymanGridBinFig_m_loglikelihood('r.-',2);
        disp('Atlas NKI m');
        CGnki(k).fLymanGridBinFig_m_loglikelihood('b.-',2);
        disp('Atlas Comb m');
        CGcomb(k).fLymanGridBinFig_m_loglikelihood('k.-',2);
        
        set(gca,'XLim',[0.2,1.2]); set(gca,'YLim',[-0.48,-0.3]);
        xlabel(''); ylabel('');
        set(gca,'box','on');
       % cur_fig=gcf;
       % print(cur_fig,'-deps',strcat(figure_loc,'h_',regs{k},'_lkb_m.png'));
    end
end

% response curve
if 0
    for k = 1:numreg
        disp(' '); disp(Regions{k});
        figure(1); clf reset; colormap(cm2);
        loga = CGmsk(k).fLymanGridResponseExactFig_a_EUD('loga','r',1);
        CGmsk(k).fComplicationObservedFig_EUD(loga,4,'r*',1);
        xlabel(''); ylabel('');
        set(gca,'box','on');
        figure(2); clf reset; colormap(cm2);
        loga = CGnki(k).fLymanGridResponseExactFig_a_EUD('loga','b',1);
        CGnki(k).fComplicationObservedFig_EUD(loga,4,'b*',1);
        xlabel(''); ylabel('');
        set(gca,'box','on');
        figure(3); clf reset; colormap(cm2);
        loga = CGcomb(k).fLymanGridResponseExactFig_a_EUD('loga','k',1);
        CGcomb(k).fComplicationObservedFig_EUD(loga,4,'k*',1);
        set(gca,'YLim',[0,0.8])
        xlabel(''); ylabel('');
        set(gca,'box','on');
    end
end

% data sets consistency
if 0
    for k = 1:numreg
        disp(' '); disp(Regions{k});
        [Q,Qp, I2,I2up,I2down] = classOutcomeAnalysis.fLogisticRegressionDataConsistency_LKB_EUD([CGmsk(k); CGnki(k)]');
        disp([Q,Qp,I2,I2up,I2down]);
    end
end

% Logistic Regression
% data sets consistency
if 0
    for k = 1:numreg
        disp(' '); disp(Regions{k});
        [Q,Qp, I2] = classOutcomeAnalysis.fLogisticRegressionDataConsistency_EUD([CGmsk(k); CGnki(k)]');
        disp([Q,Qp,I2]);
    end
    
end
% likelyhood and p-values from matlab function
if 0
    for k = 1:numreg
        disp(' '); disp(Regions{k});
        figure(1); clf reset; colormap(cm2);
        
     
        CGmsk(k).fLogisticRegressionLikelyhoodExactFig_a_EUD('loga','rs--',2);
        CGnki(k).fLogisticRegressionLikelyhoodExactFig_a_EUD('loga','bs--',2);
        CGcomb(k).fLogisticRegressionLikelyhoodExactFig_a_EUD('loga','ks--',2);
        
        xlabel(''); ylabel('');
        set(gca,'box','on');

        figure(2); clf reset; colormap(cm2);
        CGmsk(k).fLogisticRegressionPvalueExactFig_a_EUD('rs--',2);
        CGnki(k).fLogisticRegressionPvalueExactFig_a_EUD('bs--',2);
        CGcomb(k).fLogisticRegressionPvalueExactFig_a_EUD('ks--',2);
        xlabel(''); ylabel('');
        set(gca,'box','on');
        
        %# HERE
        %# can put lyman p-value methods here
        figure(3); clf reset; colormap(cm2);
        CGmsk(k).fLKBPvalueFig_a_EUD('rs--',2);
        CGnki(k).fLKBPvalueFig_a_EUD('bs--',2);
        CGcomb(k).fLKBPvalueFig_a_EUD('ks--',2);        
        
        %#CGmsk(k).fLKBPvalueBinFig_a_EUD('r.-',2);
        %#CGnki(k).fLKBPvalueBinFig_a_EUD('b.-',2);
        %# CGcomb(k).fLKBPvalueBinFig_a_EUD('k.-',2);
        xlabel(''); ylabel('');
        set(gca,'box','on');
        
        
    end
end
% response function from matlab function
if 0
    for k = 1:numreg
        disp(' '); disp(Regions{k});
        figure(1); clf reset; colormap(cm2);
        loga = CGmsk(k).fLogisticRegressionRespondingCurveExactFig_a_EUD('loga','r',1);
        CGmsk(k).fComplicationObservedFig_EUD(loga,4,'r*',1);
        xlabel(''); ylabel('');
        set(gca,'box','on');
        figure(2); clf reset; colormap(cm2);
        loga = CGnki(k).fLogisticRegressionRespondingCurveExactFig_a_EUD('loga','b',1);
        CGnki(k).fComplicationObservedFig_EUD(loga,4,'b*',1);
        xlabel(''); ylabel('');
        set(gca,'box','on');
        figure(3); clf reset; colormap(cm2);
        loga = CGcomb(k).fLogisticRegressionRespondingCurveExactFig_a_EUD('loga','k',1);
        CGcomb(k).fComplicationObservedFig_EUD(loga,4,'k*',1);
        xlabel(''); ylabel('');
        set(gca,'box','on');
    end
end

% maps - b0 & b1
if 0
    for k = 1:numreg
        disp(' '); disp(Regions{k});
        figure(1); clf reset; colormap(cm2);
        CGmsk(k).fLogisticRegressionGridExactFig_b0_b1_EUD();
        set(gca,'YLim',[-0.6,0.9]);
        xlabel(''); ylabel('');
        set(gca,'box','on');
        figure(2); clf reset; colormap(cm2);
        CGnki(k).fLogisticRegressionGridExactFig_b0_b1_EUD();
        set(gca,'YLim',[-0.6,0.9]);
        xlabel(''); ylabel('');
        set(gca,'box','on');
        figure(3); clf reset; colormap(cm2);
        CGcomb(k).fLogisticRegressionGridExactFig_b0_b1_EUD();
        set(gca,'YLim',[-0.6,0.9]);
        xlabel(''); ylabel('');
        set(gca,'box','on');
    end
end
    
% maps - b0 & a
if 0
    for k = 1:numreg
        disp(' '); disp(Regions{k});
        figure(1); clf reset; colormap(cm2);
        CGmsk(k).fLogisticRegressionGridExactFig_b0_a_EUD();
        set(gca,'YLim',[-10,4]);
        xlabel(''); ylabel('');
        set(gca,'box','on');
        figure(2); clf reset; colormap(cm2);
        CGnki(k).fLogisticRegressionGridExactFig_b0_a_EUD();
        set(gca,'YLim',[-10,4]);
        xlabel(''); ylabel('');
        set(gca,'box','on');
        figure(3); clf reset; colormap(cm2);
        CGcomb(k).fLogisticRegressionGridExactFig_b0_a_EUD();
        set(gca,'YLim',[-10,4]);
        xlabel(''); ylabel('');
        set(gca,'box','on');
    end
end

% maps - b1 & a
if 0
    for k = 1:numreg
        disp(' '); disp(Regions{k});
        figure(1); clf reset; colormap(cm2);
        CGmsk(k).fLogisticRegressionGridExactFig_b1_a_EUD();
        set(gca,'YLim',[-0.4,0.7]);
        xlabel(''); ylabel('');
        set(gca,'box','on');
        figure(2); clf reset; colormap(cm2);
        CGnki(k).fLogisticRegressionGridExactFig_b1_a_EUD();
        set(gca,'YLim',[-0.4,0.7]);
        xlabel(''); ylabel('');
        set(gca,'box','on');
        figure(3); clf reset; colormap(cm2);
        CGcomb(k).fLogisticRegressionGridExactFig_b1_a_EUD();
        set(gca,'YLim',[-0.4,0.7]);
        xlabel(''); ylabel('');
        set(gca,'box','on');
    end
end

% curves - a
if 0
    for k = 1:numreg
        disp(' '); disp(Regions{k});
        figure(1); clf reset; colormap(cm2);
        CGmsk(k).fLogisticRegressionGridExactFig_a_loglikelhood_EUD('rs--',2);
        CGnki(k).fLogisticRegressionGridExactFig_a_loglikelhood_EUD('bs--',2);
        CGcomb(k).fLogisticRegressionGridExactFig_a_loglikelhood_EUD('ks--',2);
        xlabel(''); ylabel('');
        set(gca,'box','on');
    end
end

% curves - b0
if 0
    for k = 1:numreg
        disp(' '); disp(Regions{k});
        figure(2); clf reset; colormap(cm2);
        CGmsk(k).fLogisticRegressionGridExactFig_b0_loglikelihood_EUD('r--',2);
        CGnki(k).fLogisticRegressionGridExactFig_b0_loglikelihood_EUD('b--',2);
        CGcomb(k).fLogisticRegressionGridExactFig_b0_loglikelihood_EUD('k--',2);
        set(gca,'XLim',[-10,10]); set(gca,'YLim',[-0.5,-0.3]);
        xlabel(''); ylabel('');
        set(gca,'box','on');
    end
end

% curves - b1
if 0
    for k = 1:numreg
        disp(' '); disp(Regions{k});
        figure(3); clf reset; colormap(cm2);
        CGmsk(k).fLogisticRegressionGridExactFig_b1_loglikelihood_EUD('r--',2);
        CGnki(k).fLogisticRegressionGridExactFig_b1_loglikelihood_EUD('b--',2);
        CGcomb(k).fLogisticRegressionGridExactFig_b1_loglikelihood_EUD('k--',2);
        set(gca,'XLim',[-0.4,0.8]); set(gca,'YLim',[-0.5,-0.3]);
        xlabel(''); ylabel('');
        set(gca,'box','on');
    end
end

% response curve
if 1
    for k = 1:numreg
        disp(' '); disp(Regions{k});
        figure(1); clf reset; colormap(cm2);
        loga = CGmsk(k).fLogisticRegressionRespondingCurveExactFig_a_EUD('loga','r',1);
        CGmsk(k).fComplicationObservedFig_EUD(loga,4,'r*',1);
        xlabel(''); ylabel('');
        set(gca,'box','on');
        figure(2); clf reset; colormap(cm2);
        loga = CGnki(k).fLogisticRegressionRespondingCurveExactFig_a_EUD('loga','b',1);
        CGnki(k).fComplicationObservedFig_EUD(loga,4,'b*',1);
        xlabel(''); ylabel('');
        set(gca,'box','on');
        figure(3); clf reset; colormap(cm2);
        loga = CGcomb(k).fLogisticRegressionRespondingCurveExactFig_a_EUD('loga','k',1);
        CGcomb(k).fComplicationObservedFig_EUD(loga,4,'k*',1);
        xlabel(''); ylabel('');
        set(gca,'box','on');
    end
end
toc;