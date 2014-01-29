function EudAtlasAnalysis
tic;
%% prepare a DVH2Atals
    DAobj=DVH2Atlas();
    
%% NKI data
    % patients with DE numbers and with both lungs
        % .xls file and sheet
        xlsFile='G:/MSKCC/Andy/2009R01/tom/NSCLC_all_rev (2)'; xlsSheet='Whole'; % file and sheet info
        if isunix
            xlsFile=strrep(xlsFile,'G:','/media/SKI_G');
        end
        
        % patient code
        try
            load(strcat(xlsFile,'_ptcode.mat'),'ptcode');
        catch
            % read the sheet
            DAobj.xlsFile_input=strrep(xlsFile,'tom','meta'); DAobj.xlsSheet=xlsSheet; DAobj=DAobj.ReadXls();
            % all patient codes
            DAobj.PatientColName='LFOnumber'; DAobj=DAobj.PatientCodeInXlsraw(); ptcode=DAobj.PatientCode; f=DAobj.PatientRows;
            % patients with non-zero DE number
            DAobj.PatientColName='DEnumber'; DAobj=DAobj.PatientCodeInXlsraw(); f=f&DAobj.PatientRows;
            % patients with one lung only
            DAobj.PatientColName='Tumor position/One lung'; DAobj=DAobj.PatientCodeInXlsraw(); 
            ptonelung=cellfun(@(x) strcmpi(x,'one lung'),DAobj.PatientCode); f=f&~ptonelung;
            % patients with non-zero DE number and with both lungs
            ptcode=ptcode(f);
            ptcode=cellfun(@(x) num2str(x),ptcode,'UniformOutput', false); % change number to strings
            save(strcat(xlsFile,'_ptcode.mat'),'ptcode');
        end

    % patient EUD computation
        % whole lung
            % .xls file
            xlsFile='G:/MSKCC/Andy/2009R01/tom/NSCLC_all_rev (2)';
            if isunix
                xlsFile=strrep(xlsFile,'G:','/media/SKI_G');
            end
            
            % load analysis result or compute it
            try
                error;
                load(xlsFile,'DAobjs');
            catch
                % read all the sheets
                xlsFile1=strrep(xlsFile,'tom','meta');
                try
                    load(xlsFile1);
                catch
                    xlsData=xlsFileRead(xlsFile1);
                    save(xlsFile1,'xlsData');
                end

                % adjust DVH2Atlas object
                DAobj.xlsFile_input=xlsFile1;
                DAobj.xlsFile_output=strcat(xlsFile,'_tom');
                DAobj.flgColInput=true;
                DAobj.flgColOutput=false;
                DAobj.PatientColName='lfonr'; % patient code column name
                DAobj.PatientColName='LFOnumber'; % patient code column name
                DAobj.DoseRowName='# Dose bins (Gy):';
                DAobj.DoseRowName='Dose Bin (Gy)';
                DAobj.ComplicationColName='Max RP grade'; % complication column name
                DAobj.ComplicationThreshold=2; % the grade that is deemed as severe
                DAobj.BetaCumulativeThreshold=0.2;
                DAobj.BetaInverseThreshold=0.16;

                % sheet by sheet analysis
                DAobjs=repmat(DAobj,[length(xlsData),1]);
                for k=1:length(xlsData)
                    try
                        DAobjs(k).xlsSheet=xlsData(k).SheetName; disp(DAobjs(k).xlsSheet);
                        DAobjs(k)=DAobjs(k).AssignXlsSheet(xlsData(k).xlsRaw);
                        
                        DAobjs(k)=DAobjs(k).PatientCodeInXlsraw();
                        patientcode=DAobjs(k).PatientCode; f=cellfun(@(x) isnumeric(x), patientcode);
                        patientcode(f)=cellfun(@(x) num2str(x),patientcode(f),'UniformOutput', false);
                        f=ismember(patientcode,ptcode);
                        DAobjs(k).PatientRows(~f)=false; % only patients in ptcode are considered
                        
                        DAobjs(k)=DAobjs(k).DoseBinInXlsraw();
                        DAobjs(k)=DAobjs(k).CalculateEUDFromDVH();

                        DAobjs(k)=DAobjs(k).ComplicationInXlsraw();
