%##########################################################################
%###########"Dataset: Continuous Human Activities Utilizing################
%###########    Three Pulsed Radars Exploiting Multipath" #################
%###########           Range Time Map example             #################
%###########     of the public dataset of TU Delft        #################
%########### pulsON P410 radar from TimeDomain (Humatics) #################
%##########################################################################
%
%--------------------------------------
% Author:       Ronny (Gerhard) Guendel
% Written by:   Microwave Sensing, Signals and Systems (MS3)
% University:   TU Delft
% Email:        r.guendel@icloud.com
% Created:      22/12/2023
% Updated:      22/12/2023

% Description:
% This example script computes a plots the range time maps collected with
% the pulsON P410 radar from TimeDomain (Humatics) for the Multipath data
% from https://data.4tu.nl/.
%
% Entitled as: "Dataset: Continuous Human Activities Utilizing Three
% Pulsed Radars Exploiting Multipath"

%% set clear
clc; clear all; close all;

%% Loading the .mat file
[file,path] = ...
    uigetfile('*range_time_maps_labeled.mat','MultiSelect','on');


% convert char to cell arry if only one file is selected
if isfloat(file), error('No files selected'),end
% Clean up return string if only one file; figment from 'multiselect'
if isstr(file), file={file}; end  % convert char string to cellstr

%% load data
for kj = 1:length(file)

    %% open the data file
    data = load(string(fullfile(path,file{kj}))); % radar placed right for MPE
    

    %% copy data  and variables
    % copy data
    dataMatrix{1} = data.dataMatrix_101;
    dataMatrix{2} = data.dataMatrix_102;
    dataMatrix{3} = data.dataMatrix_103;

    % copy variables
    np = data.np;

    %% copy timestamps and labels and slowtime freq. (PRF)
    % timestamp data in milliseconds
    % tstmp10x are the timestamps when range pulsed were received
    % those timestamps can be used to incoherently syncronize the radars
    tstmp{1}      = np.tstmp101;
    tstmp{2}      = np.tstmp102;
    tstmp{3}      = np.tstmp103;

    label_vec{1}  = np.label_vec_101;
    label_vec{2}  = np.label_vec_101;
    label_vec{3}  = np.label_vec_101;

    % Slightly different showtime sample frequency due to separate oscillators
    fs_slow{1}    = np.fs_slow_101;
    fs_slow{2}    = np.fs_slow_102;
    fs_slow{3}    = np.fs_slow_103;
    clearvars data

    %% Defining the errliest timestamp
    tstmp_earliest= min([tstmp{1}(1),tstmp{2}(1),tstmp{3}(1)]);

    %% Plot the corresponding range mapswith samples
    figure(1);
    for ii = 1:length(dataMatrix)
        tstmp_sec_tmp = 1e3\(tstmp{ii}-tstmp_earliest); % Label vectors in sec
        dataMatrix_tmp = dataMatrix{ii} - mean(dataMatrix{ii},2);
        subplot(length(dataMatrix)+1,1,ii);
        imagesc(tstmp_sec_tmp, np.range_vec,20*log10(abs(dataMatrix_tmp))); axis xy
        clim = get(gca,'CLim');
        set(gca,'CLim',clim(2) + [-60 -10]);
        colormap('jet'); axis xy; colorbar('east');
        xlabel("Time (s)"); ylabel("Range (m)");
        title(sprintf('Radar %i',ii),'Interpreter','latex');
        % plot the label vectors
        subplot(length(dataMatrix)+1,1,length(dataMatrix)+1);
        plot(tstmp_sec_tmp,label_vec{ii}+ii/10,':'); % shift the label slightly in height [...+ii/10]
        hold on;
        lgd{ii} = strcat('Label Radar: ',num2str(ii)) ;

        clearvars tstmp_sec_tmp dataMatrix_tmp
    end
    legend(lgd); clearvars lgd
    xlabel("Time (s)");
    xlim([-inf inf]); ylim([-0.5 12]); grid on;
    set(gca,'ytick',np.label_name_idx,'yticklabel',np.label_names);
    set(gcf,'Position',[50 50 1000 1000]);
    
    disp('Press any key to continue!');
    pause;
    close all; 

end