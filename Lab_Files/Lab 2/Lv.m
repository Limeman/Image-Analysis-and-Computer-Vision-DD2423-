function pixels = Lv(inpic, shape)
    if (nargin < 2)
        shape = 'same';
    end
    delta_x = [-1/2 0 1/2];
    dxmask = [0 0 0 0 0; 0 delta_x 0; 0 0 0 0 0];
    dymask = dxmask';
    
    Lx = filter2(dxmask, inpic, shape);
    Ly = filter2(dymask, inpic, shape);
    pixels = Lx.^2 + Ly.^2;
end