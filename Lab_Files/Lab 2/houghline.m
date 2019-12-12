function [linepar, acc] = houghline(curves, magnitude, nrho, ntheta, ...
    threshold, nlines, verbose)
    % Check if input appear to be valid
    if verbose == 2
        fprintf('Checking if inputs apear to be valid\n')
    end
    if nrho < 1 || ntheta < 1
        error('Accumulator space must be non-zero, received:\nnrho = %d and ntheta = %d\n', nrho, ntheta)
    end
    
    if nlines < 1
        error('Atleast one line should be extracted, received:\nnlines = %d\n', nlines)
    end
    
    if verbose == 2
        fprintf('Allocating accumulator space\n')
    end
    % Allocate accumulator space
    acc = zeros(nrho, ntheta);
    
    if verbose == 2
        fprintf('Defining coordinate system in the accumulator space\n')
    end
    % Define a coordinate system in the accumulator space
    thetacoords = -pi/2: pi/ (ntheta - 1):pi/2;
    rhomax = hypot(size(magnitude, 1), size(magnitude, 2));
    rhocoords = -rhomax:(2 * rhomax) / (nrho - 1):rhomax;
    
    if verbose == 2
        fprintf('Looping over all curves to get hough space representation of edges\n')
    end
    % Loop over all the input curves (cf. pixelplotcurves)
    insize = size(curves, 2);
    trypointer = 1;
    
    
    ncurves = 0;
    while trypointer <= insize
        if verbose == 2
            fprintf('Curve index %d\n', ncurves)
        end
        % For each point on each curve
        polylength = curves(2, trypointer);
        ncurves = ncurves + 1;
        trypointer = trypointer + 1;
        
        for polyidx=1:polylength
            % Check if valid point with respect to threshold
            x = round(curves(2, trypointer));
            y = round(curves(1, trypointer));
            
            trypointer = trypointer + 1;
            if magnitude(x, y) - threshold < 0
                continue
            end
            % Optionally, keep value from magnitude image
            %mag = magnitude(x, y);
            
            % Loop over a set of theta values
            for theta=thetacoords
                if verbose == 2
                    fprintf('theta = %d\n', theta)
                end
                % Compute rho for each theta value
                rho = x * cos(theta) + y * sin(theta);
                % Compute index values in the accumulator space
                rhoind = find(rhocoords < rho, true, 'last');
                thetaind = find(thetacoords == theta);
                % Update the accumulator
                if verbose == 2
                    fprintf('rhoind = %d, thetaind = %d\n', rhoind, thetaind);
                end
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %               SELECT ACC INCREMENT                      %
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %acc(rhoind, thetaind) = acc(rhoind, thetaind) + 1;
                acc(rhoind, thetaind) = acc(rhoind, thetaind) + log(magnitude(x, y));
            end
        end
    end
    if verbose == 2
        fprintf('accumulator complete\n')
    end
    
    % Extract local maxima from the accumulator
    [pos, value] = locmax8(acc);
    [~, indexvector] = sort(value);

    
    % Delimit the number of responses if necessary
    nmaxima = size(value, 1);
    
    % Compute a line for each one of the strongest responses in the accumulator
    linepar = zeros(2, nlines);
    for i=1:nlines
        rhoidxacc = pos(indexvector(nmaxima - i + 1), 1);
        thetaidxacc = pos(indexvector(nmaxima - i + 1), 2);
        
        linepar(1, i) = rhocoords(rhoidxacc);
        linepar(2, i) = thetacoords(thetaidxacc);
    end
    
    % Overlay these curves on the gradient magnitude image
    
    
    % Return the output data
    % <already done earlier above>
end