%                         DAobjs(k).ComplicationRows=DAobjs(k).ComplicationRows&DAobjs(k).PatientRows; 
%                         DAobjs(k).ComplicationGrade(~DAobjs(k).ComplicationRows)=0;% only patients in ptcode are considered

                        DAobjs(k)=DAobjs(k).AtlasStatistics();
                        DAobjs(k)=DAobjs(k).BetaCumulativeProbability();
                        DAobjs(k)=DAobjs(k).BetaInverseProbability();
                        DAobjs(k)=DAobjs(k).LogisticRegressionAnalysis();
                        
%                         DAobjs(k).WriteXls();

                    catch ME
                        disp(ME.message);
                    end
                end
                save(xlsFile,'DAobjs');
            end
            DAnki=DAobjs;
            
        % partial lung
            % .xls file
            xlsFile='G:/MSKCC/Andy/2009R01/tom/DvhRegios';
            if isunix
                xlsFile=strrep(xlsFile,'G:','/media/SKI_G');
            end
            
            % load analysis result or compute it
            try
                error;
                load(xlsFile,'DAobjs');
            catch
                % read all the sheets
                xlsFile1=strrep(xlsFile,'tom','meta');
                try
                    load(xlsFile1);
                catch
                    xlsData=xlsFileRead(xlsFile1);
                    save(xlsFile1,'xlsData');
                end

                % adjust DVH2Atlas object
                DAobj.xlsFile_input=xlsFile1;
                DAobj.xlsFile_output=strcat(xlsFile,'_tom');
                DAobj.flgColInput=true;
                DAobj.flgColOutput=false;
                DAobj.PatientColName='lfonr'; % patient code column name
                DAobj.DoseRowName='# Dose bins (Gy):';
                DAobj.ComplicationColName='rp grade'; % complication column name
                DAobj.ComplicationThreshold=2; % the grade that is deemed as severe
                DAobj.BetaCumulativeThreshold=0.2;
                DAobj.BetaInverseThreshold=0.16;

                % sheet by sheet
                DAobjs=repmat(DAobj,[length(xlsData),1]);
                d=false(length(xlsData),1);
                for k=1:length(xlsData)
                    try
                        DAobjs(k).xlsSheet=xlsData(k).SheetName; disp(DAobjs(k).xlsSheet);
                        DAobjs(k)=DAobjs(k).AssignXlsSheet(xlsData(k).xlsRaw);
                        
                        DAobjs(k)=DAobjs(k).PatientCodeInXlsraw();
                        patientcode=DAobjs(k).PatientCode; f=cellfun(@(x) isnumeric(x), patientcode);
                        patientcode(f)=cellfun(@(x) num2str(x),patientcode(f),'UniformOutput', false);
                        f=ismember(patientcode,ptcode);
                        DAobjs(k).PatientRows(~f)=false; % only patients in ptcode are considered
                        
                        DAobjs(k)=DAobjs(k).DoseBinInXlsraw();
                        g=find(DAobjs(k).DoseCols);
                        DAobjs(k).DoseBins(g(1))=0;
                        DAobjs(k).DoseCols(g(1))=false; % the first data in the disequal(DAobj1.lnn,DAobj2.lnn)ose bins is not dose, remove it.
                        
                        DAobjs(k)=DAobjs(k).CalculateEUDFromDVH();
                        
                        DAobjs(k)=DAobjs(k).ComplicationInXlsraw();
                        DAobjs(k).ComplicationRows=DAobjs(k).ComplicationRows&DAobjs(k).PatientRows;
                        DAobjs(k).ComplicationGrade(~DAobjs(k).ComplicationRows)=0;% only patients in ptcode are considered
                        
                        DAobjs(k)=DAobjs(k).AtlasStatistics();
                        DAobjs(k)=DAobjs(k).BetaCumulativeProbability();
                        DAobjs(k)=DAobjs(k).BetaInverseProbability();
                        DAobjs(k)=DAobjs(k).LogisticRegressionAnalysis();
                        
