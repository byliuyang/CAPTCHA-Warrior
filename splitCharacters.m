function [characterImages, characterLabels] = splitCharacters(image, label)
    % Split characters into their own images with new labels
    
    characterImages = extractCharacters(image);
    characterLabels = cellstr(label');
    
    if isempty(characterImages)
        characterImages = {};
        characterLabels = {};
    end
end