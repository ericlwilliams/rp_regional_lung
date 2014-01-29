function LogEudAtlasAnalysis
tic;
    flglog = 0; % 1 -- atlas for log10(EUD), 0 -- atlas for EUD
    
    if flglog
        dosestep = 0.01; % in Gy
    else
        dosestep = 1; % in Gy
    end
    
    
%% NKI data
    try
        error;
            xlsFile = 'G:/MSKCC/Andy/2009R01/tom/NKI_logDoseBins';
            if isunix
                xlsFile=strrep(xlsFile,'G:','/media/SKI_G');
            end
            load(xlsFile,'CGobjs','xlsSheets');
            CGnki = CGobjs;
            xlsSheetnki = xlsSheets;
    catch
    % patients with DE numbers and with both lungs
        % .xls file and sheet
        xlsFile='G:/MSKCC/Andy/2009R01/meta/NSCLC_all_rev (2)'; xlsSheet='Whole'; % file and sheet info
        if isunix
            xlsFile=strrep(xlsFile,'G:','/media/SKI_G');
        end
        try
            load(xlsFile,'xlsData');
        catch
            xlsData=xlsFileRead(xlsFile);
            save(xlsFile,'xlsData');
        end
        
        PtInfo=classDataFromXls();
        f=cellfun(@(x) strcmpi(x,xlsSheet),{xlsData.SheetName});
        if all(~f)
            error('The sheet name is not found in xlsFile');
        end
        PtInfo.xlsRaw=xlsData(f).xlsRaw;
        % patient code
        PtInfo.ColName = 'LFOnumber';
        PtInfo = PtInfo.ExtractColData();
        ptcode = PtInfo.ColData;
        flg = PtInfo.flgDataRows;
        % select patient with non-zero DE number
        PtInfo.ColName = 'DEnumber';
        PtInfo = PtInfo.ExtractColData();
        flg = flg & PtInfo.flgDataRows;
        % remove patients with one lung only
        PtInfo.ColName = 'Tumor position/One lung';
        PtInfo = PtInfo.ExtractColData();
        f = cellfun(@(x) strcmpi(x,'one lung'),PtInfo.ColData);
        flg(f) = 0;
        ptcode = ptcode(flg);
        f = cellfun(@(x) ischar(x),ptcode);
        ptcode(~f) = cellfun(@(x) num2str(x),ptcode(~f), 'UniformOutput',false);
        % complication status
        PtInfo.ColName = 'Max RP grade';
        PtInfo = PtInfo.ExtractColData();
        ptcomp = PtInfo.ColData(flg&PtInfo.flgDataRows);
        % check data integrity
        if any(cellfun('isempty',ptcode)) || any(cellfun('isempty',ptcomp)) ...
                || any(cellfun(@(x) strcmp(x,'NaN'), ptcode)) || any(cellfun(@(x) isnan(x), ptcomp)) ...
                || length(ptcode)~=length(ptcomp)
            error('patient code or complication is empty, nan, or they are not matching (in number of patients/complications)');
        end
        ptcomp = cell2mat(ptcomp) < 2; % 1 - censored patient

    % patient EUD atlas
        CGobj=classComplicationGroup(); % prepare an instance
        CGobj.DoseStep_EUD = dosestep;
        % whole lung
            % select the right sheet
            xlsSheet = 'Whole';
            f=cellfun(@(x) strcmpi(x,xlsSheet),{xlsData.SheetName});
            if all(~f)
                error('The sheet name is not found in xlsFile');
            end
            PtInfo.xlsRaw=xlsData(f).xlsRaw;
            % the dosebins in the sheet
            PtInfo.RowName = '#fractions (fraction size: 2.25 Gy';
            PtInfo = PtInfo.ExtractRowData();
            flgDose = PtInfo.flgDataCols;
            dosebins = cell2mat(PtInfo.RowData(flgDose));
            dosebins = dosebins - dosebins(1); % shift it so the dose is at the left edge

            % patient code in the sheet
            PtInfo.ColName = 'LFOnumber';
            PtInfo = PtInfo.ExtractColData();
            pt = PtInfo.ColData;
            flgpt = PtInfo.flgDataRows;
            % index for the patients selected above only
            g1 = cellfun(@(x) ischar(x), pt);
            pt(~g1) = cellfun(@(x) num2str(x), pt(~g1),'UniformOutput',false);
            [g1 g2] = ismember(pt,ptcode);
            flgpt = flgpt & g1;
            % populate the DVH info of each remaining patient to the objects
            f=find(flgpt);
            CIobjs = classComplicationIndividual.empty(length(f),0);
            flg = true(length(f),1);
            for k = 1:length(f)
                CIobjs(k).PatientID = pt{f(k)};
                CIobjs(k).flgCensor = ptcomp(g2(f(k)));
                CIobjs(k).DoseBins_org = dosebins;
                voldiff = PtInfo.xlsRaw(f(k),flgDose);
                if any(cellfun(@(x) isnan(x), voldiff))
                    flg(k) = false;
                    continue;
                end
                CIobjs(k).VolDiff = cell2mat(voldiff);
                CIobjs(k).FxNum = 1;
            end
            CIobjs = CIobjs(flg); % remove empty volume cell patients
            % add the patients to the CGobj
            CGobj = CGobj.AddPatient(CIobjs);
            % EUD computation
            CGobj = CGobj.LinearQuartraticCorrection(); % since beta/alpha=0, the correction passes the doses directly.
            CGobj = CGobj.CalculateEUD(); % EUD computation
            % prepare dosebins for atlas
            if flglog
                CGobj = CGobj.CalculateDoseBinsLog_EUD(); % dose bins in log scales
            else
                CGobj = CGobj.CalculateDoseBins_EUD(); % dose bins in linear scales
            end

            % atlas
            CGobj = CGobj.CrudeAtlas_EUD();
            CGobj = CGobj.BetaCumulativeProbability_EUD();
            CGobj = CGobj.BetaInverseProbability_EUD();
            CGobj = CGobj.LogisticRegressionAnalysisExact_EUD();
            CGobj = CGobj.LogisticRegressionAnalysisBin_EUD();

