function pltFlag = nm_createPlotMaskEdgeFix(inMask)
%nm_createPlotMaskEdgeFix() makes a nice mask for the data
% This pulls the mask from the DaVis Frame and then does a 3x3 neighbor
% search to further eliminate points on the edge of the data ... I found
% that these points were typically not good in some cases, so I typically
% remove them.

pltFlag = inMask;
Bmask = not(pltFlag);
neighborMask = xor(conv2(double(Bmask),ones(3),'same')>0,Bmask);
pltFlag(neighborMask) = false;

end

