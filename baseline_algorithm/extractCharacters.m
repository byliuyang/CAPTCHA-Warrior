function characterImages = extractCharacters(captchaImage)
    % Extract character images from the captcha image
    
    %% Parameter configuration
    DEBUG = 0;
    MIN_AREA = 20;
    CHAR_IMG_SIZE = 50;
    characterImages = cell(4, 1);
    
    %% Show original
    if DEBUG
        subplot(2, 4, 1);
        imshow(captchaImage);
    end
    
    %% Remove the noises from the image
    
    %% Remove the background of the image
    captchaImage = removeBackgroundColor(captchaImage);
    if DEBUG
        subplot(2, 4, 2);
        imshow(captchaImage);
    end
    
    %% Remove the random lines from the image
    captchaImage = removeLines(captchaImage);
    if DEBUG
        subplot(2, 4, 3);
        imshow(captchaImage);
    end
    
    %% Find connected components
    I2 = bwdist(captchaImage) < 2.5;
    blobs = labelmatrix(bwconncomp(I2));
    blobs(~captchaImage) = 0;
    if DEBUG
        subplot(2, 4, 4);
        imshow(label2rgb(blobs, 'jet', [0,0,0], 'shuffle'));
    end
    
    %% Separate the components
    char_img_pad = CHAR_IMG_SIZE / 2;
    blob_measurements = regionprops(blobs, I2, 'all');
    blob_num = 1;
    plot_num = 5;
    for i = 1 : size(blob_measurements, 1)
        if blob_measurements(i).Area < MIN_AREA
            continue
        end
        blob_im = blob_measurements(i).Image;
        pad_width = max(char_img_pad - floor(size(blob_im, 1) / 2), 0);
        pad_height = max(char_img_pad - floor(size(blob_im, 2) / 2), 0);
        blob_im = padarray(blob_im, [pad_width pad_height], 0, 'both');
        if size(blob_im, 1) > 50
            blob_im = blob_im(1:50, :); 
        end
        if size(blob_im, 2) > 50
            blob_im = blob_im(:, 1:50);
        end
        characterImages{blob_num} = blob_im;
        if DEBUG
            subplot(2, 4, plot_num);
            imshow(blob_im);
        end
        blob_num = blob_num + 1;
        plot_num = plot_num + 1;
    end
    
    if blob_num <= 4
        characterImages = {};
        return;
    end
    
    %% 4. Check whether the image has enough characters
    %       if no, return None
    % 5. Check whether the characters are center in the image
    %       if no, return None
    % 6. Split and return the CAPTCHA image into character images based on the result of BLOB detection
end