clear;
clc;
close all;

num_it = [1, 2, 4, 6, 8, 10];
r = 3;
c = 2;

I = imread('Image_1 copy.bmp');
I = rgb2gray(I);

%% Nonlinear Despeckle Filtering : Homomorphic Filtering

% C.P. Loizou, et al.,"Speckle reduction in ultrasound images of atherosclerotic carotid plaque",
% DSP 2002, Proc. IEEE 14 thInt. Conf. Digital Signal Proces., Santorini-Greece, 
% pp. 525–528, July 1–3, 2002. DOI: 10.1109/ICDSP.2002.1028143.

for i = 1:6
    I_new = homlog(I, num_it(i));
    
    subplot(3, 2, i)
    imshow(I_new);
    str = sprintf('Number of iteration : %d', num_it(i));
    title( str );
end

%% Optimized-Bayesian-Nonlocal-means-with-block(OBNLM)

% Coupé, Pierrick, et al. "Nonlocal means-based speckle filtering for ultrasound images." 
% IEEE transactions on image processing 18.10 (2009): 2221-2229.

[m, n, z] = size(I);
I = imresize(I, [512 512]);

blockSize = 5; % size of the block
windowSize = [5, 10, 15, 20, 25, 30]; % size of the search window
gapBwnBlock = [1, 2]; % gap between the search block (in order to solve computational burden)
h = 8; % filtering parameter controlling the decay of the exponential function

for j = 1: 2
    figure
    for k = 1:6
        I = ImgNormalize(I);
        processedImg = BayesianNLM(I, blockSize, windowSize(k), gapBwnBlock(j), h);

        subplot(3, 2, k)
        imshow(processedImg)
    end
end
%% Anisotropic diffusion

% Reference: P. Perona and J. Malik. 
% Scale-space and edge detection using ansotropic diffusion.
% IEEE Transactions on Pattern Analysis and Machine Intelligence, 
% 12(7):629-639, July 1990.

num_it = [10, 20 ,30, 40, 50, 60];
lambda = linspace(0.00001, 0.25, 6);
kappa = linspace(20,100, 6);

figure
for t = 1:6
    subplot(3, 2, t)
    imshow(anisodiff(I, num_it(t), 30, 0.2, 2));
    str = sprintf('Number of iteration: %d', num_it(t));
    title(str)
end

% figure
% for t = 1:6
%     subplot(3, 2, t)
%     imshow(anisodiff(I, 10, kappa(t), 0.2, 2));
%     str = sprintf('Kappa: %d', kappa(t));
%     title(str)
% end
% 
% figure
% for t = 1:6
%     subplot(3, 2, t)
%     imshow(anisodiff(I, 10, 30, lambda(t), 2));
%     str = sprintf('Lambda: %d', lambda(t));
%     title(str)
% end

%% TVDENOISE  (Total Variation Image Denoising)

num_it = [10, 20 ,30, 40, 50, 60];
lambda = linspace(100, 600, 6);

figure
for t = 1:6
    subplot(3, 2, t)
    imshow(tvdenoise(im2double(I),lambda(t),20));
    str = sprintf('Lambda: %d , Iteration %d', lambda(t), 20);
    title(str)
end

figure
for t = 1:6
    subplot(3, 2, t)
    imshow(tvdenoise(im2double(I),400,num_it(t)));
    str = sprintf('Lambda: %d , Iteration %d', 400, num_it(t));
    title(str)
end








