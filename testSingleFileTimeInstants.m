clear all;
close all;
fclose all;
clc;
addpath('TRXDatReader');
fileToRead = 'DATA0002.DAT';
data = readTRXDat(fileToRead);
%figure
%colourCodes = {'k','r','b'};
%for ii = 1:3
%    subplot(4,1,ii)
%    plot(data.data(ii+1,:)*32/2^13,colourCodes{ii})
%end
%subplot(4,1,4)
%plot(data.data(1,:),'k')
timeCodes = data.data(1,:)*24*60*60;	%Convert the timestamps to seconds
timeVector =[];%= zeros(1,timeCodes(length(timeCodes))-timeCodes(1)+1);	%reserve some memory for time codes
timeVector(1) = timeCodes(1);	%Start timeVector from the initial timestamp
incontinuities = find(diff(timeCodes) > 1.5);	%If more than 1 second has elapsed between timestamps, there has been an inactivity gap. The gap is between incontinuity(i) and incontinuity(i-1)
%Visualize the gaps
%figure
%plot(timeCodes,'b');
%hold on;
%plot(incontinuities,timeCodes(incontinuities),'r*');
%Seconds to fill up to
fillTo = timeCodes(incontinuities);	%Start working up the timeCodes and the data. Fill in with last value to get up to the timeCode, if the current timestamp is lower than the timeCode. Fill in bouts of 84 values, which is the data packet size...
fillingGap =1;
fillVector = 0;% zeros(1,timeCodes(length(timeCodes))-timeCodes(1)+1);	%reserve some memory for time codes
timeVectorIndices = 1;
i = 1;
while i < size(data.data,2) %Go through data and create timeVector and fillVector
	if timeCodes(i) <fillTo(fillingGap)
		for j = 1:84	
			if i == 1
				%First data instant has already been filled in
			else
				timeVector(timeVectorIndices) = timeVector(timeVectorIndices-1)+0.01;
				fillVector(timeVectorIndices) = 0;
				
			end
			i = i+1;
			timeVectorIndices= timeVectorIndices+1;
		end
	else
		%Fill the gap
		if fillingGap <= length(fillTo)
			while timeVector(timeVectorIndices) < fillTo(fillingGap)
				for j = 1:84	
					timeVector(timeVectorIndices) = timeVector(timeVectorIndices-1)+0.01;
					fillVector(timeVectorIndices) = 1;
					timeVectorIndices= timeVectorIndices+1;
				end
			end
			fillingGap =fillingGap+1;
		end
	end
end
figure
plot(timeVector);

