%% Cleanup
close all;
clc;

%% Read images and labels
[images, labels] = getCaptchsAndLabels();

%% Construct testing and training sets
[trainImages, trainLabels, testImages, testLabels] = getDataSet(images, labels, 0.8);

%% Train Model
model = fitModel(trainImages, trainLabels);

%% Test Model  
%model = load('baselineModel.mat');
%model = model.model;
actual_labels = {};
predicted_labels = {};
for i = 1 : length(testImages)
    pred_capt = recognizeCaptcha(model, testImages{i});
    if isempty(pred_capt)
        continue
    end
    predicted_labels = [predicted_labels; pred_capt];
    actual_labels = [actual_labels; testLabels{i}];
end

%% Compute accuracy
calAccuracy(predicted_labels, actual_labels)

