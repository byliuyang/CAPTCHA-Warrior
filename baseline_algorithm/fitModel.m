function model = fitModel(characterImages, labels)
    % fitModel Use the given images and labels to train a model
    % Inputs:
    %   characterImages Cell array of all CAPTCHAS in train set
    %   labels Cell array of ground truth label of CAPTCHA in train set
    % Outputs:
    %   model Trained CNN model with 2 hidden layers
    
    %% Split the CAPTCHA image into character images
    imgs = {};
    lbls = {};
    for i = 1 : length(characterImages)
        [im, lbl] = splitCharacters(characterImages{i}, labels{i});
        if isempty(im) || isempty(lbl)
            continue
        end
        imgs = [imgs; im];
        lbls = [lbls; lbl];
    end
    
    %% Compute the binary labels for the different classes for ground truth
    classes = {'0','1','2','3','4','5','6','7','8','9','a','b','c','d',...
               'e','f','g','h','i','j','k','l','m','n','o','p','q','r',...
               's','t','u','v','w','x','y','z'};
    bin_lbls = zeros(length(classes), length(imgs));
    for i = 1 : length(imgs)
        bin_lbls(:,i) = strcmp(classes, lbls{i});
    end
    
    %% Compute first hidden layer
    rng('default');
    hiddenSize1 = 100;
    autoEnc1 = trainAutoencoder(imgs, hiddenSize1, 'MaxEpochs',100, ...
                                'L2WeightRegularization',0.004, ...
                                'SparsityRegularization',4, ...
                                'SparsityProportion',0.15, ...
                                'ScaleData', false);
    feat1 = encode(autoEnc1, imgs);
    
    %% Compute second hidden layer
    hiddenSize2 = 50;
    autoEnc2 = trainAutoencoder(feat1,hiddenSize2, 'MaxEpochs',100, ...
                                'L2WeightRegularization',0.002, ...
                                'SparsityRegularization',4, ...
                                'SparsityProportion',0.1, ...
                                'ScaleData', false);
    feat2 = encode(autoEnc2, feat1);
    
    %% Construct the combined neural network
    softnet = trainSoftmaxLayer(feat2, bin_lbls, 'MaxEpochs', 400); 
    deepnet = stack(autoEnc1, autoEnc2, softnet);
    
    %% Convert the training images from matrices to vectors
    % Get the number of pixels in each image
    imageWidth = 50;
    imageHeight = 50;
    inputSize = imageWidth * imageHeight;
    
    % Turn the training images into vectors and put them in a matrix
    xTrain = zeros(inputSize, length(imgs));
    for i = 1 : numel(imgs)
        xTrain(:,i) = imgs{i}(:);
    end
    
    %% Run backpropogation on the total network
    model = train(deepnet, xTrain, bin_lbls);
    
end