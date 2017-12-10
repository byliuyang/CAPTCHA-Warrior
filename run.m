close all;
% load images and corresponding labels
[images, labels] = getCaptchsAndLabels();
% split data into training set and testing set
[trainImages, trainLabels, testImages, testLabels] = getDataSet(images, labels, 0.8);
% train the model
% recognize the CAPTCHAs from the testing set
% calculate the accuracy
figure;
I = trainImages{1};
subplot(2, 2, 1);
imshow(I);

I = removeBackgroundColor(I);
subplot(2, 2, 2);
imshow(I)

I = removeLines(I);
subplot(2, 2, 3);
imshow(I)