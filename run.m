% load images and corresponding labels
[images, labels] = getCaptchsAndLabels();
% split data into training set and testing set
[trainImages, trainLabels, testImages, testLabels] = getDataSet(images, labels, 0.8);
% train the model
% recognize the CAPTCHAs from the testing set
% calculate the accuracy
