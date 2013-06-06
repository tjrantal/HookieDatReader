%Sample code for testing the reader
clear all;
close all;
fclose all;
clc;
addpath('TRXDatReader');
fileToRead = 'C:\Path\to\HookieFile\DATAFILE.DAT';
data = readTRXDat(fileToRead);
fullData = insertInactivity(data,48);
