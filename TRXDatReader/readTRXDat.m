%Function for reading Hookie AM 20 accelerometer data from the .DAT -file
%produced by the accelerometer. I got the specification from Jouni
%Lunnasmaa of Traxmeet Ltd (the manufacturer of the accelerometer).
%Written by Timo Rantalainen 2013 (tjrantal @ gmail.com)
%Licensed with the GPL 3.0 license
%(http://www.gnu.org/licenses/gpl-3.0.html)

%%Input:    fileToRead  = file name to be read
%%Returns:  data        = structure containing the data
%%                          data.header is the header info
%%                          data.data is matrix of data from file (4xinf),
%%                          columns: timestamp, x (in mg), y, z
function data = readTRXDat(fileToRead)
    global pointer;                         %Store the pointer in memory between functions
    file = fopen(fileToRead,'r');           %Open the file for reading
    dataToMem = fread(file,inf,'uint8');   %Read file as 8 bit chars
    fclose(file);                           %Close the data file
    % keyboard;
    data = struct();                        %Init the return struct
    pointer = 1;                            %set pointer to the beginning of the file in memory
    data.header = readHeader(dataToMem);    %Read header, pointer will also be set to the beginning of the first data packet
    data.data   = readData(dataToMem);  
%     disp('Done reading');
    %End of readTRXDat
end
