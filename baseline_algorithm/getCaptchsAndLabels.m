function [captchasImages, labels] = getCaptchsAndLabels()
    % getCaptchsAndLabels Read the CAPTCHA images and labels
    % Inputs:
    %   None
    % Outputs:
    %   captchasImages Cell array of the images, each cell contains a XxYx3
    %   labels Cell array of the ground truth label of corresponding image
    
    %% Path configuration
    IMAGE_DIR = '../captcha_generator/images/';
    LABEL_MAP = '../captcha_generator/hash_to_label.csv';
    
    %% Acquire paths and get label map
    image_paths = dir(strcat(IMAGE_DIR, '*.jpg'));
    hash_label_file = fopen(LABEL_MAP);
    hash_label_map = textscan(hash_label_file, '%q %q', 'Delimiter', ',');    
    fclose(hash_label_file);
    
    %% Output initialization
    captchasImages = cell(length(hash_label_map{1}), 1);
    labels = cell(length(hash_label_map{1}), 1);
    
    %% Read each image and get label and add to output cell arrays
    for i = 1 : length(image_paths)
       img_name = image_paths(i).name; 
       captchasImages{i} = imread(strcat(IMAGE_DIR,img_name));
       idx = strcmp(hash_label_map{1}, img_name);
       labels{i} = hash_label_map{2}{idx};
    end
end