%                         DAobjs(k).WriteXls();

                    catch ME
                        disp(ME.message);
                        d(k)=true;
                    end
                end
                save(xlsFile,'DAobjs');
            end
            DAnki=[DAnki;DAobjs];

%% MSK
            % .xls file
            xlsFile='G:/MSKCC/Andy/2009R01/tom/MSK_EUD';
            if isunix
                xlsFile=strrep(xlsFile,'G:','/media/SKI_G');
            end
            
            % load analysis result or compute it
            try
                error;
                load(xlsFile,'DAobjs');
            catch
                % read all the sheets
                xlsFile1=strrep(xlsFile,'tom','meta');
                try
                    load(xlsFile1);
                catch
                    xlsData=xlsFileRead(xlsFile1);
                    save(xlsFile1,'xlsData');
                end

                % adjust DVH2Atlas object
                DAobj.xlsFile_input=xlsFile1;
                DAobj.xlsFile_output=strcat(xlsFile,'_tom');
                DAobj.flgColInput=true;
                DAobj.flgColOutput=false;
                DAobj.PatientColName='surname'; % patient code column name
                DAobj.DoseRowName='logn:';
                DAobj.ComplicationColName='gt gd3'; % complication column name
                DAobj.ComplicationThreshold=1; % the grade that is deemed as severe
                DAobj.BetaCumulativeThreshold=0.2;
                DAobj.BetaInverseThreshold=0.16;

                % sheet by sheet
                DAobjs=repmat(DAobj,[length(xlsData),1]);
                d=false(length(xlsData),1);
                for k=1:length(xlsData)
                    try
                        DAobjs(k).xlsSheet=xlsData(k).SheetName; disp(DAobjs(k).xlsSheet);
                        DAobjs(k)=DAobjs(k).AssignXlsSheet(xlsData(k).xlsRaw);
                        
                        DAobjs(k)=DAobjs(k).PatientCodeInXlsraw();
                        DAobjs(k)=DAobjs(k).DoseBinInXlsraw();
                        DAobjs(k).lnn=DAobjs(k).DoseBins(DAobjs(k).DoseCols)';
                        
                        DAobjs(k)=DAobjs(k).CalculateEUDFromDVH();
                        DAobjs(k).EUD=DAobjs(k).DVH;
%                         DAobjs(k).EUD(DAobjs(k).PatientNaN,:)=-1;
                        DAobjs(k).EUD(~DAobjs(k).PatientRows,:)=-1;
                        DAobjs(k).EUD(:,~DAobjs(k).DoseCols)=[];
                        
                        DAobjs(k)=DAobjs(k).ComplicationInXlsraw();
                        DAobjs(k).ComplicationRows=DAobjs(k).ComplicationRows&DAobjs(k).PatientRows;
                        DAobjs(k).ComplicationGrade(~DAobjs(k).ComplicationRows)=0;% only patients in ptcode are considered
                        
                        DAobjs(k)=DAobjs(k).AtlasStatistics();
                        DAobjs(k)=DAobjs(k).BetaCumulativeProbability();
                        DAobjs(k)=DAobjs(k).BetaInverseProbability();
                        DAobjs(k)=DAobjs(k).LogisticRegressionAnalysis();
                        
%                         DAobjs(k).WriteXls();
                    catch ME
                        disp(ME.message);
                    end
                end
                save(xlsFile,'DAobjs');
            end
            DAmsk=DAobjs;

