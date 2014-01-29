function EUD_DataIntegration_MSK
tic;
% collect exact eud info
    xlsFile = 'G:/MSKCC/Andy/2009R01/meta/MSK_EUD_exact';
    if isunix
        xlsFile=strrep(xlsFile,'G:','/media/SKI_G');
    end
    
    try
        load(xlsFile,'CGobjs','xlsSheets');
    catch
        [CGobjs,xlsSheets] = EUD_exact();
    end
    
    % generate atlas
    for k = 1:length(CGobjs)
        CGobjs(k) = CGobjs(k).CalculateDoseBins_EUD();
        CGobjs(k) = CGobjs(k).CrudeAtlas_EUD();
    end
    
    MSKexact = CGobjs; Sheetsexact = xlsSheets;
    
% collect binned eud info
    xlsFile = 'G:/MSKCC/Andy/2009R01/meta/MSK_EUD_binned';
    if isunix
        xlsFile=strrep(xlsFile,'G:','/media/SKI_G');
    end
    
    try
        load(xlsFile,'CGobjs','xlsSheets');
    catch
        [CGobjs,xlsSheets] = EUD_binned();
    end

    % generate atlas
    for k = 1:length(CGobjs)
        CGobjs(k) = CGobjs(k).CalculateDoseBins_EUD();
        CGobjs(k) = CGobjs(k).CrudeAtlas_EUD();
    end
    
    MSKbinned = CGobjs; Sheetsbinned = xlsSheets;
    
% integration the two dataset
	% matching pairs
    matchpairs={
        'Whole','Whole'
%         'Contra','contra'
%         'Ipsi','ipsi'
%         'Superior','cranial'
%         'Inferior','caudal'
        };
    
    CGobjs = MSKexact;
    for k = 1:size(matchpairs,1)
        % find the location of the two data sets
        [~,fexact] = ismember(matchpairs{k,1},Sheetsexact);
        [~,fbinned] = ismember(matchpairs{k,2},Sheetsbinned);
        if isequal(fexact,0) || isequal(fbinned,0)
            error(['data error in matching pair: ',matchpairs(k)]);
        end
        
        % QA of the exact and binned eud
        pt_exact = {MSKexact(fexact).ptGrp.PatientID};
        pt_binned = {MSKbinned(fbinned).ptGrp.PatientID};
        [flgexact,posexact] = ismember(pt_exact,pt_binned);
        [flgbinned,posbinned] = ismember(pt_binned,pt_exact);
        if ~(all(flgexact) && all(flgbinned))
            warning('EUD:mismatching:exact&binned','The patient id in exact EUD and binned EUD does not match');
        end
        
        if ~(isequal(MSKexact(fexact).PatientTotal_EUD,MSKbinned(fbinned).PatientTotal_EUD) && isequal(CGobjs(fexact).PatientComp_EUD, MSKbinned(fbinned).PatientComp_EUD))
            disp(max(max(abs(MSKexact(fexact).PatientTotal_EUD - MSKbinned(fbinned).PatientTotal_EUD))));
            disp(max(max(abs(CGobjs(fexact).PatientComp_EUD - MSKbinned(fbinned).PatientComp_EUD))))
        end
        
        % integrate the two data sets
        CGobjs(fexact).PatientTotal_EUD = MSKbinned(fbinned).PatientTotal_EUD;
        CGobjs(fexact).PatientComp_EUD = MSKbinned(fbinned).PatientComp_EUD;
    end
% save result
    xlsFile = 'G:/MSKCC/Andy/2009R01/meta/MSK_EUD_integration';
    if isunix
        xlsFile=strrep(xlsFile,'G:','/media/SKI_G');
    end
    
    CGstrct = ObjToStruct(CGobjs);
    save(xlsFile,'CGobjs','CGstrct','matchpairs');
toc;
end


