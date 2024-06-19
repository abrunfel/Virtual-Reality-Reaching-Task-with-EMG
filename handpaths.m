% Creating mean hand path
% Run vr_exo_kinematics_indiv.m first

%% Resample
for i = 1:length(trialData)
    trials_lh = trialData(i).lh'; % get lh data from onset-offset
    trials_rh = trialData(i).rh'; % get lh data from onset-offset
    xq = linspace(1, length(trials_lh), 75); % Resample to this length array
    % resampled 3-d position data
    lhrs = interp1(trials_lh, xq, 'linear', 'extrap');
    rhrs = interp1(trials_rh, xq, 'linear', 'extrap');
    % compile x,y,z vectors
    lhx(:,i) = lhrs(:,1);
    lhy(:,i) = lhrs(:,2);
    lhz(:,i) = lhrs(:,3);
    rhx(:,i) = rhrs(:,1);
    rhy(:,i) = rhrs(:,2);
    rhz(:,i) = rhrs(:,3);
end

%% Take mean by target location
lhxmean = zeros(75,6);
rhxmean = zeros(75,6);
lhymean = zeros(75,6);
rhymean = zeros(75,6);
lhzmean = zeros(75,6);
rhzmean = zeros(75,6);
for i = 5:10 % targets number from 5 to 10
    lhxmean(:,i-4) = mean(lhx(:, find(targetSpawn(1,:) == i)), 2);
    lhymean(:,i-4) = mean(lhy(:, find(targetSpawn(1,:) == i)), 2);
    lhzmean(:,i-4) = mean(lhz(:, find(targetSpawn(1,:) == i)), 2);
    rhxmean(:,i-4) = mean(rhx(:, find(targetSpawn(1,:) == i)), 2);
    rhymean(:,i-4) = mean(rhy(:, find(targetSpawn(1,:) == i)), 2);
    rhzmean(:,i-4) = mean(rhz(:, find(targetSpawn(1,:) == i)), 2);
end
%% Plotting
figure % I am only looking at 2-d x,y plots to get the "top-down" view
plot(lhxmean,lhymean)
hold on
plot(rhxmean,rhymean)
%% Old plotting for verification purposes

% figure % Plot individual trial
% i = 3;
% plot(trialData(i).lh(1,:), trialData(i).lh(2,:), 'bo');
% hold on;
% plot(lhx(:,i), lhy(:,i), 'r');

% Pre-resample data
% Since the 3-d graphs are so difficult to view, only plot the "top-down"
% perspective (that is the x,y values, which are x-z values in Unity space)

% figure % Plot all trials in block
% for i = 1:length(trialData)
%     plot(trialData(i).lh(1,:), trialData(i).lh(2,:), 'bo');
%     hold on;
%     plot(trialData(i).rh(1,:), trialData(i).rh(2,:), 'ro');
%     hold on;
%     plot(lhx(:,i),lhy(:,i),'b',rhx(:,i),rhy(:,i),'r')
%     hold on;
% end