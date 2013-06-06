%Function for filling in the data from the inactivity periods, so that
%you'll end up with data for all of the time instants for the duration of
%the measurement
%if second argument is given, checks the maximum number of hours to expect
%Prefixes zeros, up to the first timeStamp of the current file if lastTimeStampFromPreviousFile is submitted
function fullData = insertInactivity(data,maxHours,lastTimeStampFromPreviousFile)
    if exist('maxHours','var')
        if (data.data.timeStamps(length(data.data.timeStamps))-data.data.timeStamps(1))*24 > maxHours
            disp(['Onset ' datestr(data.data.timeStamps(1)) ' offset ' datestr(data.data.timeStamps(length(data.data.timeStamps))) ' Hours of data in File ' num2str((data.data.timeStamps(length(data.data.timeStamps))-data.data.timeStamps(1))*24) ' more than the maximum allowed ' num2str(maxHours)]);
           fullData = [];
           return;
        end
    end
    currentIndex = 1;   %Index for current position in full data
    if ~isempty(str2num(data.header.samplingRate(1:3)))
        samplingRate = 1/str2num(data.header.samplingRate(1:3));
    else
        samplingRate = 1/str2num(data.header.samplingRate(1:2));
    end
    packetDuration = 84*samplingRate;                                               %Seconds per packet
    timeCodes = (data.data.values(1,:)-data.data.values(1,1))*24*60*60;             %Convert the timestamps to seconds and start from zero
    timeStamps = round((data.data.timeStamps-data.data.timeStamps(1))*24*60*60);    %Convert the timestamps to seconds and start from zero
    
    maxDataLength = ((timeStamps(length(timeStamps))-timeStamps(1))+2)/samplingRate;
    timeVector = zeros(1,maxDataLength);            %reserve memory for time codes
    fillVector = zeros(1,maxDataLength,'int8');     %reserve memory for insertions
    fullData = zeros(4,maxDataLength);              %Reserve memory for the data with the timecodes
    
    incontinuities = find(diff(timeStamps) > 1.5);	%If more than 1 second has elapsed between timestamps, there has been an inactivity gap. The gap is between incontinuity(i)+1 and incontinuity(i)
    %Fill in between incontinuities

    
    %Fill in first existing bit
    continuousTimeVector = [0:(incontinuities(1)*84-1)]*samplingRate;
    timeVector(currentIndex:currentIndex+length(continuousTimeVector)-1) = continuousTimeVector;
    fillVector(currentIndex:currentIndex+length(continuousTimeVector)-1) = zeros(1,length(continuousTimeVector),'int8');
    fullData(2:4,currentIndex:currentIndex+length(continuousTimeVector)-1) = data.data.values(2:4,1:length(continuousTimeVector));
    currentIndex = currentIndex+ length(continuousTimeVector);  %Position for the next bit of data
    for i = 1:length(incontinuities)
        %Fill in the existing bit prior to the next missing bit
        if i > 1
            continuousPackets = incontinuities(i)-incontinuities(i-1);
            continuousTimeVector = timeVector(currentIndex-1)+[samplingRate:(continuousPackets*84)]*samplingRate;
            timeVector(currentIndex:currentIndex+length(continuousTimeVector)-1) = continuousTimeVector;
            fillVector(currentIndex:currentIndex+length(continuousTimeVector)-1) = zeros(1,length(continuousTimeVector),'int8');
            fullData(2:4,currentIndex:currentIndex+length(continuousTimeVector)-1) = data.data.values(2:4,incontinuities(i-1)*84+1:incontinuities(i)*84);
            currentIndex = currentIndex+length(continuousTimeVector);

        end

        %Fill in the missing bit
        missingTime = timeStamps(incontinuities(i)+1)-timeVector(currentIndex-1);
        missingPackets = round(missingTime/packetDuration);
        missingTimeVector = timeVector(currentIndex-1)+[samplingRate:(missingPackets*84)]*samplingRate;
        timeVector(currentIndex:currentIndex+length(missingTimeVector)-1) =  missingTimeVector;
        fillVector(currentIndex:currentIndex+length(missingTimeVector)-1) = ones(1,length(missingTimeVector));
        currentIndex = currentIndex+length(missingTimeVector);
        %disp(['# ' num2str(i) ' missing ' num2str(length(missingTimeVector)) ' from ' num2str(currentIndex) ' to ' num2str(currentIndex+length(missingTimeVector)-1)]);
%         keyboard
    end
    %Fill in the last existing bit
    continuousPackets = (length(timeStamps)-incontinuities(i));
    continuousTimeVector = timeVector(currentIndex-1)+[samplingRate:(continuousPackets*84)]*samplingRate;
    timeVector(currentIndex:currentIndex+length(continuousTimeVector)-1) = continuousTimeVector;
    fillVector(currentIndex:currentIndex+length(continuousTimeVector)-1) = zeros(1,length(continuousTimeVector),'int8');
    fullData(2:4,currentIndex:currentIndex+length(continuousTimeVector)-1) = data.data.values(2:4,incontinuities(length(incontinuities))*84+1:size(data.data.values,2));
    currentIndex = currentIndex+length(continuousTimeVector);
    
    %Insert time to fullData
    fullData(1,:) = timeVector;
    %Remove the extra zeros from the data
    fullData = fullData(:,1:currentIndex-1);
    fillVector = fillVector(1:currentIndex-1);
    timeVector = timeVector(1:currentIndex-1);
    
    
    %Prefix with zeros from the end of the previous file, update the time
    %accordingly
    if exist('lastTimeStampFromPreviousFile','var')
%         keyboard;
        missingTime = (data.data.timeStamps(1)-lastTimeStampFromPreviousFile)*24*60*60-packetDuration;    %-packetDuration to account for the last packet in previous file
        missingPackets = round(missingTime/packetDuration);
        missingTimeVector = [samplingRate:(missingPackets*84)]*samplingRate;
        timeVector = [missingTimeVector (timeVector+missingTimeVector(length(missingTimeVector))+samplingRate)]; %Prefix the vector with the new vector and adjust the existing times
        fillVector = [ones(1,length(missingTimeVector),'int8') fillVector];
        prefixFullData = zeros(4,length(missingTimeVector));
        prefixFullData(1,:) = missingTimeVector;
        fullData(1,:) = fullData(1,:)+missingTimeVector(length(missingTimeVector))+samplingRate;    %Increment time accordingly
        fullData = [prefixFullData fullData];
        disp(['Prefixed with ' num2str(length(missingTimeVector)) ' zeros']);
    end
    
%     keyboard;  
    figure
    subplot(4,1,1)
    plot(timeVector,fillVector)
    set(gca,'ylim',[0 1.1]);
    for i = 2:4
        subplot(4,1,i)
        plot(fullData(1,:),fullData(i,:))
    end
    disp(['Onset ' datestr(data.data.timeStamps(1)) ' offset ' datestr(data.data.timeStamps(length(data.data.timeStamps))) '; ' num2str(size(fullData,2)/(100*60*60)) ' hours of data ' num2str((data.data.timeStamps(length(data.data.timeStamps))-data.data.timeStamps(1))*24) ' h expected']);
%     keyboard;    
end