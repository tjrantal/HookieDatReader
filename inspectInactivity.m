close all;
epoch = 100:500;
scaledData = data.data(2:4,epoch)*32/2^13;
resultant = sqrt(sum(scaledData.^2));
seconds = data.data(1,epoch)*24*60*60;
seconds = seconds-seconds(1);
figure
subplot(2,1,1)
plot(resultant)
title('resultant')
subplot(2,1,2)
plot(seconds)
title('seconds')
