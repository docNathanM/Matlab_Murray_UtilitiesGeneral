function axh = nm_fixAxisArrangement(ahIn)

% Fix Arrangement of Axis
axh = ahIn;
% Start with some good numbers for the axes positions. I had to tweak this
% to get it just right.
axh(1).Position = [0.15 0.37 0.80 0.60];
axh(2).Position = [0.15 0.09 0.80 0.2];

% Modify the scatter plot axis height based on the aspect ratio of the axes
% within the axis. This fixes the space between the scatter and histogram
% in the figure caused by the axis equal command.
a = axh(1).PlotBoxAspectRatio(1)/axh(1).PlotBoxAspectRatio(2);
axh(1).Position(4) = axh(1).Position(4)/a;

% Now, resize the figure height to get rid of white space.
fh = axh.Parent;
figh = fh.Position(4);
a = axh(1).Position(2)+axh(1).Position(4);

topScale = 0.97;
fh.Position(4) = figh*a/topScale;
axh(1).Position(2) = axh(1).Position(2)*topScale/a;
axh(1).Position(4) = axh(1).Position(4)*topScale/a;
axh(2).Position(2) = axh(2).Position(2)*topScale/a;
axh(2).Position(4) = axh(2).Position(4)*topScale/a;

end

