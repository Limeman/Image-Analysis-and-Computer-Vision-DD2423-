function pixels = Lvvtilde(L, shape)
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
    
    % First order deritaves
    L_x = conv2(L, dxmask, shape);
    L_y = conv2(L, dymask, shape);
    
    % Second order deritaves
    L_xx = conv2(L, dxxmask, shape);
    L_yy = conv2(L, dyymask, shape);
    L_xy = conv2(L, dxymask, shape);
    
    pixels = (L_x .^2) .* L_xx + 2 .* L_x .* L_y .* L_xy ...
        + (L_y .^2) .* L_yy;
end

