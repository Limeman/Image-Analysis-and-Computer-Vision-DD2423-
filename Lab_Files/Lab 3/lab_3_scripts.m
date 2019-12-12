format long
%% Question 1
K = 8;               % number of clusters used
L = 10;              % number of iterations
seed = 14;           % seed used for random initialization
scale_factor = 1.0;  % image downscale factor
image_sigma = 1.0;   % image preblurring scale

I = imread('orange.jpg');
I = imresize(I, scale_factor);
Iback = I;
d = 2*ceil(image_sigma*2) + 1;
h = fspecial('gaussian', [d d], image_sigma);
I = imfilter(I, h);

tic
[ segm, centers ] = kmeans_segm(I, K, L, seed);
toc
Inew = mean_segments(Iback, segm);
I = overlay_bounds(Iback, segm);

subplot(1, 2, 1)
imshow(Inew)
title(sprintf('Clustered image with K = %d', K))

subplot(1, 2, 2)
imshow(I)
title('Original image with cluster broders drawn')

%% Question 2
K = [2, 4, 6, 8, 10];               % number of clusters used
L = 500;              % number of iterations
seed = 24;           % seed used for random initialization
scale_factor = 1.0;  % image downscale factor
image_sigma = 1.0;   % image preblurring scale
threshold = 0.1;

Images = {'orange.jpg', 'tiger1.jpg', 'tiger2.jpg', 'tiger3.jpg'};


iterations = zeros(4, size(K, 2));

for i=1:4
    I = imread(Images{i});
    I = imresize(I, scale_factor);
    Iback = I;
    d = 2*ceil(image_sigma*2) + 1;
    h = fspecial('gaussian', [d d], image_sigma);
    I = imfilter(I, h);
    counter = 1;
    fprintf(['\nImage:\t' Images{i} '\n'])
    for k=K
        [ ~, ~, iterations(i, counter)] = kmeans_segm_convergence(I, k, L, seed, threshold);
        counter = counter + 1;
    end
end

hold on
for i=1:4
    plot(K, iterations(i, :))
end
hold off
title(sprintf('Number of iterations required for convergence with threshold = %d', threshold))
xlabel('Number of clusters')
ylabel('iterations')
legend(Images{1}, Images{2}, Images{3}, Images{4})

%% Question 3
K = [5 6] + 2;               % number of clusters used
L = 10;              % number of iterations
seed = 14;           % seed used for random initialization
scale_factor = 1.0;  % image downscale factor
image_sigma = 1.0;   % image preblurring scale

I = imread('orange.jpg');
I = imresize(I, scale_factor);
Iback = I;
d = 2*ceil(image_sigma*2) + 1;
h = fspecial('gaussian', [d d], image_sigma);
I = imfilter(I, h);

[segm, ~] = kmeans_segm(I, K(1), L, seed);
Inewfirst = mean_segments(Iback, segm);
Inewfirst = overlay_bounds(Inewfirst, segm);

[segm, ~] = kmeans_segm(I, K(2), L, seed);
Inewsecond = mean_segments(Iback, segm);
Inewsecond = overlay_bounds(Inewsecond, segm);

subplot(1, 2, 1)
imshow(Inewfirst)
title(sprintf('Clustered image with K = %d', K(1)))

subplot(1, 2, 2)
imshow(Inewsecond)
title(sprintf('Clustered image with K = %d', K(2)))

%% Question 4
K = [9, 9, 10];               % number of clusters used
L = [50, 80, 110];              % number of iterations
seed = 14;           % seed used for random initialization
scale_factor = [1.0, 1.0, 1.0];  % image downscale factor
image_sigma = [1.0, 1.0, 1.0];   % image preblurring scale

Images = {'tiger1.jpg', 'tiger2.jpg', 'tiger3.jpg'};

for i=1:3
    I = imread(Images{i});
    I = imresize(I, scale_factor(i));
    Iback = I;
    d = 2*ceil(image_sigma(i)*2) + 1;
    h = fspecial('gaussian', [d d], image_sigma(i));
    I = imfilter(I, h);

    [ segm, centers ] = kmeans_segm(I, K(i), L(i), seed);
    Inew = mean_segments(Iback, segm);
    
%     if i == 3
%         subplot(2, 2, [i, i + 1])
%     else
%         subplot(2, 2, i)
%     end
    subplot(3, 1, i)
    imshow(Inew)
    title([Images{i}])
end

%% Question 5 and 6
scale_factor = 0.5;       % image downscale factor
spatial_bandwidths = [4.0, 8.0, 16.0, 32.0];  % spatial bandwidth
colour_bandwidths = [4.0, 8.0, 16.0, 32.0];   % colour bandwidth
num_iterations = 40;      % number of mean-shift iterations
image_sigma = 1.0;        % image preblurring scale

