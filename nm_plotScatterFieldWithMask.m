function [fh,axH,scH,cbH] = nm_plotScatterFieldWithMask(X,Y,VpltIn,inMask,varargin)
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
defaultColorBarLabel = '';

p = inputParser;

validHistBinLims = @(x) (isnumeric(x) && numel(x) <= 2) ...
    || (isstring(x) && ismember(x,{'full'}));
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
validInputString = @(x) ischar(x);

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
addParameter(p,'pltLabel',defaultColorBarLabel,...
    validInputString);

parse(p,varargin{:})

HistBinLims = p.Results.HistBinLims;
DotSizing = p.Results.DotSizing;
cBrewerMapName = p.Results.cBrewerMapName;
scaleSize = p.Results.ScaleSize;
numBins = p.Results.numBins;
flipColorMap = p.Results.flipColorMap;
fieldRefinement = p.Results.fieldRefinement;
axisRatioMode = p.Results.axisRatioMode;
pltLabel = p.Results.pltLabel;

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

% Eliminate points based on Mask
X = X(inMask(:));
Y = Y(inMask(:));
Vplt = VpltIn(inMask(:));

%% Create the Plots

fh = figure();
fh.Color = [1 1 1];
fh.Position = [1000 900 470 450];
axH = axes;
axH.NextPlot = 'add';

% Plot the Scatter of Vplt ...
% I need to order the values so that the largest values of Vplt are plotted
% last so that they are "on top" ...
[~,I] = sort(Vplt,'ascend');
Vplt = Vplt(I);
X = X(I);
Y = Y(I);
scH = scatter(axH,X,Y,[],Vplt);

switch axisRatioMode
    case 'equal'
        axis equal
    case 'tight'
        axis equal
    otherwise
end
outSet = 1.1;
axH.XLim = mean(X(:))*[1 1] + outSet*range(X(:))/2*[-1 1];
axH.YLim = mean(Y(:))*[1 1] + outSet*range(Y(:))/2*[-1 1];

axH.FontName = 'times';
axH.FontSize = 16;
axH.Box = 'on';
axH.XLabel.String = '$x$ [mm]';
axH.XLabel.Interpreter = 'latex';
axH.XLabel.FontSize = 18;
axH.YLabel.String = '$y$ [mm]';
axH.YLabel.Interpreter = 'latex';
axH.YLabel.FontSize = 18;

%% Use Histogram to color and size scatter data but don't plot

if ( isstring(HistBinLims) )
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

% * Size and Color the Scatter Data Based on the Histogram *
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

scH.Marker = 'o';
scH.MarkerFaceColor = 'flat';
scH.MarkerEdgeColor = 'none';
scH.CData = dotColors;
scH.SizeData = dotSize;

% * Add Colorbar to Plot *
colormap(valColr)
caxis(inBinLim)
cbH = colorbar;
cbH.Label.String = pltLabel;
cbH.Label.FontSize = 18;
cbH.Label.Interpreter = 'latex';

aspR = 0.01 * floor(size(VpltIn,1)/size(VpltIn,2)/0.01);
heiGHT = 400;
widTH = floor(heiGHT/aspR);
fh.Position(3:4) = [widTH heiGHT];

end




