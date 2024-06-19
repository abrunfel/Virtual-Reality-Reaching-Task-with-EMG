%% File import
% This will read in all files from the specified folder. NOTE: if an ".mat"
% files exists in the folder, it will be included in the exported
% dataframe!
clear all; close all
if strcmp(computer, 'PCWIN64')
    cd('C:\Users\Alex\Dropbox\Catholic U\VR_EXO\Neurospec development\neurospec_dev_data\mansucript data')
    files = dir(['*.mat']);
else
    cd('/Users/alexbrunfeldt/Dropbox/Catholic U/VR_EXO/Neurospec development/neurospec_dev_data/mansucript data')
    files = dir(['*.mat']);
end

%% Main Loop
for k = 1:length(files)
    filename = files(k).name;
    [rmswin, rmswinLoc] =  rmsWindow(filename, 7); % right now only chooses data for target location = 7
    if strcmp(computer, 'PCWIN64')
        cd('C:\Users\Alex\Dropbox\Catholic U\Manuscripts\VR_EXO_healthies\Review\MATLABoutput');
        %dlmwrite('rmswinDF', rmswin, '-append', 'delimiter', ',', 'precision', '%.12f'); % Write dataframe to folder as comma delim file NOTE: this appends data, so you must delete unwanted (old) files before running this
        dlmwrite('rmswinDFtargetLoc', rmswinLoc, '-append', 'delimiter', ',', 'precision', '%.12f');
        cd('C:\Users\Alex\Dropbox\Catholic U\VR_EXO\Neurospec development\neurospec_dev_data\mansucript data')
    else
        cd('/Users/alexbrunfeldt/Dropbox/Catholic U/Manuscripts/VR_EXO_healthies/Review/MATLABoutput')
        %dlmwrite('rmswinDF', rmswin, '-append', 'delimiter', ',', 'precision', '%.12f'); % Write dataframe to folder as comma delim file NOTE: this appends data, so you must delete unwanted (old) files before running this
        dlmwrite('rmswinDFtargetLoc', rmswinLoc, '-append', 'delimiter', ',', 'precision', '%.12f');
        cd('/Users/alexbrunfeldt/Dropbox/Catholic U/VR_EXO/Neurospec development/neurospec_dev_data/mansucript data');
    end
end
%

%% RMS windowing function
function [rmswin, rmswinLoc] =  rmsWindow(filename, targetLoc)
%% Signal preparation
load(filename);
% Determine resting bias
ldelt_bias = mean(ldelt(1:100));
rdelt_bias = mean(rdelt(1:100));
lbicep_bias = mean(lbicep(1:100));
rbicep_bias = mean(rbicep(1:100));

% Remove resting bias (offset correct)
ldeltOC = ldelt - ldelt_bias;
rdeltOC = rdelt - rdelt_bias;
lbicepOC = lbicep - lbicep_bias;
rbicepOC = rbicep - rbicep_bias;

% Fix rare case where the onset for trial one is negative (ie: onsetoffsetLH/RH(1,1) = neg value)
if onsetoffsetLH(1,1) < 0
    onsetoffsetLH(1,1) = 201; % Changed to 201 here to compensate for epoch shift. See Lab book pg 114.
end
if onsetoffsetLH(1,2) < 0
    onsetoffsetLH(1,2) = onsetoffsetLH(1,1) + 100; % Even more rare occurance when offset for trial 1 is negative. In this case, make offset 100 sample after onset
end
if onsetoffsetRH(1,1) < 0
    onsetoffsetRH(1,1) = 201;
end
if onsetoffsetRH(1,2) < 0
    onsetoffsetRH(1,2) = onsetoffsetRH(1,1) + 100; % Even more rare occurance when offset for trial 1 is negative. In this case, make offset 100 sample after onset
end

% Fix ultra rare case where final offset value is outside bounds of data array
if onsetoffsetLH(end,2) > length(ldelt)
    onsetoffsetLH(end,2) = length(ldelt); % set final offset to end of data
end
if onsetoffsetRH(end,2) > length(rdelt)
    onsetoffsetRH(end,2) = length(rdelt); % set final offset to end of data
