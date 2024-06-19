% Compiling code to generate R dataframes
clear all
close all

% Select current directory
if strcmp(computer, 'PCWIN64')
    cd('C:\Users\REDACTED');    
else
    cd('/Users/REDACTED');
end

dir_list = dir('exovr*.mat');    %Store subject *mat data file names in variable (struct array).
dir_list = {dir_list.name}; % filenames
dir_list = sort(dir_list);  % sorts files
numFiles = length(dir_list);


for i = 1:numFiles
   load(char(dir_list(i)));
   
   % Switch to post-compile folder
   if strcmp(computer, 'PCWIN64')
       cd('C:\Users\REDACTED');
   else
       cd('/Users/REDACTED');
   end
   
   % Write data to file, appending as loop runs
   dlmwrite('exovr_postMatlab', DFexport, '-append', 'delimiter', ',', 'precision', '%.6f');
   
   % Select current directory
   if strcmp(computer, 'PCWIN64')
       cd('C:\Users\REDACTED');
   else
       cd('/Users/REDACTED');
   end
end
