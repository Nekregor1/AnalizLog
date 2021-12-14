function [unix_time] = time2unix(hms,ymd)
%TIME2UNIX Summary of this function goes here
%   Detailed explanation goes here
% DELTA_UNIX_TIME = 24144;
DELTA_UNIX_TIME = 13599;

timeFly = zeros(height(hms),9);
timeFly(:,1) = hms;
timeFly(:,5) = ymd;

timeFly(:,2) = floor(timeFly(:,1)/1e7);
temp = (timeFly(:,1) - timeFly(:,2)*1e7);
timeFly(:,3) = floor(temp/1e5);
timeFly(:,4) = (temp - timeFly(:,3)*1e5)/1e3;
timeFly(:,8) = floor(timeFly(:,5)/1e6);
temp = (timeFly(:,5) - timeFly(:,8)*1e6);
timeFly(:,7) = floor(temp/1e4);
timeFly(:,6) = temp - timeFly(:,7)*1e4;

timeFly(:,9) = (timeFly(:,6)-1970) * 31556926 + (timeFly(:,7)-1) * 2629743 + ...
    (timeFly(:,8)-1) * 86400 + timeFly(:,2) * 3600 + timeFly(:,3) * 60 + ...
    timeFly(:,4) - DELTA_UNIX_TIME;

unix_time = timeFly(:,9);
end

