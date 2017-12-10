function [trainingImages, trainLabels, testingImages, testingLabels] = getDataSet(images, labels, percentInTraining)
    % getDataSet Split the dataset into training and testing set
    % Inputs:
    %   images Cell array of images with each cell being XxYx3
    %   labels Cell array with each cell containing the ground truth
    %   percentInTraining Percent of dataset to put into training set
    % Outputs:
    %   trainingImages Cell array of training images
    %   trainLabels Cell array of labels for corresponding training images
    %   testingImages Cell array of testing images
    %   testingLabels Cell array of labels for corresponding testing images
    
    %% For testing the function
    %images = cell(1000, 1);
    %labels = cell(1000, 1);
    %percentInTraining = 0.8;
    
    %% Shuffle images and labels
    idxs = 1 : 1 : length(images);
    idxs = idxs(randperm(length(idxs)));
    
    %% Split images and labels into training and testing
    train_size = ceil(length(images) * percentInTraining);    
    trainingImages = images(idxs(1 : train_size));
    trainLabels = labels(idxs(1 : train_size));
    testingImages = images(idxs(train_size + 1 : end));
    testingLabels = labels(idxs(train_size + 1 : end));
end