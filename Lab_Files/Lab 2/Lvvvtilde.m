function pixels = Lvvvtilde(L, shape)
    if nargin < 2
        shape = 'same';
    end
    
    delta_x = [-1/2 0 1/2];
    delta_xx = [1 -2 1];
    
    dxmask = [0 0 0 0 0; 0 0 0 0 0; 0 delta_x 0; 0 0 0 0 0; 0 0 0 0 0];
    dymask = dxmask';
    dxxmask = [0 0 0 0 0; 0 0 0 0 0; 0 delta_xx 0; 0 0 0 0 0; 0 0 0 0 0];
    dyymask = dxxmask';
    dxymask = conv2(dxmask, dymask, shape);
    dxxxmask = conv2(dxxmask, dxmask, shape);
    dxxymask = conv2(dxxmask, dymask, shape);
    dxyymask = conv2(dxymask, dymask, shape);
    dyyymask = conv2(dyymask, dymask, shape);
    
    % First order deritaves
    L_x = conv2(L, dxmask, shape);
    L_y = conv2(L, dymask, shape);
    
    % Third order deritaves
    L_xxx = conv2(L, dxxxmask, shape);
    L_yyy = conv2(L, dyyymask, shape);
    L_xxy = conv2(L, dxxymask, shape);
    L_xyy = conv2(L, dxyymask, shape);
    
    pixels = (L_x .^3) .* L_xxx + 3 .* (L_x .^2) .* L_y .* L_xxy + ...
        3 .* L_x .* (L_y .^2) .* L_xyy + (L_x .^3) .* L_yyy;
end

