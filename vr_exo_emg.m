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
    selpath = uigetdir('/Users/REDACTED');
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
    
    % RMSE calculation
    rmse = emgRMSE(file.ldelt, file.rdelt, file.lbicep, file.rbicep, file.onsetoffsetLH, file.onsetoffsetRH);
 
    % Coherence Integral from Type0 analysis: see lab book pg 64.
    seg_pwr=10;
    opt_str = '';
    CI = coherence_integral(file.ldelt,file.rdelt,file.lbicep,file.rbicep,file.freq,seg_pwr,opt_str, file.onsetoffsetLH, file.onsetoffsetRH);
   
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
    writematrix(DFexportRMSE, [selpath(1:end-11) 'exovr_emgRMSE.txt'], 'WriteMode', 'append', 'Delimiter', ',');
    
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
    writematrix(DFexportCI, [selpath(1:end-11) 'exovr_emgCI.txt'], 'WriteMode', 'append', 'Delimiter', ','); % Matlab 2020 or later

clear file
end
