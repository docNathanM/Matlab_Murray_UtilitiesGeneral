function [fh,axh,phS] = nm_plotScatterFieldWithHist(X,Y,VpltIn,inMask,varargin)
%nm_plotScatterFieldWithMask() generates a plot of the requested variable.

%% PARSE Input

defaultHistBinLims = 'full';
defaultDotSizeOption = 'value';
defaultScaleSize = 10;
defaultNumBins = 32;
defaultCBrewerMapName = 'Blues';
defaultFlipColorMap = false;
defaultFieldRefinement = 0;
defaultAxisRatioMode = 'auto';

p = inputParser;

validHistBinLims = @(x) (isnumeric(x) && numel(x) <= 2) ...
    || (ischar(x) && ismember(x,{'full'}));
validDotSizeOpts = @(x) ismember(x,{'value' 'count','none'});
validScaleSize = @(x) isnumeric(x) && numel(x) == 1;
validNumBins = @(x) isnumeric(x) && numel(x) == 1;
validFlipColorMap = @(x) islogical(x);
seqMapNames={'Blues','BuGn','BuPu','GnBu','Greens','Greys','Oranges',...
    'OrRd','PuBu','PuBuGn','PuRd','Purples','RdPu','Reds','YlGn',...
    'YlGnBu','YlOrBr','YlOrRd',...
    'BrBG','PiYG','PRGn','PuOr','RdBu','RdGy','RdYlBu','RdYlGn','Spectral'};
validInputBrewerName = @(x) ismember(x,seqMapNames);
validFieldRefinement = @(x) isreal(x) & x>=0 & mod(x,1)==0 & x<=5;
validAxisRatioMode = @(x) ismember(x,{'auto','equal','tight'});

addParameter(p,'HistBinLims',defaultHistBinLims,...
    validHistBinLims);
addParameter(p,'DotSizing',...
    defaultDotSizeOption,validDotSizeOpts);
addParameter(p,'ScaleSize',...
    defaultScaleSize,validScaleSize);
addParameter(p,'numBins',...
    defaultNumBins,validNumBins);
addParameter(p,'cBrewerMapName',defaultCBrewerMapName,...
    validInputBrewerName);
addParameter(p,'flipColorMap',defaultFlipColorMap,...
    validFlipColorMap);
addParameter(p,'fieldRefinement',defaultFieldRefinement,...
    validFieldRefinement);
addParameter(p,'axisRatioMode',defaultAxisRatioMode,...
    validAxisRatioMode);

parse(p,varargin{:})

HistBinLims = p.Results.HistBinLims;
DotSizing = p.Results.DotSizing;
cBrewerMapName = p.Results.cBrewerMapName;
scaleSize = p.Results.ScaleSize;
numBins = p.Results.numBins;
flipColorMap = p.Results.flipColorMap;
fieldRefinement = p.Results.fieldRefinement;
axisRatioMode = p.Results.axisRatioMode;

if ( ismember(cBrewerMapName,...
        {'BrBG','PiYG','PRGn','PuOr','RdBu','RdGy',...
        'RdYlBu','RdYlGn','Spectral'}) )
    cBrewerMapType = 'div';
else
    cBrewerMapType = 'seq';
end

%% Refine if Requested ...
if ( fieldRefinement > 0 )
    X = interp2(X,fieldRefinement,'linear');
    Y = interp2(Y,fieldRefinement,'liear');
    VpltIn = interp2(VpltIn,fieldRefinement,'cubic');
    inMask = interp2(inMask,fieldRefinement,'nearest');
end

%% Eliminate points with zero vectors ...
X = X(inMask(:));
Y = Y(inMask(:));
Vplt = VpltIn(inMask(:));

%% Create the Plots

% close all
fh = figure;
fh.Color = [1 1 1];
fh.Position = [1000 900 470 650];
axh(1) = axes;

% Plot the scatter of Vplt ...
phS = scatter(axh(1),X,Y,[],Vplt);

