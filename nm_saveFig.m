function nm_saveFig( fH, fName )
%nm_saveFig() saves both the .fig file and creates .pdf and .png versions

    expN = fullfile(pwd,fName);
    saveas(fH,[expN '.fig']); % saves the FIG file
%     export_fig([expN '.pdf'],fH,'-p12'); % creates a PDF
    % The -p12 puts a 12 pixel border around the plot region.
    export_fig(fH,expN,'-m4','-p0.01'); % creates a PNG
    % The -m4 increases the resolution by 4 times and the -p0.01 option
    % puts a small border around the plot region.

end

