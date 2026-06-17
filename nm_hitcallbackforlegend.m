function nm_hitcallbackforlegend(src,evnt)
% nm_hitcallbackforlegend() adds a callback functionality to plot legends.
%   The function alternatively shows or hides lines when the user clicks on
%   the item in the legend. Useful for interactively exploring data in
%   matlab.
%
% HOW TO: Create a legend for a plot with the handle 'lh' like this ...
%
%   lh = legend(...);
%
% Add this line to attached the callback function 
%
%   lh.ItemHitFcn = @nm_hitcallbackforlegend;

if strcmp(evnt.Peer.Visible,'on')
    evnt.Peer.Visible = 'off';
else 
    evnt.Peer.Visible = 'on';
end

end