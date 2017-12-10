%% Cleanup
close all;
clc;

%% Read images and labels
[images, labels] = getCaptchsAndLabels();

%% Construct testing and training sets
[trainImages, trainLabels, testImages, testLabels] = getDataSet(images, labels, 0.8);

%% Train Model
[char_imgs, char_lbls] = splitCharacters(trainImages{1}, trainLabels{1});

%% Test Model


%% Compute accuracy


