function accuracy = calAccuracy(predictedResults, expectedResults)
    % calAccuracy Calculate accuracy of predicted results given expected
    % Inputs:
    %   predictedResults Cell array of predicted label of CAPTCHA
    %   expectedResults Cell array of expected label of CAPTCHA
    % Outputs:
    %   accuracy Percent of predicted labels that are correct
    
    num_correct = 0;
    
    for i = 1 : length(predictedResults)
        if strcmp(predictedResults{i}, expectedResults{i})
            num_correct = num_correct + 1;
        end
    end
    
    accuracy = (num_correct / length(predictedResults)) * 100;
end