end
% Shift onset/offset markers forward by 200ms. This is because muscle
% activity begins ~200ms before movement onset, and we have a long tail of
% null activity after movement offset. See Lab book pg 114.
onsetoffsetLH(:,:) = onsetoffsetLH(:,:) - 200;
onsetoffsetRH(:,:) = onsetoffsetRH(:,:) - 200;
% Resample loop
nsamp = 5000;
for i = 1:length(targets)
    % epoch into individual trial timeseries
    tempLdelt = ldeltOC(onsetoffsetLH(i,1):onsetoffsetLH(i,2));
    tempRdelt = rdeltOC(onsetoffsetRH(i,1):onsetoffsetRH(i,2));
    tempLbicep = lbicepOC(onsetoffsetLH(i,1):onsetoffsetLH(i,2));
    tempRbicep = rbicepOC(onsetoffsetRH(i,1):onsetoffsetRH(i,2));
    
    % Resample to same length data,
    %then concat into single array (per muscle)
    xqLdelt = linspace(1, length(tempLdelt), nsamp); % Resample to this length array
    xqRdelt = linspace(1, length(tempRdelt), nsamp); % Resample to this length array
    ldeltrs(:,i) = interp1(tempLdelt, xqLdelt, 'linear', 'extrap')';
    rdeltrs(:,i) = interp1(tempRdelt, xqRdelt, 'linear', 'extrap')';
    
    xqLbicep = linspace(1, length(tempLbicep), nsamp); % Resample to this length array
    xqRbicep = linspace(1, length(tempRbicep), nsamp); % Resample to this length array
    lbiceprs(:,i) = interp1(tempLbicep, xqLbicep, 'linear', 'extrap')';
    rbiceprs(:,i) = interp1(tempRbicep, xqRbicep, 'linear', 'extrap')';
end
ldeltmean = mean(ldeltrs,2);
rdeltmean = mean(rdeltrs,2);
lbicepmean = mean(lbiceprs,2);
rbicepmean = mean(rbiceprs,2);

% figure;tiledlayout(4,1)
% nexttile; plot(ldeltmean,'b'); title('Left Deltoid')
% nexttile; plot(rdeltmean,'r'); title('Right Deltoid')
% nexttile; plot(lbicepmean,'b'); title('Left Bicep')
% nexttile; plot(rbicepmean,'r'); title('Right Bicep')
%% RMS windowing (see lab book 113)
winsize = 100; % window size; must be factor of 'nsamp'
lengthArray = nsamp/winsize;
% Detrend data
ldeltDT = detrend(ldeltrs);
rdeltDT = detrend(rdeltrs);
lbicepDT = detrend(lbiceprs);
rbicepDT = detrend(rbiceprs);

% %Filter data
% bpfreq = [5 250];
% filtLdelt = bandpass(ldeltDT,bpfreq,freq);
% filtRdelt = bandpass(rdeltDT,bpfreq,freq);
% filtLbicep = bandpass(lbicepDT,bpfreq,freq);
% filtRbicep = bandpass(rbicepDT,bpfreq,freq);

% RMSE calculation
% NOTE: for some reason, I'm getting LARGE edge effects on the filtering,
% so I am removing for now. This is OK because the window RMS calc, plus
% averaging across targets, acts as a large low-pass filter. Might still
% get some low frequency articfacts (e.g. movement artifacts)
for i = 1:lengthArray
    ldeltrms(i,:) = mean(ldeltDT((i-1)*winsize+1:i*winsize,:).^2,1);
    rdeltrms(i,:) = mean(rdeltDT((i-1)*winsize+1:i*winsize,:).^2,1);
    lbiceprms(i,:) = mean(lbicepDT((i-1)*winsize+1:i*winsize,:).^2,1);
    rbiceprms(i,:) = mean(rbicepDT((i-1)*winsize+1:i*winsize,:).^2,1);
end

