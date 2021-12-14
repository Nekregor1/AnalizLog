function [X, Y, Z] = NEU2XYZ(Lat_home, Lng_home, Alt_home, XNeu, YNeu, ZNeu)
%N Summary of this function goes here
%   Detailed explanation goes here
    R1 = Rotate((90 + Lng_home)*pi/180, 3);
    R2 = Rotate((90 - Lat_home)*pi/180, 1);
    R = R2*R1;
%     disp(R1)
%     disp(R2)
%     disp(R)

    R = R';
%     disp(R)
    
    X = R(1,1) * YNeu + R(1,2) * XNeu + R(1,3) * ZNeu;
    Y = R(2,1) * YNeu + R(2,2) * XNeu + R(2,3) * ZNeu;
    Z = R(3,1) * YNeu + R(3,2) * XNeu + R(3,3) * ZNeu;
    
    A_EARTH = 6378137;
    FLATTENING = 1/298.257223563;
    NAV_E2 = (2 - FLATTENING) * FLATTENING;
    r_n = A_EARTH ./ sqrt(1 - NAV_E2 .* sin(Lat_home*pi/180) .* sin(Lat_home*pi/180));
    
    x_home = (r_n + Alt_home) .* cos(Lat_home*pi/180) .* cos(Lng_home*pi/180);
    y_home = (r_n + Alt_home) .* cos(Lat_home*pi/180) .* sin(Lng_home*pi/180);
    z_home = (r_n .* (1 - NAV_E2) + Alt_home) .* sin(Lat_home*pi/180);
    
%     disp([x_home, y_home, z_home])
    
    X = X + x_home;
    Y = Y + y_home;
    Z = Z + z_home;
    
    disp([X, Y, Z])

    
    
end

