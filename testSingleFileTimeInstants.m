clear all;
close all;
fclose all;
clc;
addpath('TRXDatReader');
% fileToRead = 'DATA0002.DAT';
fileToRead = 'C:\MyTemp\oma\Timon\tyo\AquaRehab2012\Analysis\Accelerometry\Koe_phase I\AH170246\DATA0001.DAT';
data = readTRXDat(fileToRead);
fullData = insertInactivity(data,48);
