function EUDPtInfo
tic;
% parameters
    fn = 'G:/MSKCC/Andy/2009R01/tom/NKI_linearDoseBins';
    xlsFile = 'G:/MSKCC/Andy/2009R01/meta/NSCLC_all_rev (2)'
    fn = 'G:/MSKCC/Andy/2009R01/tom/MSK_linearDoseBins';
    xlsFile = 'G:/MSKCC/Andy/2009R01/meta/To Fan.mat';

% patient info.
    % load patient info from results
    if isunix
        xlsFile=strrep(xlsFile,'G:','/media/SKI_G');
        fn=strrep(fn,'G:','/media/SKI_G');
    end
    load(xlsFile);
    load(fn,'CGobjs','xlsSheets');
    disp(fn);
    % load patient info from spread sheet
        fn='G:/MSKCC/Andy/Ken/meta/20100424CWFinalCohort';
        if isunix
            fn=strrep(fn,'G:','/media/SKI_G');
        end
        try
            load(fn,'xlsraw');
        catch
            fn1 = strrep(fn,'tom','meta');
            [~,~,xlsraw]=xlsread([fn1,'.xlsx'],'sheet1');
            save(fn,'xlsraw');
        end

    % pick up related data
        PtInfo = classDataFromXls();
        PtInfo.xlsRaw = xlsraw;
        % MRN
        PtInfo.ColName = 'Patient Last Name';
        PtInfo = PtInfo.ExtractColData();
        flgptcode = PtInfo.flgDataRows;
        ptcode = PtInfo.ColData;
        % Number of Fractions
        PtInfo.ColName = 'Number of Fractions';
        PtInfo = PtInfo.ExtractColData();
        flgfx = PtInfo.flgDataRows;
        fx = zeros(size(flgfx));
        fx(flgfx) = cell2mat(PtInfo.ColData(flgfx));
        % Date of Birth
        PtInfo.ColName = 'Date of Birth';
        PtInfo = PtInfo.ExtractColData();
        flgdatebirth = PtInfo.flgDataRows;
        datebirth = zeros(size(flgdatebirth));
        f = PtInfo.ColData(flgdatebirth);
        datebirth(flgdatebirth) = datenum(f);
        % IGRT Start Date
        PtInfo.ColName = 'IGRT End Date';
        PtInfo = PtInfo.ExtractColData();
        flgdateIGRT = PtInfo.flgDataRows;
        dateIGRT = zeros(size(flgdateIGRT));
        f = PtInfo.ColData(flgdateIGRT);
        dateIGRT(flgdateIGRT) = datenum(f);
        % Last Follow Up Date
        PtInfo.ColName = 'Surv Date';
        PtInfo = PtInfo.ExtractColData();
        flgdatefu = PtInfo.flgDataRows;
        datefu = zeros(size(flgdatefu));
        datefu(flgdatefu) = datenum(PtInfo.ColData(flgdatefu));
        % complication grade 3
        PtInfo.ColName = 'Pain Grade 3';
        PtInfo = PtInfo.ExtractColData();
        datepain = inf(size(PtInfo.ColData));
        flgcensor = true(size(datefu));
        f = PtInfo.flgDataRows;
        datepain(f) = datenum(PtInfo.ColData(f));
        flgcensor(f) = false;
        % complication grade 2
        PtInfo.ColName = 'Pain Grade 2';
        PtInfo = PtInfo.ExtractColData();
        f = PtInfo.flgDataRows;
        datepain(f) = datenum(PtInfo.ColData(f));
        flgcensor(f) = false;
        % relapse date
        PtInfo.ColName = 'Local Failure';
        PtInfo = PtInfo.ExtractColData();
        f = PtInfo.flgDataRows;
        flgfailure = false(size(f));
        flgfailure(f) = cell2mat(PtInfo.ColData(f));
        PtInfo.ColName = 'Local Failure Date';
        PtInfo = PtInfo.ExtractColData();
        flgrelapse = PtInfo.flgDataRows;
        datefailure = inf(size(flgrelapse));
        datefailure(flgrelapse&flgfailure) = datenum(PtInfo.ColData(flgrelapse&flgfailure));
        flgrelapse = flgrelapse&f;
        % gender
        PtInfo.ColName = 'Sex';
        PtInfo = PtInfo.ExtractColData();
        flggender = PtInfo.flgDataRows;
        ptgender = PtInfo.ColData;
        % death date
        PtInfo.ColName = 'Surv alive 0, dead 1';
        PtInfo = PtInfo.ExtractColData();
        f1 = PtInfo.flgDataRows;
        flgdeath = false(size(f1));
        flgdeath(f1) = cell2mat(PtInfo.ColData(f1));
        PtInfo.ColName = 'death Date';
        PtInfo = PtInfo.ExtractColData();
        f = PtInfo.flgDataRows;
        datedeath = inf(size(f));
        datedeath(f&flgdeath) = datenum(PtInfo.ColData(f&flgdeath));
        flgdeath = f1&f;
        % dose prescription
        PtInfo.ColName = 'Total Dose (cGy)';
        PtInfo = PtInfo.ExtractColData();
        flgdose = PtInfo.flgDataRows;
        ptdose = PtInfo.ColData;

        % common part of those data
        flg = flgptcode & flgfx & flgdatebirth & flgdateIGRT & flgdatefu & flgrelapse & flggender & flgdeath & flgdose;
        ptcode=ptcode(flg);
        fx=fx(flg);
        datebirth=datebirth(flg);
        dateIGRT=dateIGRT(flg);
        datefu=datefu(flg);
        datepain=datepain(flg);
        flgcensor=flgcensor(flg);
        datefailure = datefailure(flg);
        ptgender = ptgender(flg);
        datedeath = datedeath(flg);
        ptdose = ptdose(flg);
        
    % patient DVH and objects
        CGobj_org=classComplicationGroup();
    
        for m=1:length(dvhdef) % iterate with each definition
            % load dvh info
            fn=['G:/MSKCC/Andy/Ken/meta/DVH_',dvhdef{m}];
            if isunix
                fn=strrep(fn,'G:','/media/SKI_G');
            end
            load(fn,'DVH');
        
            % match patients DVH and .xls
            [f1,g1]=ismember(ptcode,DVH(:,1));
            [f2,g2]=ismember(DVH(:,1),ptcode);
            if length(unique(g2(g2~=0)))~=length(find(g2))% || length(unique(g2~=0))~=length(find(g2))
                error('The patient ids are not unique');
            end
            if ~( all(f1) && all(f2) )
                disp('The patients in the spread sheet do not match with those in DVH curves, take the common part');
                % use common part only
                DVH=DVH(f2,:);
                ptcode=ptcode(f1); fx=fx(f1); datebirth=datebirth(f1); dateIGRT=dateIGRT(f1); datefu=datefu(f1); datepain=datepain(f1); flgcensor=flgcensor(f1);
                [~,g1]=ismember(ptcode,DVH(:,1));
            end
            
            % combine info from DVH and .xls to form complicationgroup object
            CIobjs = classComplicationIndividual();
            CIobjs = repmat(CIobjs,[size(DVH,1),1]);
            for n = 1:size(DVH,1)
                CIobjs(n,1).PatientID=ptcode{n};
                CIobjs(n,1).DoseBins_org=DVH{g1(n),2}(:,1);
                CIobjs(n,1).VolDiff=DVH{g1(n),2}(:,2);
                CIobjs(n,1).VolCum=DVH{g1(n),2}(:,3);
                CIobjs(n,1).FxNum=fx(n);
                CIobjs(n,1).BirthDate = datebirth(n);
                CIobjs(n,1).BaselineDate = dateIGRT(n);
                CIobjs(n,1).CompOccurDate = datepain(n);
                CIobjs(n,1).LastFollowupDate = datefu(n);
                CIobjs(n,1).flgCensor = flgcensor(n);
                CIobjs(n,1).RelapseDate = datefailure(n);
                CIobjs(n,1).Gender = ptgender(n);
                CIobjs(n,1).DeathDate = datedeath(n);
                CIobjs(n,1).DosePrescription = ptdose(n);
            end
            if any([CIobjs.FxNum]==0)
                error('Fraction number is zeros');
            end
            CGobj_pt = CGobj_org.AddPatient(CIobjs);

                    % save result
                    CGstrct = ObjToStruct(CGobj_pt);
                    fn=['G:/MSKCC/Andy/Ken/tom/CW_Pt_',dvhdef{m},'.mat'];
                    if isunix
                        fn=strrep(fn,'G:','/tom/SKI_G');
                    end
                    save(fn,'CGobj_pt','CGstrct');
                    disp(fn);
        end
toc;
end