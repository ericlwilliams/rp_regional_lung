function LogEudAtlasAnalysis_MSK_rl
tic;
    flglog = false; % 1 -- atlas for log10(EUD), 0 -- atlas for EUD
    
    if flglog
        dosestep = 0.01; % in Gy
    else
        dosestep = 0.5; % in Gy
    end
    
    
%% MSK
    % left and right info
        % load file
        xlsFile='G:/MSKCC/Andy/2009R01/meta/Lt_rt_2004';
        if isunix
            xlsFile=strrep(xlsFile,'G:','/media/SKI_G');
        end
        try
            load(xlsFile);
        catch
            xlsData=xlsFileRead(xlsFile);
            save(xlsFile,'xlsData');
        end

        % info in the .xls file
        ptlr=classDataFromXls(); % patient info about left and right target
        ptlr.xlsRaw = xlsData(1).xlsRaw;
        ptlr.ColName='Patient'; % patient surname
        ptlr=ptlr.ExtractColData();
        ptsur=ptlr.ColData(ptlr.flgDataRows);
        ptsur=cellfun(@(x) lower(x),ptsur,'UniformOutput',false);
        ptlr.ColName='MRN'; % patient mrn number
        ptlr=ptlr.ExtractColData();
        ptmrn=ptlr.ColData(ptlr.flgDataRows);
        f=cellfun(@(x) ischar(x),ptmrn);
        ptmrn(~f)=cellfun(@(x) num2str(x),ptmrn(~f),'UniformOutput',false);
        ptlr.ColName='g3'; % complication or not
        ptlr=ptlr.ExtractColData();
        ptcomp=~logical(cell2mat(ptlr.ColData(ptlr.flgDataRows)));
        ptlr.ColName='targetloc'; % target left or right
        ptlr=ptlr.ExtractColData();
        pttgt=ptlr.ColData(ptlr.flgDataRows);
        flgleft=cellfun(@(x) x(1)=='L',pttgt);

	% EUD .xls file
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
        
        % ipsi sheet
        [~,f]=ismember('Ipsi',{xlsData.SheetName});
        ptlr.xlsRaw = xlsData(f).xlsRaw;

        ptlr.ColName = 'gt gd3'; % complication
        ptlr=ptlr.ExtractColData();
        ipsicomp=~logical(cell2mat(ptlr.ColData(ptlr.flgDataRows)));
        ptlr.ColName = 'surname'; % surname
        ptlr=ptlr.ExtractColData();
        ipsisur=ptlr.ColData(ptlr.flgDataRows);
        ipsisur=cellfun(@(x) lower(x(1:end-1)),ipsisur,'UniformOutput',false);
        ptlr.ColName = 'MRN,'; % patient mrn
        ptlr=ptlr.ExtractColData();
        ipsimrn=ptlr.ColData(ptlr.flgDataRows);
        f=cellfun(@(x) ischar(x),ipsimrn);
        ipsimrn(~f)=cellfun(@(x) num2str(x),ipsimrn(~f),'UniformOutput',false);
        ptlr.RowName = 'gt gd3'; % lnn for EUD
        ptlr=ptlr.ExtractRowData();
        f = cellfun(@(x) ischar(x),ptlr.RowData);
        f = ~f & ptlr.flgDataCols;
        ipsilnn=cell2mat(ptlr.RowData(f));
        ipsiEUD = cell2mat( ptlr.xlsRaw(ptlr.flgDataRows, f) ); % EUD

        % contra sheet
        [~,f]=ismember('Contra',{xlsData.SheetName});
        ptlr.xlsRaw = xlsData(f).xlsRaw;

        ptlr.ColName = 'gt gd3'; % complication
        ptlr=ptlr.ExtractColData();
        contracomp=~logical(cell2mat(ptlr.ColData(ptlr.flgDataRows)));
        ptlr.ColName = 'surname'; % surname
        ptlr=ptlr.ExtractColData();
        contrasur=ptlr.ColData(ptlr.flgDataRows);
        contrasur=cellfun(@(x) lower(x(1:end-1)),contrasur,'UniformOutput',false);
        ptlr.ColName = 'MRN,'; % patient mrn
        ptlr=ptlr.ExtractColData();
        contramrn=ptlr.ColData(ptlr.flgDataRows);
        f=cellfun(@(x) ischar(x),contramrn);
        contramrn(~f)=cellfun(@(x) num2str(x),contramrn(~f),'UniformOutput',false);
        ptlr.RowName = 'gt gd3'; % lnn for EUD
        ptlr=ptlr.ExtractRowData();
        f = cellfun(@(x) ischar(x),ptlr.RowData);
        f = ~f & ptlr.flgDataCols;
        contralnn=cell2mat(ptlr.RowData(f));
        contraEUD = cell2mat( ptlr.xlsRaw(ptlr.flgDataRows, f) ); % EUD

	% data integrity
        % ipsi vs. contra
        if ~(isequal(ipsimrn,contramrn) && isequal(ipsicomp, contracomp) && isequal(ipsisur,contrasur) && isequal(ipsilnn,contralnn))
            error('data in the MSK is not integrity')
        end
        % ipsi vs left&right
        % mrn
        [f,g]=ismember(ptmrn,ipsimrn);
        if ~(all(f) && all(g))
            error('MRN in the left&right .xls does not match with ipsi sheet');
        end
        % adjust order of ipsi sheet
        ipsimrn=ipsimrn(g); ipsicomp=ipsicomp(g); ipsisur=ipsisur(g); ipsiEUD=ipsiEUD(g,:);
        % check integrity again
        if ~(isequal(ptcomp,ipsicomp))% && isequal(ptsur,ipsisur))
            error('Complication in the left&right .xls does not match with ipsi sheet');
        end
        
        % contra vs left&right
        % mrn
        [f,g]=ismember(ptmrn,contramrn);
        if ~(all(f) && all(g))
            error('MRN in the left&right .xls does not match with contra sheet');
        end
        % adjust order of contra sheet
        contramrn=contramrn(g); contracomp=contracomp(g); contrasur=contrasur(g); contraEUD=contraEUD(g,:);
        % check integrity again
        if ~(isequal(ptcomp,contracomp)) % && isequal(ptsur,contrasur))
            error('Complication in the left&right .xls does not match with contra sheet');
        end

	% populate the EUDs to individuals
        numpt=size(ptmrn,1);
        %ipsi
        CIipsi = classComplicationIndividual.empty(numpt,0);
        for k = 1:numpt
            CIipsi(k).PatientID = ipsimrn{k};
            CIipsi(k).flgCensor = ipsicomp(k);
            CIipsi(k).lnn= ipsilnn;
            CIipsi(k).FxNum = 1;
            CIipsi(k).EUD = ipsiEUD(k,:)';
        end
        % contra
        CIcontra = classComplicationIndividual.empty(numpt,0);
        for k = 1:numpt
            CIcontra(k).PatientID = contramrn{k};
            CIcontra(k).flgCensor = contracomp(k);
            CIcontra(k).lnn= contralnn;
            CIcontra(k).FxNum = 1;
            CIcontra(k).EUD = contraEUD(k,:)';
        end

	% prepare for atlas computation
        CGobjs = classComplicationGroup();
        CGobjs =repmat(CGobjs,[2 1]);
        xlsSheets={'Left','Right'};
        
	% left tumor patients
        CGobj = classComplicationGroup();
        CGobj.lnn = ipsilnn;
        CGobj.DoseStep_EUD = dosestep;
        CGobj = CGobj.AddPatient([CIipsi(flgleft); CIcontra(~flgleft)]);
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
        CGobj = CGobj.LogisticRegressionAnalysis_EUD();
        % save result
        CGobjs(1) = CGobj;

	% right tumor patients
        CGobj = CGobj.RemovePatient();
        CGobj = CGobj.AddPatient([CIipsi(~flgleft); CIcontra(flgleft)]);
        % atlas
        CGobj = CGobj.CrudeAtlas_EUD();
        CGobj = CGobj.BetaCumulativeProbability_EUD();
        CGobj = CGobj.BetaInverseProbability_EUD();
        CGobj = CGobj.LogisticRegressionAnalysis_EUD();
        % save result
        CGobjs(2) = CGobj;

	% save result
        if flglog
            xlsFile = 'G:/MSKCC/Andy/2009R01/tom/MSK_LR_logDoseBins';
        else
            xlsFile = 'G:/MSKCC/Andy/2009R01/tom/MSK_LR_linearDoseBins';
        end
        if isunix
            xlsFile=strrep(xlsFile,'G:','/media/SKI_G');
        end
        save(xlsFile,'CGobjs','xlsSheets');
    
        CGmsk = CGobjs;
        xlsSheetmsk = xlsSheets;


