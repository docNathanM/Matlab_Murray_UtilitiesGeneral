%% NM Fig RePlot
% With an open figure that plots lines on a standard axis ...

fh = gcf; % Get the current figure
ah = gca; % Get the current axis
ph = findobj(fh,'type','line'); % finds the lines in the figure
lh = findobj(fh,'type','legend');

% Set properties of the figure ...
fh.Color = [1 1 1];
fh.Position = [900 300 980 600];
movegui(fh,'north');

% Set axis properties ...
% ah.XLabel.String = '$x$';
ah.XLabel.Interpreter = 'latex';
ah.XLabel.FontSize = 18;
% ah.YLabel.String = '$y$';
ah.YLabel.Interpreter = 'latex';
ah.YLabel.FontSize = 18;
ah.Title.Interpreter = 'latex';
ah.Title.FontSize = 16;
ah.FontSize = 14;
ah.FontName = 'times';
ah.Box = 'on';
ah.NextPlot = 'add';

% Set line properties ...
ph = flipud(ph);
N = length(ph);
for cn = 1:N
    ph(cn).Color = (cn - 1)/N * [1 1 1];
    ph(cn).LineWidth = (N - cn + 1)/N * 1.5;
end

% Fix legend format if the legend is showing ...
if (~isempty(lh))
    lh.Interpreter = 'latex';
    lh.FontSize = 16;
end

% Clear data cursors just in case there are any showing ...
dcm = datacursormode(fh);
dcm.removeAllDataCursors