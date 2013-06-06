%Read a HOOKIE file sample
clear all;
close all;
fclose all;
clc;
addpath('TRXDatReader');
fileToRead = 'C:\path\to\your\file\DATAFILE.DAT';
data = readTRXDat(fileToRead);          %Read the data from the file
fullData = insertInactivity(data,48);   %Insert the inactivity periods The second parameter limits the amount of data to 48 h. I tried to reconstruct a file with 120+ h of data, which crashed my machine...