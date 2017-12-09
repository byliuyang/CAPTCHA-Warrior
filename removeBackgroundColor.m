function newImage = removeBackgroundColor(image)
    % Remove the background color of the captch
    gray_image = rgb2gray(image);
    newImage = imbinarize(gray_image);
end