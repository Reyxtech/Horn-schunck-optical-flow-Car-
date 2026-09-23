clc;
clear;
close all;

projectFolder = fileparts(mfilename('fullpath'));
resultsFolder = fullfile(projectFolder, 'results');

if ~exist(resultsFolder, 'dir')
    mkdir(resultsFolder);
end

tic

%% Read the two consecutive frames

a1 = imread('car_frame1.png');
a2 = imread('car_frame2.png');


%% Convert images to grayscale

if size(a1,3) == 3
    a1 = rgb2gray(a1);
end

if size(a2,3) == 3
    a2 = rgb2gray(a2);
end


%% Convert images to double

a1 = double(a1);
a2 = double(a2);

%% Calculate image derivatives

% Kernels used for Horn-Schunck derivatives

kernelX = 0.25 * [-1 1;
                  -1 1];

kernelY = 0.25 * [-1 -1;
                   1  1];

kernelT = 0.25 * [1 1;
                   1 1];


% Spatial derivative in x direction
Ix = conv2(a1, kernelX, 'valid') + ...
     conv2(a2, kernelX, 'valid');


% Spatial derivative in y direction
Iy = conv2(a1, kernelY, 'valid') + ...
     conv2(a2, kernelY, 'valid');


% Temporal derivative
It = conv2(a2, kernelT, 'valid') - ...
     conv2(a1, kernelT, 'valid');


%% Initialize optical flow

[m,n] = size(Ix);

u = zeros(m,n);
v = zeros(m,n);


%% Horn-Schunck parameters

alpha = 4;       % Smoothness parameter
iterations = 100; % Number of iterations


%% Neighborhood averaging kernel

% This is the standard Horn-Schunck averaging kernel

avgKernel = [1/12 1/6 1/12;
             1/6  0   1/6;
             1/12 1/6 1/12];


%% Horn-Schunck iterative calculation

for k = 1:iterations

    % Calculate local average of horizontal flow
    uAvg = imfilter(u, avgKernel, 'replicate');

    % Calculate local average of vertical flow
    vAvg = imfilter(v, avgKernel, 'replicate');


    % Optical flow constraint equation
    P = Ix .* uAvg + Iy .* vAvg + It;


    % Denominator
    D = alpha^2 + Ix.^2 + Iy.^2;


    % Update horizontal and vertical flow
    uNew = uAvg - (Ix .* P) ./ D;
    vNew = vAvg - (Iy .* P) ./ D;


    % Update flow
    u = uNew;
    v = vNew;

end


%% Display maximum flow values

disp(['Maximum horizontal flow (u): ', num2str(max(abs(u(:))))]);
disp(['Maximum vertical flow (v): ', num2str(max(abs(v(:))))]);


%% Display the first image

figure;
imshow(a1, []);
title('First Frame');

saveas(gcf, fullfile(resultsFolder, 'first_frame.png'));

%% Display and save optical flow

figure;

step = 10;

[X,Y] = meshgrid(1:step:size(u,2), ...
                 1:step:size(u,1));

quiver(X, Y, ...
       u(1:step:end, 1:step:end), ...
       v(1:step:end, 1:step:end), ...
       2);

axis ij;
axis tight;

title('Horn-Schunck Optical Flow');
xlabel('X');
ylabel('Y');

saveas(gcf, fullfile(resultsFolder, 'optical_flow.png'));
%% Display and save optical flow on the image

figure;

imshow(a1, []);
hold on;

quiver(X, Y, ...
       u(1:step:end, 1:step:end), ...
       v(1:step:end, 1:step:end), ...
       2);

title('Horn-Schunck Optical Flow on Image');

hold off;

saveas(gcf, fullfile(resultsFolder, 'optical_flow_on_image.png'));

toc



