function HeartOL

%% read xls file
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
    
        
 end