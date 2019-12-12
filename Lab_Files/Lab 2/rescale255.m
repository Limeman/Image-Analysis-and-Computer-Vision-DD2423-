function img = rescale255(img)
    Max = max(img(:));
    Min = min(img(:));

    img = img ./ (Max - Min);

    img = floor(img .* 255);
end

