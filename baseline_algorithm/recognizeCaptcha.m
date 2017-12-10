function captchaText = recognizeCaptcha(model, captchaImage)
    % recognizeCaptcha Use the given model to predict label of CAPTCHA
    % Inputs:
    %   model Trained CNN used to predict labels
    %   captchaImage CAPTCHA image to predict label
    % Outputs:
    %   captchaText Predicted label of the given CAPTCHA
    
    %% Extract characters
    imgs = extractCharacters(captchaImage);
    if isempty(imgs)
        captchaText = '';
        return;
    end
    
    %% Convert character matrices into vectors
    imageWidth = 50;
    imageHeight = 50;
    inputSize = imageWidth * imageHeight;
    
    % Turn the training images into vectors and put them in a matrix
    x_test = zeros(inputSize, length(imgs));
    for i = 1 : numel(imgs)
        x_test(:,i) = imgs{i}(:);
    end
    
    %% Predict the characters
    y = model(x_test);
    
    classes = {'0','1','2','3','4','5','6','7','8','9','a','b','c','d',...
               'e','f','g','h','i','j','k','l','m','n','o','p','q','r',...
               's','t','u','v','w','x','y','z'};
    
    predicted_chars = cell(1, size(y, 2));
    for i = 1 : size(y, 2)
        [~, idx] = max(y(:,i));
        predicted_chars{i} = classes{idx};
    end
    
    %% Construct CAPTCHA
    captchaText = strcat(predicted_chars{:});
    
end