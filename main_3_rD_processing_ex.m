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
    uigetfile('*_rangeDoppler_maps_labeled.mat','MultiSelect','on');

% convert char to cell arry if only one file is selected
if isfloat(file), error('No files selected'),end
% Clean up return string if only one file; figment from 'multiselect'
if isstr(file), file={file}; end  % convert char string to cellstr

% Main loop
for kj = 1:length(file)
    data = load(string(fullfile(path, file{kj}))); % Load data

    % Assign variables from data
    [rd_tensors, range_fdMap_vec, label_vecs, label_names, info] = unpackData(data);

    % Display FFT Analysis Parameters
    displayFFTInfo(info, 1);

    % Set up figure for range Doppler images
    setupFigure(2, [450 50 1200 900]);

    % Get hop_show_interval
    N = length(label_vecs{1});
    hop_show_interval = hopIntervalInput(N);

    % Plot range Doppler images
    for n = 1:hop_show_interval:N
        plotRangeDopplerImages(rd_tensors, range_fdMap_vec, label_vecs, label_names, n);
        fprintf("The label %i -- %s of range Doppler %i of slowtime sample %i\n", ...
            label_vecs{1}(n), label_names{label_vecs{1}(n)+1}, n, kj);
        pause(0.3);
    end
end


%% functions

function [rd_tensors, range_fdMap_vec, label_vecs, label_names, info] = unpackData(data)
    rd_tensors = {data.rd_tensor_101, data.rd_tensor_102, data.rd_tensor_103};
    range_fdMap_vec = {data.np_rd.fd_rdMap_ve, data.np_rd.range_rdMap_vec};
    label_vecs = {data.np_rd.label_vec_101, data.np_rd.label_vec_102, data.np_rd.label_vec_103};
    label_names = data.np_rd.label_names;
    info = data.np_rd.info;
end


function displayFFTInfo(info, figNumber)
    % Define window size and position
    windowSize = [50, 100, 400, 250]; % [left, bottom, width, height]

    % Create or bring to front the figure
    figure(figNumber);
    set(gcf, 'Name', 'FFT Analysis Parameters', 'NumberTitle', 'off', 'Position', windowSize);
    clf;

    % Create text box with padding
    padding = 20;
    uicontrol('Style', 'text', 'Position', [padding, padding, windowSize(3)-2*padding, windowSize(4)-2*padding], ...
              'String', info, 'FontSize', 14, 'HorizontalAlignment', 'left', 'BackgroundColor', 'white');
end



function setupFigure(figNumber, position)
    if ~ishandle(figNumber)
        figure(figNumber);
        set(gcf, 'Position', position);
    else
        figure(figNumber); clf;
    end
end


function plotRangeDopplerImages(rd_tensors, range_fdMap_vec, label_vecs, label_names, n)
    for i = 1:3
        subplot(2, 3, i);
        imagesc(rd_tensors{i}(:,:,n));
        axis xy; colorbar; colormap jet;
        title(sprintf('Radar %i [pixel], act: %s', i, label_names{label_vecs{i}(n)+1}));
        ylabel('Pixel'); xlabel('Pixel');
    end
    for i = 1:3
        subplot(2, 3, i + 3);
        imagesc(range_fdMap_vec{1}, range_fdMap_vec{2}, rd_tensors{i}(:,:,n));
        axis xy; colorbar; colormap jet;
        title(sprintf('Radar %i [range,Doppler]', i));
        ylabel('Range (m)'); xlabel('Doppler (Hz)');
    end
end


function [hop_show_interval] = hopIntervalInput(N)
    % Initialize hop_show_interval with a default value
    hop_show_interval = 4;

    % Create a figure for the input dialog
    inputFig = figure('Name', 'Enter Hop Show Interval', 'NumberTitle', 'off', 'Position', [300, 300, 250, 150]);

    % Add an edit text box for input
    editBox = uicontrol('Style', 'edit', 'Position', [75, 80, 100, 20], 'String', num2str(hop_show_interval));

    % Add a text label for instruction
    uicontrol('Style', 'text', 'Position', [25, 110, 200, 40], 'String', ...
              'Enter a value (4-20 recommended):', 'HorizontalAlignment', 'center');

    % Add a push button for confirmation
    confirmButton = uicontrol('Style', 'pushbutton', 'Position', [75, 40, 100, 20], 'String', 'Confirm', ...
                              'Callback', {@confirmCallback, N}); % Pass N as an extra parameter

    % Wait for the figure to close before continuing
    uiwait(inputFig);

    % Function to be called when 'Confirm' button is pressed
    function [hop_show_interval] = confirmCallback(src, event, N)
        hop_show_interval = str2double(get(editBox, 'String'));

        % Check if the input is within the valid range
        if hop_show_interval < 1 || hop_show_interval > N || isnan(hop_show_interval)
            msgbox('Please enter a valid number in the range!', 'Error', 'error');
        else
            uiresume(inputFig);
            close(inputFig);
        end
    end
end























