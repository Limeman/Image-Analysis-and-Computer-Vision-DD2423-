format long
%% Question 1
delta_x = [1 0 -1; 2 0 -2; 1 0 -1];
delta_y = delta_x';

tools = few256;

dxtools = conv2(tools, delta_x, 'valid');
dytools = conv2(tools, delta_y, 'valid');

subplot(1,2,1)
showgrey(dxtools)
title('X direction deritave')

subplot(1,2,2)
showgrey(dytools);
title('Y direction deritave')


fprintf(sprintf('size of tools: (n_y, n_x) = (%d, %d)\n', size(tools)))
fprintf(sprintf('size of dxtools: (n_y, n_x) = (%d, %d)\n', size(dxtools)))
fprintf(sprintf('size of dytools: (n_y, n_x) = (%d, %d)\n', size(dytools)))

%% Question 2
delta_x = [1 0 -1; 2 0 -2; 1 0 -1];
delta_y = delta_x';

%{
tools = few256;

dxtools = conv2(tools, delta_x, 'valid');
dytools = conv2(tools, delta_y, 'valid');

gradmagtools = sqrt(dxtools .^2 + dytools .^2);

%subplot(1, 2, 1)
%showgrey(gradmagtools)
%title('Non-thresholded gradient magnitude')

bins = histify(gradmagtools);

bar(bins);
title('Histogram of image')
xlabel('Magnitude (normalized to range 0-255)')
ylabel('Number of pixels')

threshold = [10 20 30 40 50 60];
figure;
for i=1:size(threshold, 2)
    subplot(2, 3, i)
    showgrey(gradmagtools - threshold(i) > 0)
    title(sprintf('Threshold = %d', threshold(i)))
end

figure;
threshold = [10 20 30 40 50 60] + 50;
figure;
for i=1:size(threshold, 2)
    subplot(2, 3, i)
    showgrey(gradmagtools - threshold(i) > 0)
    title(sprintf('Threshold = %d', threshold(i)))
end

figure;
showgrey(gradmagtools - 105 > 0)
title(sprintf('Threshold = %d', 105))

%}

img = godthem256;
grad_mag = gradient_magnitude(img);

bins = histify(grad_mag);

grad_mag = rescale255(grad_mag);

bar(bins)
title('Histogram of image')
xlabel('Magnitude (normalized to range 0-255)')
ylabel('Number of pixels')

threshold = [10 20 30 40 50 60];
figure;
for i=1:size(threshold, 2)
    subplot(2, 3, i)
    showgrey(grad_mag - threshold(i) > 0)
    title(sprintf('Threshold = %d', threshold(i)))
end

figure;
showgrey(grad_mag - 35 > 0)
title(sprintf('Threshold = %d', 35))
%% Question 3
%img = few256;
img = godthem256;
threshold = 35;

img_blur = gaussfft(img, 2);
grad_mag = gradient_magnitude(img);
grad_mag_blur = gradient_magnitude(img_blur);

grad_mag = rescale255(grad_mag);
grad_mag_blur = rescale255(grad_mag_blur);

subplot(1, 2, 1)
showgrey(grad_mag - threshold > 0)
title('Non-blured image')

subplot(1, 2, 2)
showgrey(grad_mag_blur - threshold > 0)
title('Blured image')

%% Question 4
house = godthem256;
scales = [0.0001 1.0 4.0 16.0 64.0];
vals = [1 3 5 7 9];

for i=1:size(scales, 2)
    subplot(2, 3, i)
    contour(Lvvtilde(discgaussfft(house, scales(i))), [0 0])
    title(sprintf('Scale = %d', scales(i)))
    axis('image')
    axis('ij')
end
suptitle('Zero crossings of Lvvtilde on a varying number of different scales')

%% Question 5
tools = few256;
scales = [0.0001 1.0 4.0 16.0 64.0];

for i=1:size(scales, 2)
    subplot(2, 3, i)
    showgrey(Lvvvtilde(discgaussfft(tools, scales(i))) < 0);
    title(sprintf('Scale = %d', scales(i)))
end
suptitle('Signage of third order deritave for varying variances in gaussian blur')

%% Question 6
house = godthem256;
scales = [0.0001 4.0 64.0];

threshold = 1;

counter = 1;
for i=1:3
    Lvv = Lvvtilde(discgaussfft(house, scales(counter)));
    Lvvv = Lvvvtilde(discgaussfft(house, scales(counter)));
    
    subplot(2, 3, i)
    contour(Lvv, [0 0]);
    title(sprintf('Contoured image with scale = %d', scales(counter)))
    axis('image')
    axis('ij')
    
    subplot(2, 3, i + 3)
    % As per the documentation https://se.mathworks.com/help/matlab/ref/contour.html
    % we can remove parts of the contour plot by assigning them the value
    % NaN
    Lvv(~(Lvvv < 0)) = NaN;
    contour(Lvv, [0 0])
    title(sprintf('Lvv and Lvvv combo with scale = %d', scales(counter)))
    axis('image')
    axis('ij')
    counter = counter + 1;
end

%% Question 7
%image = godthem256;
image = few256;
scales = [0.0001 1.0 4.0 16.0 64.0];
threshold = 35;

for i=1:size(scales, 2)
    curves = extractedge(image, scales(i), threshold, 'same');
    subplot(2, 3, i)
    overlaycurves(image, curves)
    title(sprintf('scale = %d', scales(i)))
end

thresholds = [10 20 30 40 50 60];
scale = 4;

figure;
for i=1:size(thresholds, 2)
    curves = extractedge(image, scale, thresholds(i), 'same');
    subplot(2, 3, i)
    overlaycurves(image, curves)
    title(sprintf('threshold = %d', thresholds(i)))
end

figure;
threshold = 40;
scale = 4;

curves = extractedge(image, scale, threshold, 'same');
overlaycurves(image, curves)

%% Question 8

nrho = 360;
ntheta = 360;
nlines = 3;
threshold = 40;
scale = 4;

testimage1 = triangle128;

testimage2 = houghtest256;

[linepar1, acc1] = houghedgeline(testimage1, scale, threshold, nrho, ntheta, nlines, 0);

nlines = 12;
[linepar2, acc2] = houghedgeline(testimage2, scale, threshold, nrho, ntheta, nlines, 0);


subplot(1, 2, 1)
overlaycurves(testimage1, linepar1)
title('triangle128')
axis([0, size(testimage1, 1), 0, size(testimage1, 2)])

subplot(1, 2, 2)
showgrey(acc1)
title('Houghspace of edges in triangle128')
xlabel('Theta')
ylabel('Rho')

figure;
subplot(1, 2, 1)
overlaycurves(testimage2, linepar2)
title('houghtest256')
axis([0, size(testimage2, 1), 0, size(testimage2, 2)])


subplot(1, 2, 2)
showgrey(acc2)
title('Houghspace of edges in houghtest256')
xlabel('Theta')
ylabel('Rho')

%% Question 9 and 10
nrhos = [45 90 180 360].*2;
nthetas = nrhos;
nlines = 15;
scale = 4;
threshold = 40;
image = few256;
%image = phonecalc256;
%image = godthem256;

for i=1:size(nrhos, 2)
    [lines, ~] = houghedgeline(image, scale, threshold, nrhos(i), nthetas(i), nlines, 0);
    subplot(2, 2, i)
    overlaycurves(image, lines)
    title(sprintf('nrho = %d    ntheta = %d', nrhos(i), nthetas(i)))
    axis([0, size(image, 1), 0, size(image, 2)])
end

