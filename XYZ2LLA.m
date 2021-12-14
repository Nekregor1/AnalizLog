function [Lat, Lng, Alt] = XYZ2LLA(X, Y, Z)
%XYZ2LLA Summary of this function goes here
%   Detailed explanation goes here
    A_EARTH = 6378137;
    FLATTENING = 1/298.257223563;
    NAV_E2 = (2 - FLATTENING) * FLATTENING;

    if (X == 0 && Y == 0 && Z == 0) 
      disp( "Error: XYZ at center of the earth");
    end
    
    if (X == 0 && Y == 0) 
        Lng = 0;
    else
        Lng = atan2(Y, X);
    end
    
    rhoSqrd = X * X + Y * Y;
    rho = sqrt(rhoSqrd);
    tempLat = atan2(Z, rho);
    tempAlt = sqrt(rhoSqrd + Z * Z) - A_EARTH;
    rhoError = 1000.0;
    zError = 1000.0;

    while (abs(rhoError) > 0.000001 || abs(zError) > 0.000001)
        sinLat = sin(tempLat);
        cosLat = cos(tempLat);
        q = 1.0 - NAV_E2 * sinLat * sinLat;
        r_n = A_EARTH / sqrt(q);
        drdl = r_n * NAV_E2 * sinLat * cosLat / q;
        
        rhoError = (r_n + tempAlt) * cosLat - rho;
        zError = (r_n * (1.0 - NAV_E2) + tempAlt) * sinLat - Z;
        
        AA = drdl * cosLat - (r_n + tempAlt) * sinLat;
        BB = cosLat;
        CC = (1.0 - NAV_E2) * (drdl * sinLat + r_n * cosLat);
        DD = sinLat;
        
        invdet = 1.0 / (AA * DD - BB * CC);
        tempLat = tempLat - invdet * (DD * rhoError - BB * zError);
        tempAlt = tempAlt - invdet * (-1 * CC * rhoError + AA * zError);
    end

    Lat = tempLat;
    Alt = tempAlt;
    
end

