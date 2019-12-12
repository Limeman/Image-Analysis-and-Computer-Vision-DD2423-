function hist = histify(img)
    gradmax = max(img(:));
    gradmin = min(img(:));

    img = img ./ (gradmax - gradmin);

    img = floor(img .* 255);

    hist = zeros(1, 256);
    [m, n] = size(img);
    for i=1:256
        hist(i) = sum(img(:) == i - 1) / (m * n);
    end
end