%% combine nki and msk data    
    % .xls file
    xlsFile='G:/MSKCC/Andy/2009R01/tom/MSK_NKI_Atlas';
    if isunix
        xlsFile=strrep(xlsFile,'G:','/media/SKI_G');
    end
    
    % load analysis result or compute it
    try
        error;
        load(xlsFile,'DAobjs');
    catch
        % matching pairs
        matchpairs={
            'Whole','Whole'
            'Contra','contra'
            'Ipsi','ipsi'
            'Superior','cranial'
            'Inferior','caudal'
            };
    
        % adjust DVH2Atlas object
        DAobj.xlsFile_output=strcat(xlsFile,'_tom');
        DAobj.BetaCumulativeThreshold=0.2;
        DAobj.BetaInverseThreshold=0.16;
        DAobj.GyStep=0.5;

        % comine pairs one by one
        DAobjs=repmat(DAobj,[size(matchpairs,1),1]);
        for k=1:size(matchpairs,1)
            try
                % locate the sheet in each set
                    [~,fmsk]=ismember(matchpairs{k,1},{DAmsk.xlsSheet});
                    [~,fnki]=ismember(matchpairs{k,2},{DAnki.xlsSheet});
                    if isequal(fmsk,0) || isequal(fnki,0)
                        error(['one of the matching pair ',matchpairs{k,:},' not found in atlas data set']);
                    end
            
                % combine the data set
                    DAobjs(k)=DAobjs(k).CombineAtlas(DAmsk(fmsk),DAnki(fnki));
%                     
%                     
%                     DAobjs(k).xlsSheet=DAmsk(fmsk).xlsSheet;
%                     DAobjs(k).EUD=[DAmsk(fmsk).EUD;DAnki(fnki).EUD];
%                     DAobjs(k).PatientCode=[DAmsk(fmsk).PatientCode; DAnki(fnki).PatientCode];
%                     DAobjs(k).PatientRows=[DAmsk(fmsk).PatientRows; DAnki(fnki).PatientRows];
%                     sizemsk=size(DAmsk(fmsk).PatientTotal); sizenki=size(DAnki(fnki).PatientTotal);
%                     DAobjs(k).PatientTotal=zeros(max(sizemsk,sizenki));
%                     DAobjs(k).PatientTotal(1:sizemsk(1),1:sizemsk(2))=DAmsk(fmsk).PatientTotal;
%                     DAobjs(k).PatientTotal(1:sizenki(1),1:sizenki(2))=DAobjs(k).PatientTotal(1:sizenki(1),1:sizenki(2))+DAnki(fnki).PatientTotal;
%                     DAobjs(k).PatientComp=zeros(max(sizemsk,sizenki));
%                     DAobjs(k).PatientComp(1:sizemsk(1),1:sizemsk(2))=DAmsk(fmsk).PatientComp;
%                     DAobjs(k).PatientComp(1:sizenki(1),1:sizenki(2))=DAobjs(k).PatientComp(1:sizenki(1),1:sizenki(2))+DAnki(fnki).PatientComp;
%                     % compute probabilities
%                     DAobjs(k)=DAobjs(k).BetaCumulativeProbability();
%                     DAobjs(k)=DAobjs(k).BetaInverseProbability();
%                     DAobjs(k)=DAobjs(k).LogisticRegressionAnalysis();
                        
                    DAobjs(k).WriteXls();
            catch ME
                disp(ME.message);
            end
        end
        save(xlsFile,'DAobjs');
    end
    DAcom=DAobjs;
    
