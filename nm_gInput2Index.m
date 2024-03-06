function [indX] = nm_gInput2Index(ah,Xarray,Yarray)

axes(ah); % makes sure current axis is in focus ...

[x,y] = ginput(1);

X = Xarray;
Y = Yarray;

[~,idX] = min(abs(X - x));
[~,idY] = min(abs(Y - y));

delXY = diff(X(1:2));

a = x - delXY;
b = y - delXY;

rH = rectangle('Position',[a b delXY delXY],'Curvature',1);

indX = [idX idY];

end

