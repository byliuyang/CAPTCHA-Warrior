function characterImages = extractCharacters(captchaImage)
    % Extract character images from the captcha image

    % 1. Remove the noises from the image
    % 2. Remove the background of the image
    removeBackgroundColor(captchaImage);
    % 3. Remove the random lines from the image
    % 4. Check whether the image has enough characters
    %       if no, return None
    % 5. Check whether the characters are center in the image
    %       if no, return None
    % 6. Split and return the CAPTCHA image into character images based on the result of BLOB detection
end