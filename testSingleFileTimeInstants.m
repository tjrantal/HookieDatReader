clear all;
close all;
fclose all;
clc;
addpath('TRXDatReader');
% fileToRead = 'DATA0002.DAT';
fileToRead = 'C:\MyTemp\oma\Timon\tyo\AquaRehab2012\Analysis\Accelerometry\Koe_phase I\AH170246\DATA0004.DAT';
data = readTRXDat(fileToRead);
%figure
%colourCodes = {'k','r','b'};
%for ii = 1:3
%    subplot(4,1,ii)
%    plot(data.data(ii+1,:)*32/2^13,colourCodes{ii})
%end
%subplot(4,1,4)
%plot(data.data(1,:),'k')
timeCodes = (data.data.values(1,:)-data.data.values(1,1))*24*60*60;	%Convert the timestamps to seconds
timeStamps = round((data.data.timeStamps-data.data.timeStamps(1))*24*60*60); %Convert the timestamps to seconds
timeVector =[];%= zeros(1,timeCodes(length(timeCodes))-timeCodes(1)+1);	%reserve some memory for time codes
timeVector(1) = timeCodes(1);	%Start timeVector from the initial timestamp
incontinuities = find(diff(timeStamps) > 1.5);	%If more than 1 second has elapsed between timestamps, there has been an inactivity gap. The gap is between incontinuity(i)+1 and incontinuity(i)
if ~isempty(str2num(data.header.samplingRate(1:3)))
    samplingRate = 1/str2num(data.header.samplingRate(1:3));
else
    samplingRate = 1/str2num(data.header.samplingRate(1:2));
end

%Just fill in between incontinuities
%Fill in first existing bit
timeVector = [0:(incontinuities(1)*84-1)]*samplingRate;
fillVector = zeros(1,length(timeVector),'int8');

packetDuration = 84*samplingRate;
for i = 1:length(incontinuities)
    %Fill in the existing bit prior to the next missing bit
    if i > 1
        continuousPackets = incontinuities(i)-incontinuities(i-1);
        continuousTimeVector = timeVector(length(timeVector))+[samplingRate:(continuousPackets*84)]*samplingRate;
        timeVector = [timeVector, continuousTimeVector];
        fillVector = [fillVector,  zeros(1,length(continuousTimeVector),'int8')];
        
    end
    
    %Fill in the missing bit
    missingTime = timeStamps(incontinuities(i)+1)-timeVector(length(timeVector));
    missingPackets = round(missingTime/packetDuration);
    missingTimeVector = timeVector(length(timeVector))+[samplingRate:(missingPackets*84)]*samplingRate;
    timeVector = [timeVector, missingTimeVector];
    fillVector = [fillVector,  ones(1,length(missingTimeVector),'int8')];
end
%Fill in the last existing bit
continuousPackets = (length(timeStamps)-incontinuities(i));
continuousTimeVector = timeVector(length(timeVector))+[samplingRate:(continuousPackets*84)]*samplingRate;
timeVector = [timeVector, continuousTimeVector];
fillVector = [fillVector,  zeros(1,length(continuousTimeVector),'int8')];

timeStamps(length(timeStamps))-timeVector(length(timeVector))

plot(timeVector,fillVector)
set(gca,'ylim',[0 1.1]);
hold on;
plot(timeStamps(incontinuities),ones(1,length(incontinuities)),'r*','linestyle','none');
% max(timeStamps)-max(timeVector)
% 
% incontTimeVector = timeVector(find(diff(fillVector > 0.5)>0.5));
% incontStamps = timeStamps(incontinuities);
% incont = [incontStamps; incontTimeVector];
% 
% differences = timeStamps(incontinuities)-timeVector(find(diff(fillVector > 0.5)>0.5));
% %Fill in the last existing bit
% timeVector = [0:(incontinuities(1)*84-1)]*samplingRate;
% fillVector = zeros(1,length(timeVector),'int8');
% 
% %timeVector = [timeVector, (timeCodes(1):0.01:timeCodes(1)+incontinuities(1)];
% 
% %Visualize the gaps
% %figure
% %plot(timeCodes,'b');
% %hold on;
% %plot(incontinuities,timeCodes(incontinuities),'r*');
% %Seconds to fill up to
% fillTo = timeCodes(incontinuities);	%Start working up the timeCodes and the data. Fill in with last value to get up to the timeCode, if the current timestamp is lower than the timeCode. Fill in bouts of 84 values, which is the data packet size...
% fillingGap =1;
% fillVector = 0;% zeros(1,timeCodes(length(timeCodes))-timeCodes(1)+1);	%reserve some memory for time codes
% timeVectorIndices = 1;
% i = 1;
% while i < size(data.data.values,2) %Go through data and create timeVector and fillVector
% 	if timeCodes(i) <fillTo(fillingGap)
% 		for j = 1:84	
% 			if i == 1
% 				%First data instant has already been filled in
% 			else
% 				timeVector(timeVectorIndices) = timeVector(timeVectorIndices-1)+0.01;
% 				fillVector(timeVectorIndices) = 0;
% 				
% 			end
% 			i = i+1;
% 			timeVectorIndices= timeVectorIndices+1;
% 		end
% 	else
% 		%Fill the gap
% 		if fillingGap <= length(fillTo)
% 			while timeVector(timeVectorIndices-1) < fillTo(fillingGap)
% 				for j = 1:84	
% 					timeVector(timeVectorIndices) = timeVector(timeVectorIndices-1)+0.01;
% 					fillVector(timeVectorIndices) = 1;
% 					timeVectorIndices= timeVectorIndices+1;
% 				end
% 			end
% 			fillingGap =fillingGap+1;
% 		end
% 	end
% end
% figure
% plot(timeVector);

