function HeartDVHFromText
% DVH is saved in 3 cell columns, the first stores the patient name, 
% the second stores the original dose, original differential volume, cumulative volume from oriignal diffirential volume
% the third the resampled dose, differential volume, and cumulative volume

tic;

    %% Load Heart-Target overlap info
    
  PtInfo = classDataFromXls();
    fn = 'Z:/elw/MATLAB/regions/meta/heart_target_overlap.xls';
    % xlsData - array of structures with sheet name (e.g. 'Whole', 'Ispi',
    % 'Contra', etc.) and raw data
    xlsData=xlsFileRead(fn);
    
   [~,~,raw]=xlsread(fn,'Sheet2'); % read .xls sheet
    PtInfo.mXlsRaw = raw;
    % MRN
    PtInfo.mLabel = 'heart_target_ol';
    PtInfo = PtInfo.fExtractColData(); 
    flgptcode = PtInfo.mFlg;
    ptcode = PtInfo.mData(flgptcode); % cell array of MRN (PtInfo.mLabel) data
    ols = cell2mat(ptcode);
    
    PtInfo.mLabel = 'mrn';
    PtInfo = PtInfo.fExtractColData(); 
    flgptcode = PtInfo.mFlg;
    ptcode = PtInfo.mData(flgptcode); % cell array of MRN (PtInfo.mLabel) data
    f = cellfun('isclass', ptcode, 'char'); % transfer numeric pt code to string
    f=~f;   
    ptcode(f) = cellfun(@(x) num2str(x), ptcode(f), 'UniformOutput', false);
    mrns = ptcode;
    
% load pt info from whole lung
    fn = 'Z:/elw/MATLAB/regions/meta/MSK_EUD_regional.mat';
    load(fn,'CGobjs');
    CGobjs = CGobjs(1);
    pt = {CGobjs.mGrp.mID};

% read xls file for pt name and code
    fn = 'Z:/elw/MATLAB/regions/meta/MSK_EUD.xls';
    xlsData=xlsFileRead(fn);
    PtInfo = classDataFromXls();
    PtInfo.mXlsRaw = xlsData(1).xlsRaw;
    % MRN
    PtInfo.mLabel = 'MRN,';
    PtInfo = PtInfo.fExtractColData();
    flgptcode = PtInfo.mFlg;
    ptcode = PtInfo.mData;
    f = cellfun('isclass', ptcode, 'char'); % transfer numeric pt code to string
    f=~f;
    ptcode(f) = cellfun(@(x) num2str(x), ptcode(f), 'UniformOutput', false);
    % Surname
    PtInfo.mLabel = 'surname';
    PtInfo = PtInfo.fExtractColData();
    flgsurname = PtInfo.mFlg;
    ptsurname = PtInfo.mData;
    % first name
    PtInfo.mLabel = 'first name';
    PtInfo = PtInfo.fExtractColData();
    flgfirstname = PtInfo.mFlg;
    ptfirstname = PtInfo.mData;
    % combine info
    flgptcode = flgptcode & flgsurname & flgfirstname;
    ptcode = ptcode(flgptcode);
    ptsurname = ptsurname(flgptcode);
    ptsurname = cellfun(@(x) x(1:end-1), ptsurname, 'UniformOutput',false);
    ptfirstname = ptfirstname(flgptcode);
    ptfirstini = cellfun(@(x) x(1), ptfirstname);

% heart path and files
    pathname='Z:/elw/MATLAB/regions/meta/heart/';
    d = dir(pathname); % list all files and directories
    d([d.isdir])=[]; % remove directories

% read DVH from each file for each patient
    OI = classOutcomeIndividual();
    OI = repmat(OI,[length(d),1]);
    n = 0;
    for k = 1:length(d)
        % find the ptcode of the patient
        f = cellfun(@(x) strfind(d(k).name,x), ptsurname, 'UniformOutput',false); % check if the patient is one of the cohort in the spread sheet
        flg = cellfun('isempty',f); 
        fg = find(flg==false); % the cell for the patient is not empty if it exist in the spread sheet
        if isempty(fg) % the patient cannot be found
            disp(['the file ', d(k).name, ' cannot match the patient name in the spread sheet']);
            continue;
        end
        
        is_cdvh = strfind(d(k).name,'HEART_ABSVOL_INT');
        
        g = strfind(d(k).name,'_'); % find the pt name
        strn = d(k).name(1:g(1)-1);
        ptid = [];
        if length(fg)>1 % more than one pt share the same surname, identify them by first initial
            for m = 1:length(fg) % find the pt code
                if strcmpi(strn, strcat(ptsurname(fg(m)),ptfirstini(fg(m)))) % try the surname + first name initial
                    ptid = ptcode(fg(m));
                    break;
                end
            end
            if isempty(ptid) % pt not found, skip
                continue;
            end
        else
            ptid = ptcode(fg);
        end
        % extract the DVH for the patient
        fid = fopen(strcat(pathname,d(k).name),'r');
        dv = textscan(fid, '%s', 'delimiter',',', 'EmptyValue',-inf);
        fclose(fid);
        dv = dv{1};
        dv(1) = []; % the first cell is the string of the description, remove it
        data = cellfun(@(x) str2num(x), dv);
        dose = data(1:4:end)/100; % /100 to convert from cGy to Gy
       if is_cdvh
            vol_cum = data(2:4:end);
            vol = zeros(size(vol_cum));
            vol(1:end-1) = diff(vol_cum);
            vol = abs(vol);
       else
        vol = data(2:4:end); % this is the differential volume
        vol_cum = flipud(vol); vol_cum = cumsum(vol_cum); vol_cum = flipud(vol_cum); % cumulative volume
       end
        % find the basic pt info
        f = cellfun(@(x) strcmpi(x,ptid),pt);
        % assign the patient info
        n = n+1;
        
               
        OI(n) = CGobjs.mGrp(f); % pt basic info
        OI(n).mDoseBins_org = dose;
        OI(n).mVolDiff = vol;
        OI(n).mVolCum = vol_cum;
        
        %% load heart-target overlap info
        cur_mrn = OI(n).mID;
        good_ind=-1;
        for i=1:length(mrns),
            if isequal(cur_mrn,char(mrns(i))),
                    good_ind=i;
                    break;  
            end
        end
        if good_ind<0,
            disp([cur_mrn,' not found in patients']);
        end
        OI(n).mHeartTargetOL = ols(good_ind);
            
            
    end
    

    
    
    %% save
    OI(n+1:end) = [];
    CGobjs = CGobjs.fRemovePatient();
    CGobjs = CGobjs.fAddPatient(OI);
    
    fn='Z:/elw/MATLAB/regions/meta/MSK_heart';
    save(fn,'CGobjs');
    %%
toc;