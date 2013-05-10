clear all;
close all;
fclose all;
clc;
addpath('TRXDatReader');
parameters.lahde = 'C:\MyTemp\oma\Timon\tyo\AquaRehab2012\Analysis\Accelerometry\Koe_phase I\AH170246';
% fileToRead = 'C:\MyTemp\oma\Timon\tyo\AquaRehab2012\Analysis\Accelerometry\Koe_phase I\AH170246\DATA0002.DAT';
% fileToRead = 'C:\MyTemp\oma\Timon\tyo\AquaRehab2012\Analysis\Accelerometry\Koe_phase I\AH170246\DATA0022.DAT';
D = dir([parameters.lahde '\*.dat']);
mones = length(D);
tietoja = 10000;
for iii = 1:length(D)
    data = readTRXDat([parameters.lahde '\' D(iii).name]);
    figure
    colourCodes = {'k','r','b'};
    for ii = 1:3
        subplot(1,3,ii)
        plot(data.data(ii+1,:),colourCodes{ii})
    end
end