%             % save result
%             xlsFile = 'G:/MSKCC/Andy/2009R01/tom/NKI_WholeLung_logDoseBins';
%             if isunix
%                 xlsFile=strrep(xlsFile,'G:','/media/SKI_G');
%             end
%             save(xlsFile,'CGobj','xlsSheets');
            
        % partial lung
            % .xls file
            xlsFile='G:/MSKCC/Andy/2009R01/meta/DvhRegios';
            if isunix
                xlsFile=strrep(xlsFile,'G:','/media/SKI_G');
            end
            
            % load analysis result or compute it
                % read all the sheets
                try
                    load(xlsFile);
                catch
                    xlsData=xlsFileRead(xlsFile);
                    save(xlsFile,'xlsData');
                end
                numSheets = length(xlsData) + 1;  % +1 to allocate for the whole lung

                % sheet by sheet
                xlsSheets = cell(numSheets,1);
                CGobjs = classComplicationGroup();
                CGobjs = repmat(CGobjs,[numSheets,1]);
                xlsSheets{1} = xlsSheet; % save the "whole" lung atlas result
                CGobjs(1) = CGobj;
                flgsheets=true(numSheets,1);
                for k = 2:numSheets
                    try
                        disp(xlsData(k-1).SheetName);
                        % load sheet info
                        xlsSheets{k} = xlsData(k-1).SheetName;
                        PtInfo.xlsRaw = xlsData(k-1).xlsRaw;
                        % the dosebins in the sheet
                        PtInfo.RowName = 'Dosebins(Gy):';
                        PtInfo = PtInfo.ExtractRowData();
                        flgDose = PtInfo.flgDataCols;
                        dosebins = cell2mat(PtInfo.RowData(flgDose));
                        dosebins = dosebins - dosebins(1); % shift it so the dose is at the left edge

                        % patient code
                        PtInfo.ColName = 'lfonr';
                        PtInfo = PtInfo.ExtractColData();
                        pt = PtInfo.ColData;
                        flgpt = PtInfo.flgDataRows;
                        % index for the patients selected above only
                        g1 = cellfun(@(x) ischar(x), pt);
                        pt(~g1) = cellfun(@(x) num2str(x), pt(~g1),'UniformOutput',false);
                        [g1 g2]= ismember(pt,ptcode);
                        flgpt = flgpt & g1;
                        % populate the DVH info of each remaining patient to the objects
                        f=find(flgpt);
                        CIobjs = classComplicationIndividual.empty(length(f),0);
                        flg = true(length(f),1);
                        for m = 1:length(f)
                            CIobjs(m).PatientID = pt{f(m)};
                            CIobjs(m).flgCensor = ptcomp(g2(f(m)));
                            CIobjs(m).DoseBins_org = dosebins;
                            voldiff = PtInfo.xlsRaw(f(m),flgDose);
                            if any(cellfun(@(x) isnan(x), voldiff))
                                flg(m) = false;
                                continue;
                            end
                            CIobjs(m).VolDiff = cell2mat(voldiff);
                            CIobjs(m).FxNum = 1;
                        end
                        CIobjs = CIobjs(flg); % remove empty volume cell patients
                        % add the patients to the CGobj
                        CGobj = CGobj.RemovePatient(); % remove old patient info first
                        CGobj = CGobj.AddPatient(CIobjs);
                        % EUD computation
                        CGobj = CGobj.LinearQuartraticCorrection(); % since beta/alpha=0, the correction passes the doses directly.
                        CGobj = CGobj.CalculateEUD(); % EUD computation
                        % prepare dosebins for atlas
                        if flglog
                            CGobj = CGobj.CalculateDoseBinsLog_EUD(); % dose bins in log scales
                        else
                            CGobj = CGobj.CalculateDoseBins_EUD(); % dose bins in linear scales
                        end

                        % atlas
                        CGobj = CGobj.CrudeAtlas_EUD();
                        CGobj = CGobj.BetaCumulativeProbability_EUD();
                        CGobj = CGobj.BetaInverseProbability_EUD();
                        CGobj = CGobj.LogisticRegressionAnalysisExact_EUD();
                        CGobj = CGobj.LogisticRegressionAnalysisBin_EUD();

                        % save result
                        CGobjs(k) = CGobj;
                    catch ME
                        flgsheets(k)=false;
                        disp(ME); disp(ME.message);
                        for errcount=1:length(ME.stack)
                            disp(ME.stack(errcount));
                        end
                    end
                end
                CGobjs=CGobjs(flgsheets); xlsSheets=xlsSheets(flgsheets);
                
            % save result
            if flglog
                xlsFile = 'G:/MSKCC/Andy/2009R01/tom/NKI_logDoseBins';
            else
                xlsFile = 'G:/MSKCC/Andy/2009R01/tom/NKI_linearDoseBins';
            end
            if isunix
                xlsFile=strrep(xlsFile,'G:','/media/SKI_G');
            end
            save(xlsFile,'CGobjs','xlsSheets');
            
            CGnki = CGobjs;
            xlsSheetnki = xlsSheets;
    end

