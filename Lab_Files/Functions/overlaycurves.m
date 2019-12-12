function overlaycurves(image, curves)

% OVERLAYCURVES(IMAGE, CURVES)
%
% Displays CURVES overlayed on IMAGE
%
% The format of these curves is the same as for CONTOURC

insize = size(curves, 2);
trypointer = 1;

showgrey(image);

hold on;

while trypointer <= insize,
  polylength = curves(2, trypointer);

  plot(curves(1, (trypointer+1):(trypointer+polylength)), ...
       curves(2, (trypointer+1):(trypointer+polylength)), 'b');

  trypointer = trypointer + 1 + polylength;
end;

hold off;