function [CGobjs,xlsSheets] = EUD_exact()
    % prepare
    dosestep = 1; % in Gy
    
    % file with exact EUD
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
    
    % parse patient info sheet by sheet
    xlsSheets = cell(numSheets,1);
    CGobj = classComplicationGroup();
    CGobjs = repmat(CGobj,[numSheets,1]);
    
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
            flgpt=PtInfo.flgDataRows;
            pt = PtInfo.ColData;
            
            % complication
            PtInfo.ColName = 'gt gd3';
            PtInfo = PtInfo.ExtractColData();
            flgcomprow = PtInfo.flgDataRows;
            if ~isequal(flgpt,flgcomprow)
                error('patient code and complication info not match');
            end
            ptcomp = false(size(PtInfo.ColData));
            ptcomp(flgcomprow) = cell2mat(PtInfo.ColData(flgcomprow));
            ptcomp = ~ptcomp; % 1 - censored
            
            % the log10(n) values in the sheet
            PtInfo.RowName = 'gt gd3';
            PtInfo = PtInfo.ExtractRowData();
            flgLnn = cellfun(@(x) ischar(x),PtInfo.RowData);
            flgLnn = ~flgLnn & PtInfo.flgDataCols;
            CGobj.lgn = cell2mat(PtInfo.RowData(flgLnn));
            % EUD matrix
            CIobjs = classComplicationIndividual.empty(sum(flgpt),0);
            fpt = find(flgpt);
            for m = 1:length(fpt)
                CIobjs(m).PatientID = pt{fpt(m)};
                CIobjs(m).EUD = cell2mat(PtInfo.xlsRaw(fpt(m),flgLnn))';
                CIobjs(m).flgCensor = ptcomp(fpt(m));
            end
            
            % add the patients to the CGobj
            CGobj = CGobj.RemovePatient(); % remove old patient info first
            CGobj = CGobj.AddPatient(CIobjs);
            
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
    xlsFile = 'G:/MSKCC/Andy/2009R01/meta/MSK_EUD_exact';
    if isunix
        xlsFile=strrep(xlsFile,'G:','/media/SKI_G');
    end
    
    CGstrct = ObjToStruct(CGobjs);
    save(xlsFile,'CGobjs','CGstrct','xlsSheets');
end


function [CGobjs,xlsSheets] = EUD_binned()
% prepare
    dosestep = 1; % in Gy
    
% load binned EUD data
    xlsFile = 'G:/MSKCC/Andy/2009R01/meta/crudeeud_vals_0p5Gy_wo_booke';
    if isunix
        xlsFile=strrep(xlsFile,'G:','/media/SKI_G');
    end
    
    try
        load(xlsFile);
    catch
        xlsData=xlsFileRead(xlsFile);
        save(xlsFile,'xlsData');
    end
    numSheets = length(xlsData);

% parse the whole lung info
    xlsSheets = cell(numSheets,1);
    CGobj = classComplicationGroup();
    CGobjs = repmat(CGobj,[numSheets,1]);

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
            PtInfo.ColName = 'mrn';
            PtInfo = PtInfo.ExtractColData();
            flgpt=PtInfo.flgDataRows;
            pt = PtInfo.ColData;
            
            % complication
            PtInfo.ColName = 'gtegd3';
            PtInfo = PtInfo.ExtractColData();
            flgcomprow = PtInfo.flgDataRows;
            if ~isequal(flgpt,flgcomprow)
                error('patient code and complication info not match');
            end
            ptcomp = false(size(PtInfo.ColData));
            ptcomp(flgcomprow) = cell2mat(PtInfo.ColData(flgcomprow));
            ptcomp = ~ptcomp; % 1 - censored
            
            % the log10(n) values in the sheet
            PtInfo.RowName = 'gtegd3';
            PtInfo = PtInfo.ExtractRowData();
            flgLnn = cellfun(@(x) ischar(x),PtInfo.RowData);
            flgLnn = ~flgLnn & PtInfo.flgDataCols;
            CGobj.lgn = cell2mat(PtInfo.RowData(flgLnn));
            % EUD matrix
            CIobjs = classComplicationIndividual.empty(sum(flgpt),0);
            fpt = find(flgpt);
            for m = 1:length(fpt)
                CIobjs(m).PatientID = pt{fpt(m)};
                CIobjs(m).EUD = cell2mat(PtInfo.xlsRaw(fpt(m),flgLnn))';
                CIobjs(m).flgCensor = ptcomp(fpt(m));
            end
            
            % add the patients to the CGobj
            CGobj = CGobj.RemovePatient(); % remove old patient info first
            CGobj = CGobj.AddPatient(CIobjs);
            
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
    xlsFile = 'G:/MSKCC/Andy/2009R01/meta/MSK_EUD_binned';
    if isunix
        xlsFile=strrep(xlsFile,'G:','/media/SKI_G');
    end
    
    CGstrct = ObjToStruct(CGobjs);
    save(xlsFile,'CGobjs','CGstrct','xlsSheets');
end