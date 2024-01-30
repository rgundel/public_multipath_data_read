%##########################################################################
%###########"Dataset: Continuous Human Activities Utilizing################
%###########    Three Pulsed Radars Exploiting Multipath" #################
%###########      Micro Doppler spectrogram example       #################
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
% This example script computes the micro-Doppler spectrograms extracted
% from the range time maps of the pulsON P410 radar from TimeDomain  
% (Humatics) for the Multipath data from https://data.4tu.nl/.
%
% Entitled as: "Dataset: Continuous Human Activities Utilizing Three
% Pulsed Radars Exploiting Multipath"


%% set clear
clc; clear all; close all;

%% Loading the .mat file
[file,path] = ...
    uigetfile('*microDoppler_spectrograms_labeled.mat','MultiSelect','on');

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
    mD_matrix      = data.mD_matrix;
    
    % copy variables
    t_mD            = data.np_mD.t_mD;
    f_mD            = data.np_mD.f_mD;
    label_vec_mD    = data.np_mD.label_vec_mD;
    label_names     = data.np_mD.label_names;
    label_name_idx  = data.np_mD.label_name_idx;
    
    
    %%
    for ii = 1:length(mD_matrix)        
        % show the micro-Doppler spectrogram
        figure(1);
        subplot(length(mD_matrix)+1,1,ii);
        imagesc(t_mD{ii},f_mD{ii}, 10*log10(abs(mD_matrix{ii}).^2));
        title(sprintf('Radar %i',ii),'Interpreter','latex');
        axis xy;
        ylabel('Doppler (Hz)');
        xlabel('Time (s)');
        colormap jet;
        colorbar('east');
        clim = get(gca,'CLim');
        set(gca,'CLim',clim(2) + [-60 -10]);
    end
    
    %% labels 
    figure(1);
    subplot(length(mD_matrix)+1,1,ii);
    imagesc(t_mD{ii},f_mD{ii}, 10*log10(abs(mD_matrix{ii}).^2));
    title(sprintf('Radar %i',ii),'Interpreter','latex');
    axis xy;
    ylabel('Doppler (Hz)');
    xlabel('Time (s)');
    colormap jet;
    colorbar('east');
    clim = get(gca,'CLim');
    set(gca,'CLim',clim(2) + [-60 -10]);
    for ii = 1:length(mD_matrix)
        % plot the label vectors
        subplot(length(mD_matrix)+1,1,length(mD_matrix)+1);
        plot(t_mD{ii},label_vec_mD{ii}+ii/10,':'); % shift the label slightly in height [...+ii/10]
        hold on;
        lgd{ii} = strcat('Label Radar: ',num2str(ii)) ;
    end
    legend(lgd); clearvars lgd
    xlabel("Time (s)");
    xlim([-inf inf]); ylim([-0.5 12]); grid on;
    set(gca,'ytick',label_name_idx,'yticklabel',label_names);
    set(gcf,'Position',[50 50 1000 1000]);
    disp('Press any key to continue!');
    pause;
    close all; 
end

























