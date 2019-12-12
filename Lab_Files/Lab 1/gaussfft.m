function img = guassfft(img, t)
    if ndims(img) ~= 2
        error('Image must have 2 dimensions');
    end
    
    [n, m] = size(img);
    
    x1 = 1:m;
    x2 = 1:n;
    
    [X1, X2] = meshgrid(x1, x2);
    X = [X1(:) X2(:)];
    
    g = mvnpdf(X, [m / 2, n / 2], [t 0; 0 t]);
    g = reshape(g, m, n);
    
    ghat = fft2(g);
    Fhat = fft2(img);
    
    Hhat = ghat .* Fhat;
    
    img = abs(fftshift(ifft2(Hhat)));
    
end