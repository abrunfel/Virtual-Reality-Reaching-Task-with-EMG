%% File import
clear all; close all
% Select desired folder (do not hit 'Enter' key. You must highlight the
% folder, then hit "Select Folder" button on popup.
if strcmp(computer, 'PCWIN64')
    selpath = uigetdir('C:\Users\REDACTED');
    subid = selpath(end-10:end);
    cd('C:\Users\REDACTED')
    files = dir(['*' subid '*']);
    clear subid % remove this so as to not confuse with the datenum subid
else
    selpath = uigetdir('/Users/alexbrunfeldt/Dropbox/Catholic U/VR_EXO/EMG/Raw EMG Data');
    subid = selpath(end-10:end);
    cd('/Users/REDACTED')
    files = dir(['*' subid '*']);
    clear subid % remove this so as to not confuse with the datenum subid
end

%% Main loop
for i = 1:length(files)
    file = load(files(i).name); % Get one individual file
    % Create unique identifier (matches that from vr_exo_kinematics.m)
    formatIn = 'mm_dd_yy';
    subID = str2num([num2str(datenum(files(1).name(1:8),formatIn)) files(1).name(10:11)]);
    cond = files(i).name(13:14);
    switch cond
        case{'bl'}
            condition = 1;
        case{'rh'}
            condition = 2;
        case{'lh'}
            condition = 3;
        case{'bh'}
            condition = 4;
    end
    block = str2num(files(i).name(16:17));
    
    % Fix rare case where the onset for trial one is negative (ie: onsetoffsetLH/RH(1,1) = neg value)
    if find(file.onsetoffsetLH<0) == 1
        file.onsetoffsetLH(1,1) = 1;
        file.trig(1) = 1;
        warning('Trial 1 onset is negative value')
    end
    if find(file.onsetoffsetRH<0) == 1
        file.onsetoffsetRH(1,1) = 1;
        file.trig(1) = 1;
        warning('Trial 1 onset is negative value')
    end
    
    % Detrend data
    file.ldelt = detrend(file.ldelt);
    file.rdelt = detrend(file.rdelt);
    file.lbicep = detrend(file.lbicep);
    file.rbicep = detrend(file.rbicep);
    
    % Filter data
    bpfreq = [5 250];
    filtLdelt = bandpass(file.ldelt,bpfreq,file.freq);
    filtRdelt = bandpass(file.rdelt,bpfreq,file.freq);
    filtLbicep = bandpass(file.lbicep,bpfreq,file.freq);
    filtRbicep = bandpass(file.rbicep,bpfreq,file.freq);
    
    % RMSE calculation
    rmse = emgRMSE(filtLdelt, filtRdelt, filtLbicep, filtRbicep, file.onsetoffsetLH, file.onsetoffsetRH);
 
    % Coherence Integral from Type0 analysis: see lab book pg 64.
    seg_pwr=10;
    opt_str = '';
    CI = coherence_integral(filtLdelt,filtRdelt,filtLbicep,filtRbicep,file.freq,seg_pwr,opt_str, file.onsetoffsetLH, file.onsetoffsetRH);
    CIintra = coherence_integral_intra(filtLdelt,filtRdelt,filtLbicep,filtRbicep,file.freq,seg_pwr,opt_str, file.onsetoffsetLH, file.onsetoffsetRH); %INTRAlimb coherence
   
    % Convert RMSE to long format for R
    rmseLF = [rmse(:,1); rmse(:,2); rmse(:,3); rmse(:,4)];
    % Set up factors for RMSE
    subid = ones(size(rmse,2)*length(file.trig),1)*subID;
    cond = ones(size(rmse,2)*length(file.trig),1)*condition;
    block = ones(size(rmse,2)*length(file.trig),1)*block;
    % NOTE: Number of EMG channels is fixed (N = 4). If this changes, so
    % too with the following line...
    muscle = [ones(length(file.trig),1); 2*ones(length(file.trig),1); 3*ones(length(file.trig),1); 4*ones(length(file.trig),1)]; % 1 = ldelt, 2 = rdelt, 3 = lbicep, 4 = rbicep
    trial = repmat(1:length(file.trig)',1,4)';
    target = repmat(file.targets,4,1);
    % Export dataframe
    DFexportRMSE = [subid cond block trial muscle target rmseLF];    
    writematrix(DFexportRMSE, [selpath(1:end-11) 'exovr_emgRMSE_bp.txt'], 'WriteMode', 'append', 'Delimiter', ',');
    
    % Convert CI to long format for R
    CILF = [CI(:,1); CI(:,2); CI(:,3); CI(:,4); CI(:,5); CI(:,6)];
    % Set up factors for CI
    subid = ones(size(CI,1)*size(CI,2),1)*subID(1);
    cond = ones(size(CI,1)*size(CI,2),1)*condition(1);
    block = ones(size(CI,1)*size(CI,2),1)*block(1);
    muscle = [ones(size(CI,1)*size(CI,2)/2,1); 2*ones(size(CI,1)*size(CI,2)/2,1)]; % 1 = deltoid, 2 = bicep. NOTE: Only have 2 levels of the 'muscle' factor here because its INTERmuscular 
    band = repmat([ones(size(CI,1),1); 2*ones(size(CI,1),1); 3*ones(size(CI,1),1)],2,1); % 1 = alpha, 2 = beta, 3 = gamma
    trial = repmat(1:length(file.trig)',1,6)';
    target = repmat(file.targets,6,1);
    % Export dataframe
    DFexportCI = [subid cond block trial muscle band target CILF];
    writematrix(DFexportCI, [selpath(1:end-11) 'exovr_emgCI_bp.txt'], 'WriteMode', 'append', 'Delimiter', ','); % Matlab 2020 or later
    
    % Convert CIintra to long format for R
    CILFintra = [CIintra(:,1); CIintra(:,2); CIintra(:,3); CIintra(:,4); CIintra(:,5); CIintra(:,6)];
    % Set up factors for CI
    subid = ones(size(CIintra,1)*size(CIintra,2),1)*subID(1);
    cond = ones(size(CIintra,1)*size(CIintra,2),1)*condition(1);
    block = ones(size(CIintra,1)*size(CIintra,2),1)*block(1);
    arm = [ones(size(CIintra,1)*size(CIintra,2)/2,1); 2*ones(size(CIintra,1)*size(CIintra,2)/2,1)]; % 1 = left, 2 = right. NOTE: Only have 2 levels of the 'arm' factor here because its INTRAmuscular 
    band = repmat([ones(size(CIintra,1),1); 2*ones(size(CIintra,1),1); 3*ones(size(CIintra,1),1)],2,1); % 1 = alpha, 2 = beta, 3 = gamma
    trial = repmat(1:length(file.trig)',1,6)';
    target = repmat(file.targets,6,1);
    % Export dataframe
    DFexportCIintra = [subid cond block trial arm band target CILF];
    writematrix(DFexportCIintra, [selpath(1:end-11) 'exovr_emgCIintra_bp.txt'], 'WriteMode', 'append', 'Delimiter', ','); % Matlab 2020 or later

clear file
end
