format long
%% Question 1

vals = [[5 9], [9 5], [17 9], [17 121], [5 1], [125, 1]];
    
fftwave(vals(1), 128);

%% Question 2
Fhat = zeros(128);
Fhat(1, 2) = 1;

subplot(2, 3, 1)
F = ifft2(Fhat);
showgrey(real(F));
title('Real(F) with (p, q) = (1, 2)')

subplot(2, 3, 4)
F = ifft2(Fhat);
showgrey(imag(F));
title('Imag(F) with (p, q) = (1, 2)')
Fhat(1, 2) = 0;

Fhat(2, 1) = 1;
subplot(2, 3, 2)
F = ifft2(Fhat);
showgrey(real(F));
title('Real(F) with (p, q) = (2, 1)')

subplot(2, 3, 5);
showgrey(imag(F));
title('Imag(F) with (p, q) = (2, 1)')
Fhat(2, 1) = 0;

Fhat(2, 2) = 1;
subplot(2, 3, 3)
F = ifft2(Fhat);
showgrey(real(F));
title('Real(F) with (p, q) = (2, 2)')

subplot(2, 3, 6)
showgrey(imag(F))
title('Imag(F) with (p, q) = (2, 2)')

%% Questions 7-9
F = [ zeros(56, 128); ones(16, 128); zeros(56, 128)];
G = F';
H = F + 2 * G;

Fhat = fft2(F);
Ghat = fft2(G);
Hhat = fft2(H);



subplot(2, 2, 1);
showgrey(log(1 + abs(Fhat)));
title('Fhat');
subplot(2, 2, 2);
showgrey(log(1 + abs(Ghat)));
title('Ghat');
subplot(2, 2, 3);
showgrey(log(1 + abs(Hhat)));
title('Hhat');
subplot(2, 2, 4);
showgrey(log(1 + abs(fftshift(Hhat))));
title('Shifted Hhat');
%% Question 10

F = [ zeros(56, 128); ones(16, 128); zeros(56, 128)];
G = F';

figure;
subplot(1, 2, 1);
showgrey(F);
title('F');
subplot(1, 2, 2);
showgrey(G);
title('G');

figure;
subplot(1, 3, 1);
showgrey(F .* G);
title('Element wise spatial domain')
subplot(1, 3, 2);
showfs(fft2(F .* G));
title('Element wise -> Fourier domain')

Fhat = fft2(F);
Ghat = fft2(G);

Fhat = fftshift(Fhat);
Ghat = fftshift(Ghat);

Fhat = Fhat * (1 / 128);
Ghat = Ghat * (1 / 128);

Hhat = (conv2(Fhat, Ghat, 'same'));
subplot(1, 3, 3);
showgrey(log(1 + abs(Hhat)));
title('Fourier domain + convolution');

%% Question 11
F = [zeros(60, 128); ones(8, 128); zeros(60, 128)] .* ...
    [zeros(128, 48) ones(128, 32) zeros(128, 48)];

Fhat = fft2(F);

figure;
subplot(1, 2, 1);
showgrey(F);
subplot(1, 2, 2);
showfs(Fhat);

%% Question 12

F = [zeros(60, 128); ones(8, 128); zeros(60, 128)] .* ...
    [zeros(128, 48) ones(128, 32) zeros(128, 48)];

Fhat = fft2(F);

alpha= 30;

G = rot(F, alpha);
axis on

Ghat = fft2(G);

Hhat = rot(fftshift(Ghat), -alpha);


subplot(1, 3, 1);
showgrey(G);
title('Original image')

subplot(1, 3, 2);
showfs(Ghat);
title('Rotated image in Fouier domain')

subplot(1, 3, 3);
showfs(fftshift(Hhat));
title('Rerotated image in Fourier domain')


%% Question 13

img = phonecalc128;

imgpow = pow2image(img, 1e-10);

imgphase = randphaseimage(img);


subplot(1, 3, 1);
showgrey(img);
title('Original image')
subplot(1, 3, 2);
showgrey(imgpow);
title('Magnitude of image distorted')
subplot(1, 3, 3);
showgrey(imgphase);
title('Phase of image distorted')


%% Question 14 and 15

%{ 
Tester
  img = phonecalc128;

t = 2;

showgrey(gaussfft(img, t));  
%}

psf = deltafcn(128, 128);
t = 0.1;

psf_0_1 = gaussfft(psf, t);

var_0_1 = variance(psf_0_1);

t = 0.3;

psf_0_3 = gaussfft(psf, t);

var_0_3 = variance(psf_0_3);

t = 1;

psf_1 = gaussfft(psf, t);

var_1 = variance(psf_1);

t = 10;

psf_10 = gaussfft(psf, t);

var_10 = variance(psf_10);

t = 100;

psf_100 = gaussfft(psf, t);

var_100 = variance(psf_100);

subplot(2, 3, 1)
showgrey(psf_0_1)
title('t = 0.1')

subplot(2, 3, 3)
showgrey(psf_0_3)
title('t = 0.3')

subplot(2, 3, 4)
showgrey(psf_1)
title('t = 1')

subplot(2, 3, 5)
showgrey(psf_10)
title('t = 10')

subplot(2, 3, 6)
showgrey(psf_100)
title('t = 100')

sgtitle('Impulse response for different values of t')

%% Question 16

img = phonecalc128;

T = [1, 4, 16, 64, 256];

subplot(2, 3, 1);
showgrey(img);
title('Original image')

for t=1:size(T, 2)
    tmp_img = gaussfft(img, T(t));
    subplot(2, 3, t + 1);
    showgrey(tmp_img);
    title(sprintf('t = %d', T(t)));
end

%% Question 17 and 18

office = office256;

add = gaussnoise(office, 16);
sap = sapnoise(office, 0.1, 255);

subplot(4, 2, 1);
showgrey(add);
title('Gaussian noise')

subplot(4, 2, 2)
showgrey(sap)
title('Salt and pepper')

subplot(4, 2, 3)
showgrey(gaussfft(add, 4))
title('Gaussian smoothing')

subplot(4, 2, 4)
showgrey(gaussfft(sap, 4))
title('Gaussian smoothing')

subplot(4, 2, 5)
showgrey(medfilt(add, 3))
title('Median filtering')

subplot(4, 2, 6)
showgrey(medfilt(sap, 3))
title('Median filtering')

subplot(4, 2, 7)
showgrey(ideal(add, 0.2))
title('Ideal low-pass filtering')

subplot(4, 2, 8)
showgrey(ideal(sap, 0.2))
title('Ideal low-pass filtering')

%% Question 19 and 20

img = phonecalc256;
smoothimg = img;
N=5;
for i=1:N
    if i>1
        smoothimg = gaussfft(img, 2);% <call_your_filter_here>(smoothimg, <params>);
        smoothimg = rawsubsample(smoothimg);
        % generate subsampled versions
        img = rawsubsample(img);
    end
    subplot(2, N, i)
    showgrey(img)
    subplot(2, N, i+N)
    showgrey(smoothimg)
end