% %% logistic regression
%     LRstruct=struct('b',[],'dev',[],'stats',[]);
%     % MSK
%         lnn=DAmsk(1).lnn;
%         lrmsk=repmat(LRstruct,[length(lnn),length(DAmsk)]);
%         for m=1:length(DAmsk)
%             doses=(0:size(DAmsk(m).PatientTotal,1)-1)'*DAmsk(m).GyStep;
%             try
%                 for k=1:length(lnn)
%                     pttotal=DAmsk(m).PatientTotal(:,k); pttotal=abs(diff(pttotal)); f=find(pttotal); ptcomp=DAmsk(m).PatientComp(:,k); ptcomp=abs(diff(ptcomp));
%                     [b,dev,s]=glmfit(doses(1:end-1),[ptcomp pttotal],'binomial','link','logit');
%                     
%                     [bf,devf,sf]=glmfit(doses(f),[ptcomp(f) pttotal(f)],'binomial','link','logit');
%                     if ~(isequal(b,bf) && isequal(dev,devf) && isequal(s,sf))
%                         disp('OK');
%                     end
%                     lrmsk(k,m).b=b; lrmsk(k,m).dev=dev; lrmsk(k,m).stats=s;
%                     figure(1); plot(doses(1:end-1),ptcomp./pttotal,'x'); hold on; plot(doses,glmval(b,doses,'logit'),'r-'); hold off; title([DAnki(m).xlsSheet,' ln(n)=',num2str(lnn(k))]);
%                 end
%             catch ME
%                 disp(DAnki(m).xlsSheet); disp(ME.message);
%             end
%             figure(2); plot(lnn',[lrmsk(:,m).dev],'.-')
%         end
%         % save result
%         xlsFile='G:/MSKCC/Andy/2009R01/tom/MSK_LogisticReg_tom';
%         if isunix
%             xlsFile=strrep(xlsFile,'G:','/media/SKI_G');
%         end
%         LR=lrmsk;
%         save(xlsFile,'LR');
%         
%     % NKI
%         lnn=DAnki(1).lnn;
%         lrnki=repmat(LRstruct,[length(lnn),length(DAnki)]);
%         for m=1:length(DAnki)
%             doses=(0:size(DAnki(m).PatientTotal,1)-1)'*DAnki(m).GyStep;
%             try
%                 for k=1:length(lnn)
%                     pttotal=DAnki(m).PatientTotal(:,k); f=find(pttotal>0); ptcomp=DAnki(m).PatientComp(:,k);
%                     [b,dev,s]=glmfit(doses(f),[ptcomp(f) pttotal(f)],'binomial','link','logit');
%                     lrnki(k,m).b=b; lrnki(k,m).dev=dev; lrnki(k,m).stats=s;
%                     plot(doses(f),ptcomp(f)./pttotal(f),'x'); hold on; plot(doses(f),glmval(b,doses(f),'logit'),'r-'); hold off; title([DAnki(m).xlsSheet,' ln(n)=',num2str(lnn(k))]);
%                 end
%             catch ME
%                 disp(DAnki(m).xlsSheet); disp(ME.message);
%             end
%         end
%         % save result
%         xlsFile='G:/MSKCC/Andy/2009R01/tom/NKI_LogisticReg_tom';
%         if isunix
%             xlsFile=strrep(xlsFile,'G:','/media/SKI_G');
%         end
%         LR=lrnki;
%         save(xlsFile,'LR');
%         
%     % MSK and NKI combined
%         lnn=DAcom(1).lnn;
%         lrcom=repmat(LRstruct,[length(lnn),length(DAcom)]);
%         for m=1:length(DAcom)
%             doses=(0:size(DAcom(m).PatientTotal,1)-1)'*DAcom(m).GyStep;
%             try
%                 for k=1:length(lnn)
%                     pttotal=DAcom(m).PatientTotal(:,k); f=find(pttotal>0); ptcomp=DAcom(m).PatientComp(:,k);
%                     [b,dev,s]=glmfit(doses(f),[ptcomp(f) pttotal(f)],'binomial','link','logit');
%                     lrcom(k,m).b=b; lrcom(k,m).dev=dev; lrcom(k,m).stats=s;
%                     plot(doses,ptcomp./pttotal,'x'); hold on; plot(doses,glmval(b,doses,'logit'),'r-'); hold off; title([DAnki(m).xlsSheet,' ln(n)=',num2str(lnn(k))]);
%                 end
%             catch ME
%                 disp(DAnki(m).xlsSheet); disp(ME.message);
%             end
%         end
%         % save result
%         xlsFile='G:/MSKCC/Andy/2009R01/tom/MSK_NKI_LogisticReg_tom';
%         if isunix
%             xlsFile=strrep(xlsFile,'G:','/media/SKI_G');
%         end
%         LR=lrcom;
%         save(xlsFile,'LR');
        
toc;