I = imread('tiger1.jpg');
I = imresize(I, scale_factor);
Iback = I;
d = 2*ceil(image_sigma*2) + 1;
h = fspecial('gaussian', [d d], image_sigma);
I = imfilter(I, h);

counter = 1;
for i=spatial_bandwidths
    segm = mean_shift_segm(I, i, colour_bandwidths(2), num_iterations);
    Inew = mean_segments(Iback, segm);
    subplot(2, 2, counter)
    imshow(Inew)
    title(sprintf('Spatial bandwidth = %d, Color bandwidth = %d', i, colour_bandwidths(2)))
    
    counter = counter + 1;
end

figure;
counter = 1;
for i=colour_bandwidths
    segm = mean_shift_segm(I, spatial_bandwidths(2), i, num_iterations);
    Inew = mean_segments(Iback, segm);
    subplot(2, 2, counter)
    imshow(Inew)
    title(sprintf('Spatial bandwidth = %d, Color bandwidth = %d', spatial_bandwidths(2), i))
    
    counter = counter + 1;
end

figure;
spatial_bandwidth = 8;
colour_bandwidth = 32;
segm = mean_shift_segm(I, spatial_bandwidth, colour_bandwidth, num_iterations);
Inew = mean_segments(Iback, segm);
imshow(Inew)
title(sprintf('Spatial bandwidth = %d, Color bandwidth = %d', 8, 32))

%% Question 7
colour_bandwidth = 20.0; % color bandwidth
radius = 3;              % maximum neighbourhood distance
ncuts_thresh = [0.2, 0.4, 0.8, 1.0];      % cutting threshold
min_area = [20, 50, 100, 200];          % minimum area of segment
max_depth = [6, 8, 10, 20];           % maximum splitting depth
scale_factor = 0.4;      % image downscale factor
image_sigma = 2.0;       % image preblurring scale
%{
I = imread('tiger3.jpg');
I = imresize(I, scale_factor);
Iback = I;
d = 2*ceil(image_sigma*2) + 1;
h = fspecial('gaussian', [d d], image_sigma);
I = imfilter(I, h);

counter = 1;
for n=ncuts_thresh
    segm = norm_cuts_segm(I, colour_bandwidth, radius, n, min_area(1), max_depth(2));
    Inew = mean_segments(Iback, segm);
    
    subplot(2, 2, counter)
    imshow(Inew)
    title(sprintf('Normalized cuts with ncuts thresh = %f', n))
    counter = counter + 1;
end

figure;
counter = 1;
for m=min_area
    segm = norm_cuts_segm(I, colour_bandwidth, radius, ncuts_thresh(2), m, max_depth(2));
    Inew = mean_segments(Iback, segm);
    
    subplot(2, 2, counter)
    imshow(Inew)
    title(sprintf('Normalized cuts with min area = %f', m))
    counter = counter + 1;
end


figure;
counter = 1;
for m=max_depth
    segm = norm_cuts_segm(I, colour_bandwidth, radius, ncuts_thresh(1), min_area(3), m);
    Inew = mean_segments(Iback, segm);
    
    subplot(2, 2, counter)
    imshow(Inew)
    title(sprintf('Normalized cuts with max depth = %f', m))
    counter = counter + 1;
end
%}

% Optimal
figure;
% Orange settings
I = imread('orange.jpg');
I = imresize(I, scale_factor);
Iback = I;
d = 2*ceil(image_sigma*2) + 1;
h = fspecial('gaussian', [d d], image_sigma);
I = imfilter(I, h);

ncuts_thresh = 0.6;
min_area = 40;
max_depth = 8;
segm = norm_cuts_segm(I, colour_bandwidth, radius, ncuts_thresh, min_area, max_depth);
Inew = mean_segments(Iback, segm);
subplot(1, 2, 1)
imshow(imread('orange.jpg'))
title('orange.jpg')
subplot(1, 2, 2)
imshow(Inew)
title(sprintf('ncuts thresh = %d, min area = %d, max depth = %d', ncuts_thresh, min_area, max_depth))

% Tiger1 settings
figure;
I = imread('tiger1.jpg');
I = imresize(I, scale_factor);
Iback = I;
d = 2*ceil(image_sigma*2) + 1;
h = fspecial('gaussian', [d d], image_sigma);
I = imfilter(I, h);

ncuts_thresh = 0.2;
min_area = 20;
max_depth = 8;
segm = norm_cuts_segm(I, colour_bandwidth, radius, ncuts_thresh, min_area, max_depth);
Inew = mean_segments(Iback, segm);
subplot(1, 2, 1)
imshow(imread('tiger1.jpg'))
title('tiger1.jpg')
subplot(1, 2, 2)
imshow(Inew)
title(sprintf('ncuts thresh = %d, min area = %d, max depth = %d', ncuts_thresh, min_area, max_depth))
% Tiger2 settings
figure;
I = imread('tiger2.jpg');
I = imresize(I, scale_factor);
Iback = I;
d = 2*ceil(image_sigma*2) + 1;
h = fspecial('gaussian', [d d], image_sigma);
I = imfilter(I, h);