%% NKI
            % save result
            if flglog
                xlsFile = 'G:/MSKCC/Andy/2009R01/tom/NKI_logDoseBins';
            else
                xlsFile = 'G:/MSKCC/Andy/2009R01/tom/NKI_linearDoseBins';
            end
            if isunix
                xlsFile=strrep(xlsFile,'G:','/media/SKI_G');
            end
            load(xlsFile,'CGobjs','xlsSheets');
            
            CGnki = CGobjs;
            xlsSheetnki = xlsSheets;
            
%% combine nki and msk data
    % matching pairs
        matchpairs={
            'Left','Left'
            'Right','Right'
            };
        numSheets = size(matchpairs,1);
    
        % comine pairs one by one
        CGobjs = classComplicationGroup();
        CGobjs = repmat( CGobjs, [numSheets,1] );
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
                    CGobjs(k) = classComplicationGroup.CombineAtlas_EUD(CGmsk(fmsk),CGnki(fnki));
                    xlsSheets{k} = matchpairs{k,1};
            catch ME
                disp(ME.message);
            end
        end
        
        if flglog
            xlsFile = 'G:/MSKCC/Andy/2009R01/tom/MSK_NKI_LR_logDoseBins';
        else
            xlsFile = 'G:/MSKCC/Andy/2009R01/tom/MSK_NKI_LR_linearDoseBins';
        end
        if isunix
            xlsFile=strrep(xlsFile,'G:','/media/SKI_G');
        end
        save(xlsFile,'CGobjs','xlsSheets');
toc;