%% MSK
    try
        error;
            xlsFile = 'G:/MSKCC/Andy/2009R01/tom/MSK_logDoseBins';
            if isunix
                xlsFile=strrep(xlsFile,'G:','/media/SKI_G');
            end
            load(xlsFile,'CGobjs','xlsSheets');
            
            CGmsk = CGobjs;
            xlsSheetmsk = xlsSheets;
    catch
            % .xls file
            xlsFile='G:/MSKCC/Andy/2009R01/meta/MSK_EUD';
            if isunix
                xlsFile=strrep(xlsFile,'G:','/media/SKI_G');
            end
            
            % read all the sheets
                try
                    load(xlsFile);
                catch
                    xlsData=xlsFileRead(xlsFile);
                    save(xlsFile,'xlsData');
                end
                numSheets = length(xlsData);

                % sheet by sheet
                xlsSheets = cell(numSheets,1);
                CGobjs = classComplicationGroup();
                CGobjs = repmat(CGobjs,[numSheets,1]);
                CGobj = classComplicationGroup();
                CGobj.DoseStep_EUD = dosestep;
                PtInfo=classDataFromXls();
                flgsheets=true(numSheets,1);
                for k=1:numSheets
                    try
                        disp(xlsData(k).SheetName);
                        % load sheet info
                        xlsSheets{k} = xlsData(k).SheetName;
                        PtInfo.xlsRaw = xlsData(k).xlsRaw;
                        % patient code
                        PtInfo.ColName = 'MRN,';
                        PtInfo = PtInfo.ExtractColData();
                        fpt=find(PtInfo.flgDataRows);
                        pt = PtInfo.ColData;
                        % complication
                        PtInfo.ColName = 'gt gd3';
                        PtInfo = PtInfo.ExtractColData();
                        if ~isequal(fpt,find(PtInfo.flgDataRows))
                            error('patient code and complication info not match');
                        end
                        ptcomp = false(size(PtInfo.ColData,1),1);
                        ptcomp(PtInfo.flgDataRows) = cell2mat(PtInfo.ColData(PtInfo.flgDataRows));
                        ptcomp = ~ptcomp; % 1 - censored
                        % the log10(n) values in the sheet
                        PtInfo.RowName = 'gt gd3';
                        PtInfo = PtInfo.ExtractRowData();
                        flgLnn = cellfun(@(x) ischar(x),PtInfo.RowData);
                        flgLnn = ~flgLnn & PtInfo.flgDataCols;
                        CGobj.lgn = cell2mat(PtInfo.RowData(flgLnn));
                        % EUD matrix
                        CIobjs = classComplicationIndividual.empty(length(fpt),0);
                        for m = 1:length(fpt)
                            CIobjs(m).PatientID = pt{fpt(m)};
                            CIobjs(m).EUD = cell2mat(PtInfo.xlsRaw(fpt(m),flgLnn))';
                            CIobjs(m).flgCensor = ptcomp(fpt(m));
                        end
                        % add the patients to the CGobj
                        CGobj = CGobj.RemovePatient(); % remove old patient info first
                        CGobj = CGobj.AddPatient(CIobjs);
                        % prepare dosebins for atlas
                        if flglog
                            CGobj = CGobj.CalculateDoseBinsLog_EUD(); % dose bins in log scales
                        else
                            CGobj = CGobj.CalculateDoseBins_EUD(); % dose bins in linear scales
                        end

                        % atlas
                        CGobj = CGobj.CrudeAtlas_EUD();
                        CGobj = CGobj.BetaCumulativeProbability_EUD();
                        CGobj = CGobj.BetaInverseProbability_EUD();
                        CGobj = CGobj.LogisticRegressionAnalysisExact_EUD();
                        CGobj = CGobj.LogisticRegressionAnalysisBin_EUD();

                        % save result
                        CGobjs(k) = CGobj;

                    catch ME
                        flgsheets(k)=false;
                        disp(ME); disp(ME.message);
                        for errcount=1:length(ME.stack)
                            disp(ME.stack(errcount));
                        end
                    end
                end
                CGobjs=CGobjs(flgsheets); xlsSheets=xlsSheets(flgsheets);
            % save result
            if flglog
                xlsFile = 'G:/MSKCC/Andy/2009R01/tom/MSK_logDoseBins';
            else
                xlsFile = 'G:/MSKCC/Andy/2009R01/tom/MSK_linearDoseBins';
            end
            if isunix
                xlsFile=strrep(xlsFile,'G:','/media/SKI_G');
            end
            save(xlsFile,'CGobjs','xlsSheets');
            
            CGmsk = CGobjs;
            xlsSheetmsk = xlsSheets;
    end

