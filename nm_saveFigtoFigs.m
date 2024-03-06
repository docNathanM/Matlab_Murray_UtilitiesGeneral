function nm_saveFigtoFigs( fHin, fNameIN, varargin )
%nm_saveFig() can save the .fig file and create .pdf and .png
% Depends on ~/altmany-export_fig/export_fig.m
%
% REQUIRED:    fHin => Figure handle for figure to save.
%           fNameIN => Figure name without extension.
%
% OPTIONAL:
%   - doPNG  -  boolean  -  default TRUE  => Saves *.png output
%   - doPDF  -  boolean  -  default FALSE => Saves *.pdf output
%   - doFIG  -  boolean  -  default FALSE => Saves *.fig output
%  - outFigFolder - string - default 'figs'

%% PARSE Input
p = inputParser;

defaultFigFolder = 'figs';
defaultDoFIG = false;
defaultDoPNG = true;
defaultDoPDF = false;
validInputFigH = @(x) strcmp(class(x),'matlab.ui.Figure');
validInputFigName = @(x) ischar(x);
    
addRequired(p,'fHin',validInputFigH);
addRequired(p,'fNameIN',validInputFigName);
addParameter(p,'doPNG',defaultDoPNG,@(x) islogical(x));
addParameter(p,'doPDF',defaultDoPDF,@(x) islogical(x));
addParameter(p,'doFIG',defaultDoFIG,@(x) islogical(x));
addParameter(p,'outFigFolder',defaultFigFolder,@(x) ischar(x));

parse(p,fHin,fNameIN,varargin{:})

fH = p.Results.fHin;
expN = p.Results.fNameIN;
outFigFolder = p.Results.outFigFolder;
doPNG = p.Results.doPNG;
doPDF = p.Results.doPDF;
doFIG = p.Results.doFIG;

%%

    if ( exist(fullfile('.',outFigFolder),'file') ~= 7 )
        mkdir(outFigFolder)
    else
    end
    
    if ( doFIG )
        saveas(fH,fullfile(outFigFolder,[expN '.fig'])); % saves the FIG file
    end
    
    if ( doPDF )
        % creates a PDF
        export_fig(fullfile(outFigFolder,[expN '.pdf']),fH,'-p12');
        % The -p12 puts a 12 pixel border around the plot region.
    end
    
    if ( doPNG )
        % creates a PNG
        export_fig(fH,fullfile(outFigFolder,[expN '.png']),'-m4','-p0.01');
        % The -m4 increases the resolution by 4 times and the -p0.01 option
        % puts a small border around the plot region.  
    end

end