%% Trial timeseries for target = 'targetLoc'
% creates an output of all 16 timeseries for the 16 reaches to the target
% specified in 'targetLoc'. This can be used in R for the baseline
% correction followed by SEM calculation (in R). See lab book pg. 114.
ldeltRMStargetLoc = ldeltrms(:,find(targets == targetLoc));
rdeltRMStargetLoc = rdeltrms(:,find(targets == targetLoc));
lbicepRMStargetLoc = lbiceprms(:,find(targets == targetLoc));
rbicepRMStargetLoc = rbiceprms(:,find(targets == targetLoc));
%These are used in next section to create the export DF
%
%% Take mean by target location
ldeltrmsmean = zeros(lengthArray,6);
rdeltrmsmean = zeros(lengthArray,6);
ldeltrmsstd = zeros(lengthArray,6);
rdeltrmsstd = zeros(lengthArray,6);
lbiceprmsmean = zeros(lengthArray,6);
rbiceprmsmean = zeros(lengthArray,6);
lbiceprmsstd = zeros(lengthArray,6);
rbiceprmsstd = zeros(lengthArray,6);
for i = 5:10 % targets number from 5 to 10
    % Means
    ldeltrmsmean(:,i-4) = mean(ldeltrms(:, find(targets == i)), 2);
    rdeltrmsmean(:,i-4) = mean(rdeltrms(:, find(targets == i)), 2);
    lbiceprmsmean(:,i-4) = mean(ldeltrms(:, find(targets == i)), 2);
    rbiceprmsmean(:,i-4) = mean(rdeltrms(:, find(targets == i)), 2);
    % Standard deviations
    ldeltrmsstd(:,i-4) = std(ldeltrms(:, find(targets == i)), 0, 2);
    rdeltrmsstd(:,i-4) = std(rdeltrms(:, find(targets == i)), 0, 2);
    lbiceprmsstd(:,i-4) = std(ldeltrms(:, find(targets == i)), 0, 2);
    rbiceprmsstd(:,i-4) = std(rdeltrms(:, find(targets == i)), 0, 2);
end

% concatinate the mean/std arrays
% first create the hand and muscle factors
handL = repelem(1,lengthArray)'; % left hand = 1
handR = repelem(2,lengthArray)'; % right hand = 2
muscleD = repelem(1,lengthArray)'; % Deltoid = 1
muscleB = repelem(2,lengthArray)'; % Bicep = 2
sample = linspace(1,lengthArray,lengthArray)';
% then concat into full data arrays
% NOTE: Here is where we choose a specific target - this was done to limit
% the need for additional factoring/processing either here or in R. This is
% in response to Reviewer #2 in the healthy control study, so its highly specific for this manuscript
tempDF = [handL muscleD sample ldeltrmsmean(:,targetLoc-4) ldeltrmsstd(:,targetLoc-4);...
          handR muscleD sample rdeltrmsmean(:,targetLoc-4) rdeltrmsstd(:,targetLoc-4); ...
          handL muscleB sample lbiceprmsmean(:,targetLoc-4) lbiceprmsstd(:,targetLoc-4); ...
          handR muscleB sample rbiceprmsmean(:,targetLoc-4) rbiceprmsstd(:,targetLoc-4)];

tempDFtargetLoc = [handL muscleD sample ldeltRMStargetLoc;...
          handR muscleD sample rdeltRMStargetLoc; ...
          handL muscleB sample lbicepRMStargetLoc; ...
          handR muscleB sample rbicepRMStargetLoc];


%% Add other factors (subID, cond, block, etc.)
formatIn = 'mm_dd_yy'; % Note, this is only unique when only one participant per day is run...
subID = str2num([num2str(datenum(filename(1:8),formatIn)) filename(10:11)]); % Convert mm_dd_yy of "file" into a datenum unique integer, then add participant order (if more than one person tested per day)
cond = filename(13:14);
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

subid = ones(length(tempDF),1)*subID; % subid vector
cond = ones(length(tempDF),1)*condition; % condition vector as numeric
block = ones(length(tempDF),1)*str2num(filename(16:17)); % block (1-7 for controls, 1-3 for stroke)

%% Full dataframe for export!
rmswin = [subid cond block tempDF];
rmswinLoc = [subid cond block tempDFtargetLoc];
end