function [characterImages, characterLabels] = splitCharacters(image, label)
    % splitCharacters Split given image and label into separate characters
    % Inputs:
    %   image CAPTCHA image
    %   label Ground truth label of the CAPTCHA
    % Outputs:
    %   characterImages Cell arrays of the different characters
    %   characterLabels Cell arrays of the ground truth character
    
    characterImages = extractCharacters(image);
    characterLabels = cellstr(label');
    
    if isempty(characterImages)
        characterImages = {};
        characterLabels = {};
    end
end