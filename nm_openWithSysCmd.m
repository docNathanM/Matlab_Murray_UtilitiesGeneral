function nm_openWithSysCmd(inputFileName)
%MACOPEN Open a file or directory using the OPEN terminal utility on the MAC.
%   MACOPEN FILENAME opens the file or directory FILENAME using the
%   the OPEN terminal command. 
%
%   Examples:
%
%     If you have Microsoft Word installed, then
%     macopen('/myDoc.docx')
%     opens that file in Microsoft Word if the file exists, and errors if
%     it doesn't.
%
%     macopen('/Applications')
%     opens a new Finder window, showing the contents of your /Applications
%     folder.
%   
%   See also WINOPEN, OPEN, DOS, WEB.
%   Copyright 2012 - 2020 The MathWorks Inc.
%   Written: 16-Apr-2012 , Varun Gandhi
%   Edit: 2-Nov-2020 , N. Murray

if strcmpi('.',inputFileName)
    inputFileName = pwd;
end
syscmd = ['open "', inputFileName, '" &'];
disp(['Running the following in the Terminal: "', syscmd,'"']);
system(syscmd);

