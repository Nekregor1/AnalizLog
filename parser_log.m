clc
clear variables
close all
% warning('off','all')
% warning



T = readtable('Вертолет_60000 2021.11.16 18.26.52 N51.csv');
A = table2array(T);


tutc = A(:,56);
Lat = double(A(:,25))/1e6;
Lng = double(A(:,26))/1e6;
Alt = double(A(:,27));

t = A(:,1) - A(1,1);

% Перевод из геодезической СК в геоцентрическую
[Xgeo, Ygeo, Zgeo] = LLA2XYZ(Lat, Lng, Alt);

% зададим точку стояния как первую точку полета
Lat_home = Lat(1);
Lng_home = Lng(1);
Alt_home = Alt(1);

X = zeros(1,length(Xgeo));
Y = zeros(1,length(Xgeo));
Z = zeros(1,length(Xgeo));
% перевод из геоцентрической СК в местную СК
for iter=1:length(Xgeo)
    [X(1,iter), Y(1,iter), Z(1,iter)] = XYZ2NEU(Lat_home, Lng_home, Alt_home, Xgeo(iter), Ygeo(iter), Zgeo(iter));
end





figure('Units','normalized','Position',[0 0 1 1])
hold on
grid on
view([25 75])
axis([min(X)-10 max(X)+10 min(Y)-10 max(Y)+10])
for iter=1:10:length(X)
    plot3(X(iter),Y(iter),Z(iter),'.r');
    line([X(iter), X(iter)], [Y(iter), Y(iter)], [Z(iter), 0]);
    pause(0.001);
end
