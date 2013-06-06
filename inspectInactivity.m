close all;
epoch = 100:500;
scaledData = data.data.values(2:4,epoch)*32/2^13;
resultant = sqrt(sum(scaledData.^2));
figure
plot(resultant)
title('resultant')