%% combine nki and msk data
    % matching pairs
        matchpairs={
            'Whole','Whole'
            'Contra','contra'
            'Ipsi','ipsi'
            'Superior','cranial'
            'Inferior','caudal'
            }; % msk, nki
        numSheets = size(matchpairs,1);
    
        % comine pairs one by one
        CGobjs = classComplicationGroup.empty(numSheets,0);
        xlsSheets = cell(numSheets,1);
        for k=1:numSheets
            try
                        disp(matchpairs{k,2});
                % locate the sheet in each set
                    [~,fmsk]=ismember(matchpairs{k,1},xlsSheetmsk);
                    [~,fnki]=ismember(matchpairs{k,2},xlsSheetnki);
                    if isequal(fmsk,0) || isequal(fnki,0)
                        error(['one of the matching pair ',matchpairs{k,:},' not found in atlas data set']);
                    end
            
                % combine the data set
                    CGobj = classComplicationGroup.CombineAtlas_EUD(CGmsk(fmsk),CGnki(fnki));
                    CGobj = CGobj.BetaCumulativeProbability_EUD();
                    CGobj = CGobj.BetaInverseProbability_EUD();
                    CGobj = CGobj.LogisticRegressionAnalysisExact_EUD();
                    CGobj = CGobj.LogisticRegressionAnalysisBin_EUD();
                    CGobjs(k) = CGobj;
                    
                    xlsSheets{k} = matchpairs{k,1};
            catch ME
                disp(ME.message);
            end
        end
        
        if flglog
            xlsFile = 'G:/MSKCC/Andy/2009R01/tom/MSK_NKI_logDoseBins';
        else
            xlsFile = 'G:/MSKCC/Andy/2009R01/tom/MSK_NKI_linearDoseBins';
        end
        if isunix
            xlsFile=strrep(xlsFile,'G:','/media/SKI_G');
        end
        save(xlsFile,'CGobjs','xlsSheets');
toc;