switch axisRatioMode
    case 'equal'
        axis equal
    case 'tight'
        axis equal
    otherwise
end

outSet = 1.1;
axh(1).XLim = mean(X)*[1 1] + outSet*range(X)/2*[-1 1];
axh(1).YLim = mean(Y)*[1 1] + outSet*range(Y)/2*[-1 1];

axh(1).Position = [0.15 0.37 0.80 0.65];
axh(1).FontName = 'times';
axh(1).FontSize = 16;
axh(1).Box = 'on';
axh(1).XLabel.String = '$x$ [mm]';
axh(1).XLabel.Interpreter = 'latex';
axh(1).XLabel.FontSize = 18;
axh(1).YLabel.String = '$y$ [mm]';
axh(1).YLabel.Interpreter = 'latex';
axh(1).YLabel.FontSize = 18;

%% Plot the histogram of cnt ...
axh(2) = axes;
axh(2).Position = [0.15 0.11 0.80 0.2];

if ( ischar(HistBinLims) )
    switch HistBinLims
        case 'full'
            dataLims = nm_minmax(Vplt(:));
            inBinLim = max(abs(dataLims))*[-1 1];
        otherwise
            inBinLim = 100*[-1 1];
    end
else
    switch numel(HistBinLims)
        case 1
            inBinLim = HistBinLims * [-1 1];
        case 2
            inBinLim = HistBinLims;
    end
end

[binCounts,binEdges] = histcounts(Vplt,numBins,...
    'normalization','count','binlimits',inBinLim);
binW = binEdges(2)-binEdges(1);
binCenters = binEdges(1:end-1) + binW/2;
hh = bar(binCenters,binCounts,'hist');
axh(2).FontName = 'times';
axh(2).FontSize = 16;
axh(2).Box = 'on';
axh(2).XLabel.Interpreter = 'latex';
axh(2).XLabel.String = 'Number of Vectors at a Grid Location';
axh(2).XLabel.FontSize = 18;
axh(2).YLabel.Interpreter = 'latex';
axh(2).YLabel.String = '\# of Grid Locations';
axh(2).YLabel.FontSize = 18;

%% Size and Color the Scatter Data Based on the Histogram
% So, I am finding the appropriate bin for each scatter
% point by using the min(abs( )) to return the index in idhist that most
% closely matches the n'th value to the right bin. This will give me a
% value between 0 and 1 for dotArea() ...

valColr = cbrewer(cBrewerMapType,cBrewerMapName,numBins,'pchip');
if ( flipColorMap )
    valColr = flipud(valColr);
end

dotArea = zeros(numel(Vplt),1);
dotColors = zeros(numel(Vplt),3);

for n=1:numel(Vplt)
    [~,idhist] = min(abs(binEdges(1:end-1) - Vplt(n)));
    switch DotSizing
        case 'value'
            dotArea(n) = binCenters(idhist)/max(binCenters);
        case 'count'
            dotArea(n) = binCounts(idhist)/max(binCounts);
        case 'none'
            dotArea(n) = 1.0;
    end
    dotColors(n,:) = valColr(idhist,:);
end

% Set dot Size ...
dotSize = abs(dotArea)*scaleSize;
% check for zero dot sizes ...
dotSize(dotSize == 0) = 0.5*min(dotSize(dotSize~=0));

hh.FaceVertexCData = valColr;

phS.CData = dotColors;
phS.SizeData = dotSize;
phS.MarkerFaceColor = 'flat';
phS.MarkerEdgeColor = 'none';

%% Fix Arrangement of Axis

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
figh = fh.Position(4);
a = axh(1).Position(2)+axh(1).Position(4);

topScale = 0.97;
fh.Position(4) = figh*a/topScale;
axh(1).Position(2) = axh(1).Position(2)*topScale/a;
axh(1).Position(4) = axh(1).Position(4)*topScale/a;
axh(2).Position(2) = axh(2).Position(2)*topScale/a;
axh(2).Position(4) = axh(2).Position(4)*topScale/a;

end




