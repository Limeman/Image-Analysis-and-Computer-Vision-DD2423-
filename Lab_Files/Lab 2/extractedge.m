function edgecurves = extractedge(inpic, scale, threshold, shape)
    if nargin < 4
        shape = 'same';
    end
    blur = discgaussfft(inpic, scale);
    
    L_v = Lv(blur, shape);
    Lvv = Lvvtilde(blur, shape);
    Lvvv = Lvvvtilde(blur, shape);
    
    L_vvv_mask = zeros(size(Lvvv));
    Lvvvsignage = Lvvv < 0;
    L_vvv_mask(~Lvvvsignage) = -1;
    L_vvv_mask(Lvvvsignage) = 1;
    
    L_v_thresh = L_v - threshold > 0;
    L_v_mask = zeros(size(L_v));
    L_v_mask(~L_v_thresh) = -1;
    L_v_mask(L_v_thresh) = 1;
    
    edgecurves = zerocrosscurves(Lvv, L_vvv_mask);
    edgecurves = thresholdcurves(edgecurves, L_v_mask);
end
