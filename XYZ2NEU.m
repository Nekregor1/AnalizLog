function [Xneu, Yneu, Zneu] = XYZ2NEU(Home, X,Y,Z)
%XYZ2N_E_U Summary of this function goes here
%   Detailed explanation goes here
    A_EARTH = 6378137;
    FLATTENING = 1/298.257223563;
    NAV_E2 = (2 - FLATTENING) * FLATTENING;
    Lat_home = Home.Lat;
    Lng_home = Home.Lng;
    Alt_home = Home.Alt;

    r_n = A_EARTH ./ sqrt(1 - NAV_E2 .* sin(Lat_home*pi/180) .* sin(Lat_home*pi/180));
    
    x_home = (r_n + Alt_home) .* cos(Lat_home*pi/180) .* cos(Lng_home*pi/180);
    y_home = (r_n + Alt_home) .* cos(Lat_home*pi/180) .* sin(Lng_home*pi/180);
    z_home = (r_n .* (1 - NAV_E2) + Alt_home) .* sin(Lat_home*pi/180);
    
%     disp(r_n)
%     disp([x_home, y_home, z_home])
    
    difv_x = X - x_home;
    difv_y = Y - y_home;
    difv_z = Z - z_home;
    
    R1 = Rotate((90 + Lng_home)*pi/180, 3);
    R2 = Rotate((90 - Lat_home)*pi/180, 1);
    R = R2*R1;
%     disp(R1)
%     disp(R2)
%     disp(R)
    
    Xneu = R(2,1) * difv_x + R(2,2) * difv_y + R(2,3) * difv_z;
    Yneu = R(1,1) * difv_x + R(1,2) * difv_y + R(1,3) * difv_z;
    Zneu = R(3,1) * difv_x + R(3,2) * difv_y + R(3,3) * difv_z;
end

