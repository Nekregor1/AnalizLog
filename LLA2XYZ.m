function [X,Y,Z] = LLA2XYZ(Lat,Lon, Alt)
%LLA2XYZ Summary of this function goes here
%   Detailed explanation goes here
A_EARTH = 6378137;
FLATTENING = 1/298.257223563;
NAV_E2 = (2 - FLATTENING) * FLATTENING;


r_n = A_EARTH ./ sqrt(1 - NAV_E2 .* sin(Lat*pi/180) .* sin(Lat*pi/180));

X = (r_n + Alt) .* cos(Lat*pi/180) .* cos(Lon*pi/180);
Y = (r_n + Alt) .* cos(Lat*pi/180) .* sin(Lon*pi/180);
Z = (r_n .* (1 - NAV_E2) + Alt) .* sin(Lat*pi/180);

end

