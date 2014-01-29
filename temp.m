function temp
tic;
    logstep = 0.5; % in Gy

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


        CGobj=classComplicationGroup(); % prepare an instance
        CGobj.DoseStep_EUD = logstep;
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
                numSheets = length(xlsData);

                % sheet by sheet
                xlsSheets = cell(numSheets,1);
                CGobjs = classComplicationGroup.empty(numSheets,0);
                for k = 1:numSheets
                    try
                        disp(xlsData(k).SheetName);
                        % load sheet info
                        xlsSheets{k} = xlsData(k).SheetName;
                        PtInfo.xlsRaw = xlsData(k).xlsRaw;
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
                        % complication info
                        PtInfo.ColName = 'RP grade';
                        PtInfo = PtInfo.ExtractColData();
                        cp = zeros( size(PtInfo.flgDataRows) );
                        cp(PtInfo.flgDataRows&flgpt) = cell2mat(PtInfo.ColData(flgpt&PtInfo.flgDataRows));
                        cp = cp<2; % censored patients
                        % the dosebins in the sheet
                        PtInfo.RowName = 'Dosebins(Gy):';
                        PtInfo = PtInfo.ExtractRowData();
                        flgDose = PtInfo.flgDataCols;
                        dosebins = cell2mat(PtInfo.RowData(flgDose));
                        dosebins = dosebins - dosebins(1); % shift it so the dose is at the left edge
                        % populate the DVH info of each remaining patient to the objects
                        f = find(flgpt);
                        CIobjs = classComplicationIndividual.empty(length(f),0);
                        flg = true(length(f),1);
                        for m = 1:length(f)
                            CIobjs(m).PatientID = pt{f(m)};
                            CIobjs(m).DoseBins_org = dosebins;
                            voldiff = PtInfo.xlsRaw(f(m),flgDose);
                            if any(cellfun(@(x) isnan(x), voldiff))
                                flg(m) = false;
                                continue;
                            end
                            CIobjs(m).VolDiff = cell2mat(voldiff);
                            CIobjs(m).FxNum = 1;
                            CIobjs(m).flgCensor = cp(f(m));
                        end
                        CIobjs = CIobjs(flg); % remove empty volume cell patients
                        % add the patients to the CGobj
                        CGobj = CGobj.RemovePatient(); % remove old patient info first
                        CGobj = CGobj.AddPatient(CIobjs);
                        % EUD computation
                        CGobj = CGobj.LinearQuartraticCorrection(); % since beta/alpha=0, the correction passes the doses directly.
                        CGobj = CGobj.CalculateEUD(); % EUD computation
                        % prepare dosebins for atlas
                        CGobj = CGobj.CalculateDoseBinsLog_EUD(); % dose bins in log scales

            CGobj = CGobj.CalculateDoseBins_EUD(); % dose bins in log scales
            
                        % atlas
                        CGobj = CGobj.CrudeAtlas_EUD();
                        CGobj = CGobj.BetaCumulativeProbability_EUD();
                        CGobj = CGobj.BetaInverseProbability_EUD();
                        CGobj = CGobj.LogisticRegressionAnalysis_EUD();

                        % save result
                        CGobjs(k) = CGobj;
                    catch ME
                        disp(ME); disp(ME.message);
                        for errcount=1:length(ME.stack)
                            disp(ME.stack(errcount));
                        end
                    end
                end
                
            % save result
            xlsFile = 'G:/MSKCC/Andy/2009R01/tom/NKI_logDoseBins';
            if isunix
                xlsFile=strrep(xlsFile,'G:','/media/SKI_G');
            end
            save(xlsFile,'CGobjs','xlsSheets');
toc;