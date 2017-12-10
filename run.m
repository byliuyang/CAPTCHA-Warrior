%% Cleanup
close all;
clc;

%% Read images and labels
[images, labels] = getCaptchsAndLabels();

%% Construct testing and training sets
[trainImages, trainLabels, testImages, testLabels] = getDataSet(images, labels, 0.8);

%% Train Model
chars = extractCharacters(trainImages{1});

%% Test Model


%% Compute accuracy


