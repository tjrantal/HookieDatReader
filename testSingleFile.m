clear all;
close all;
fclose all;
clc;
addpath('TRXDatReader');
% parameters.lahde = 'C:\MyTemp\oma\Timon\tyo\AquaRehab2012\Analysis\Accelerometry\Koe_phase I\AH170246';
% fileToRead = 'DATA0002.DAT';
fileToRead = 'C:\MyTemp\oma\Timon\tyo\AquaRehab2012\Analysis\Accelerometry\Koe_phase I\AH170246\DATA0004.DAT';% fileToRead = 'C:\MyTemp\oma\Timon\tyo\AquaRehab2012\Analysis\Accelerometry\Koe_phase I\AH170246\DATA0022.DAT';
% D = dir([parameters.lahde '\*.dat']);
% mones = length(D);
% tietoja = 10000;
% for iii = 1:length(D)
%     data = readTRXDat([parameters.lahde '\' D(iii).name]);
    data = readTRXDat(fileToRead);
    figure
    colourCodes = {'k','r','b'};
    titleText = {'X','Y','Z'};
    for ii = 1:3
        subplot(4,1,ii)
        plot((data.data.values(ii+1,:)/2^12*16),colourCodes{ii})
        title(titleText{ii});
    end
    %Plot timeStamps
    subplot(4,1,4)
    plot(data.data.values(1,:))
    title('Timestamps as datenums');
% end