ncuts_tresh = 0.4;
min_area = 20;
max_depth = 8;
segm = norm_cuts_segm(I, colour_bandwidth, radius, ncuts_thresh, min_area, max_depth);
Inew = mean_segments(Iback, segm);
subplot(1, 2, 1)
imshow(imread('tiger2.jpg'))
title('tiger2.jpg')
subplot(1, 2, 2)
imshow(Inew)
title(sprintf('ncuts thresh = %d, min area = %d, max depth = %d', ncuts_thresh, min_area, max_depth))
% Tiger3 settings
figure;
I = imread('tiger3.jpg');
I = imresize(I, scale_factor);
Iback = I;
d = 2*ceil(image_sigma*2) + 1;
h = fspecial('gaussian', [d d], image_sigma);
I = imfilter(I, h);

ncuts_thresh = 0.4;
min_area = 20;
max_depth = 8;
segm = norm_cuts_segm(I, colour_bandwidth, radius, ncuts_thresh, min_area, max_depth);
Inew = mean_segments(Iback, segm);
subplot(1, 2, 1)
imshow(imread('tiger3.jpg'))
title('tiger3.jpg')
subplot(1, 2, 2)
imshow(Inew)
title(sprintf('ncuts thresh = %d, min area = %d, max depth = %d', ncuts_thresh, min_area, max_depth))

%% Question 8
scale_factor = 0.4;
image_sigma = 2.0;
colour_bandwidth = 20.0;
radius = 3;
I = imread('orange.jpg');
I = imresize(I, scale_factor);
Iback = I;
d = 2*ceil(image_sigma*2) + 1;
h = fspecial('gaussian', [d d], image_sigma);
I = imfilter(I, h);

ncuts_thresh = 0.6;
min_area = 40;
max_depth = [6, 8, 12];

for i=1:3
    subplot(1, 3, i)
    segm = norm_cuts_segm(I, colour_bandwidth, radius, ncuts_thresh, min_area, max_depth(i));
    Inew = mean_segments(Iback, segm);
    imshow(Inew)
    title(sprintf('Recursion depth = %d', max_depth(i)))
end

%% Question 10
scale_factor = 0.4;
image_sigma = 2.0;
colour_bandwidth = 20.0;
ncuts_thresh = 0.6;
min_area = 40;
max_depth = 8;

radius = [3, 6, 12];

I = imread('orange.jpg');
I = imresize(I, scale_factor);
Iback = I;
d = 2*ceil(image_sigma*2) + 1;
h = fspecial('gaussian', [d d], image_sigma);
I = imfilter(I, h);

for i=1:3
    subplot(1, 3, i)
    segm = norm_cuts_segm(I, colour_bandwidth, radius(i), ncuts_thresh, min_area, max_depth);
    Inew = mean_segments(Iback, segm);
    imshow(Inew)
    title(sprintf('Radius = %u', radius(i)))
end

%% Question 11
scale_factor = 0.5;          % image downscale factor
%area = [ 80, 110, 570, 300 ]; % image region to train foreground with
area = [76, 58, 442, 382];
K = 16;                      % number of mixture components
alpha = [4.0, 8.0, 12.0, 16.0];                 % maximum edge cost
sigma = 10.0;                % edge cost decay factor

I = imread('orange.jpg');
I = imresize(I, scale_factor);
Iback = I;
area = int16(area*scale_factor);
for i=1:4
    [ segm, ~] = graphcut_segm(Iback, area, K, alpha(i), sigma);
    
    I = overlay_bounds(Iback, segm);
    
    subplot(2, 2, i)
    imshow(I)
    title(sprintf('alpha = %u', alpha(i)))
end

%% Question 12
scale_factor = 0.5;          % image downscale factor
area = [ 80, 110, 570, 300 ]; % image region to train foreground with
K = [12, 8, 6, 5, 4, 3];                      % number of mixture components
alpha = 16.0;                 % maximum edge cost
sigma = 10.0;                % edge cost decay factor

I = imread('tiger1.jpg');
I = imresize(I, scale_factor);
Iback = I;
area = int16(area*scale_factor);

for i=1:numel(K)
    [ segm, ~] = graphcut_segm(Iback, area, K(i), alpha, sigma);
    
    I = overlay_bounds(Iback, segm);
    
    subplot(2, 3, i)
    imshow(I)
    title(sprintf('K = %u', K(i)))
end