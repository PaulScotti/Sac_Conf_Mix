function [c, f] = closer_farther(xx,yy,zz) % is yy closer or father to xx compared to zz?
if wrap360(xx,yy) > 0 && wrap360(xx,zz) > 0
    c = 1; f = 0;
elseif wrap360(xx,yy) < 0 && wrap360(xx,zz) < 0
    c = 1; f = 0;
elseif wrap360(xx,yy) > 0 && wrap360(xx,zz) < 0
    c = 0; f = 1;
elseif wrap360(xx,yy) < 0 && wrap360(xx,zz) > 0
    c = 0; f = 1;
else
    c = 0; f = 0;
end
