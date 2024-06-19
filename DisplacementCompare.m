% Creating mean hand path
% Run vr_exo_kinematics_indiv.m first

%% Resample
for i = 1:length(trialData)
    trials_lh = trialData(i).lhDisp'; % get lh data from onset-offset
    trials_rh = trialData(i).rhDisp'; % get lh data from onset-offset
    xq = linspace(1, length(trials_lh), 75)'; % Resample to this length array
    % resampled 3-d position data
    lhDrs = interp1(trials_lh, xq, 'linear', 'extrap');
    rhDrs = interp1(trials_rh, xq, 'linear', 'extrap');
    % compile x,y,z vectors
    lhD(:,i) = lhDrs(:,1);
    rhD(:,i) = rhDrs(:,1);
end

%% Take mean by target location
lhDmean = zeros(75,6);
rhDmean = zeros(75,6);
lhDstd = zeros(75,6);
rhDstd = zeros(75,6);
for i = 5:10 % targets number from 5 to 10
    % Means
    lhDmean(:,i-4) = mean(lhD(:, find(targetSpawn(1,:) == i)), 2);
    rhDmean(:,i-4) = mean(rhD(:, find(targetSpawn(1,:) == i)), 2);
    % Standard deviations
    lhDstd(:,i-4) = std(lhD(:, find(targetSpawn(1,:) == i)), 0, 2);
    rhDstd(:,i-4) = std(rhD(:, find(targetSpawn(1,:) == i)), 0, 2);
end
%
%% Dataframe preparations

%
%% Plotting
close all
% Plot lh vs. rh dispalcement for the 16 trials to target 7 (listed a 3
% here because of the i-4 in previous section's for-loop)
figure; plot(lhDmean(:,3),'b'); hold on; plot(rhDmean(:,3),'r');
legend('LH disp', 'RH disp', 'Location', 'northwest'); title('Target 7: midline, eye level')

figure; errorbar(lhDmean(:,3), lhDstd(:,3),'b'); hold on; errorbar(rhDmean(:,3), rhDstd(:,3), 'r');
legend('LH disp', 'RH disp', 'Location', 'northwest'); title('Target 7: midline, eye level')
