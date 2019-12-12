function grad_mag = gradient_magnitude(img)
    delta_x = [1 0 -1; 2 0 -2; 1 0 -1];
    delta_y = delta_x';
    
    dxtools = conv2(img, delta_x, 'valid');
    dytools = conv2(img, delta_y, 'valid');

    grad_mag = sqrt(dxtools .^2 + dytools .^2);
end

