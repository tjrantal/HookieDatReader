clear all;
close all;
fclose all;
clc;
addpath('TRXDatReader');
% fileToRead = 'DATA0002.DAT';
fileToRead = 'C:\MyTemp\oma\Timon\tyo\AquaRehab2012\Analysis\Accelerometry\Koe_phase I\AH170246\DATA0004.DAT';
data = readTRXDat(fileToRead);
figure
colourCodes = {'k','r','b'};
for ii = 1:3
    subplot(4,1,ii)
    plot(data.data.values(ii+1,:)*32/2^13,colourCodes{ii})
end
subplot(4,1,4)
plot(data.data.values(1,:),'k')

