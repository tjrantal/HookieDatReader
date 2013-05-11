clear all;
close all;
fclose all;
clc;
addpath('TRXDatReader');
fileToRead = 'DATA0002.DAT';
data = readTRXDat(fileToRead);
figure
colourCodes = {'k','r','b'};
for ii = 1:3
    subplot(4,1,ii)
    plot(data.data(ii+1,:),colourCodes{ii})
end
subplot(4,1,4)
plot(data.data(1,:),'k')

