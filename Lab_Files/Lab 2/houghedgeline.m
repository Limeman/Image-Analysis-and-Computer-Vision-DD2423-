function [linepar, acc] = houghedgeline(pic, scale, gradmagnthreshold, ...
    nrho, ntheta, nlines, verbose)
    gradmag = Lv(pic);
    curves = extractedge(pic, scale, gradmagnthreshold, 'same');
    
    if verbose >= 1
        figure;
        showgrey(gradmag)
        title('Gradient magnitude')
    end
    
    [linepar, acc] = houghline(curves, gradmag, nrho, ntheta, ...
        gradmagnthreshold, nlines, verbose);
    
    if verbose >= 1
        figure;
        overlaycurves(pic, curves)
        title('Detected edges')
        
        figure;
        showgrey(acc)
        title('Accumulator')
        
        figure;
        % TODO: to_cartesian does not work!
        cartesian_lines = to_cartesian(linepar, size(gradmag, 1)^2 + size(gradmag, 2)^2);
        %overlaycurves(pic, cartesian_lines)
        
       showgrey(pic)
        hold on
        insize = size(cartesian_lines, 2);
        trypointer = 1;
        
        while trypointer <= insize
            polylength = cartesian_lines(2, trypointer);
            
            plot(cartesian_lines(1, trypointer + 1:trypointer+polylength),...
                cartesian_lines(2, trypointer + 1:trypointer+polylength), 'b');

            trypointer = trypointer + 1 + polylength;
        end
        axis([0, size(gradmag, 1), 0, size(gradmag, 2)])
        hold off
    end
    linepar = to_cartesian(linepar, size(gradmag, 1)^2 + size(gradmag, 2)^2);
end