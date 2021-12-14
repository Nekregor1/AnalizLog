function [mtx] = Rotate(angle, type)
%ROTATE Summary of this function goes here
%   Detailed explanation goes here

if type==1
    mtx = [1 0 0; 0 cos(angle) sin(angle); 0 -sin(angle) cos(angle)];
elseif type==2
    mtx = [cos(angle) 0 -sin(angle); 0 1 0; sin(angle) 0 cos(angle)];
else
    mtx = [cos(angle) sin(angle) 0; -sin(angle) cos(angle) 0; 0 0 1];
end

end

