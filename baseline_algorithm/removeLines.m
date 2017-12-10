function newImage = removeLines(image)
    % Remove the lines in the image
    SE = strel('arbitrary', [1 0 1; 0 1 0; 1 0 1]);
    newImage = imerode(image, SE);
end