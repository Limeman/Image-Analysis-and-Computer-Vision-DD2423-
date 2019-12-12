function outcurves = to_cartesian(linepar, rho_max)
    outcurves = zeros(2, size(linepar, 2) * 4);
    
    for idx=1:size(linepar, 2)
        rho = linepar(1, idx);
        theta = linepar(2, idx);
        
        x0 = 0;
        y0 = rho / (sin(theta) + 1e-10);
        dx = rho_max;
        dy = (rho - dx * cos(theta)) / (sin(theta) + 1e-10);
        
       % Compute a line for each one of the strongest responses in the accumulator
        outcurves(1,4*(idx-1) + 1) = 0; % not significant
        outcurves(2,4*(idx-1) + 1) = 3; 
        outcurves(2,4*(idx-1) + 2) = x0 - dx;
        outcurves(1,4*(idx-1) + 2) = y0 - dy;
        outcurves(2,4*(idx-1) + 3) = x0 ;
        outcurves(1,4*(idx-1) + 3) = y0 ;
        outcurves(2,4*(idx-1) + 4) = x0 + dx;
        outcurves(1,4*(idx-1) + 4) = y0 + dy;  
        
        %{
        outcurves(1, 3*(idx-1) + 1) = 0; % level, not significant
        outcurves(2, 3*(idx-1) + 1) = 2; % number of points in the curve
        
        if theta == 0
            outcurves(2, 3*(idx-1) + 2) = 1;
            outcurves(1, 3*(idx-1) + 2) = rho;
            outcurves(2, 3*(idx-1) + 3) = x_max;
            outcurves(1, 3*(idx-1) + 3) = rho;
        else
            outcurves(2, 3*(idx-1) + 2) = 1;
            outcurves(1, 3*(idx-1) + 2) = - cos(theta) / sin(theta) + rho / sin(theta);
            outcurves(2, 3*(idx-1) + 3) = x_max;
            outcurves(1, 3*(idx-1) + 3) = - cos(theta) / sin(theta) * x_max + rho/sin(theta);
        end
        %}
    end
end

