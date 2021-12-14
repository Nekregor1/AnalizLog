clc
clear variables
close all

tic

flagVideo = true;
%%
Volk.fileName = 'Вертолет_60000 2021.12.10 13.16.43 N111.csv';
Sima.fileName = 'Вертолет_60000 2021.12.10 14.32.56 N91.csv';

Volk.folderName = 'Volk\';
Sima.folderName = 'Sima\';

A_volk = readmatrix(strcat(Volk.folderName,Volk.fileName));
A_sima = readmatrix(strcat(Sima.folderName,Sima.fileName));

fid = fopen(strcat(Volk.folderName,Volk.fileName));
line_ex = fgetl(fid);
fclose(fid);
Volk.headers = convertCharsToStrings(split(line_ex, ","));

fid = fopen(strcat(Sima.folderName,Sima.fileName));
line_ex = fgetl(fid);
fclose(fid);
Sima.headers = convertCharsToStrings(split(line_ex, ","));

%% Задание и перевод времени в unix
Sima.count_ddmmyyyy = find(Sima.headers == '[Время] Дата (ddmmyyyy)');
Sima.count_hhmmssss = find(Sima.headers == '[Время] Время (hhmmsssss)');

Volk.count_ddmmyyyy = find(Volk.headers == '[Время] Дата (ddmmyyyy)');
Volk.count_hhmmssss = find(Volk.headers == '[Время] Время (hhmmsssss)');

Sima.ddmmyyyy = A_sima(:,Sima.count_ddmmyyyy);
Volk.ddmmyyyy = A_volk(:,Volk.count_ddmmyyyy);

Sima.hhmmssss = A_sima(:,Sima.count_hhmmssss);
Volk.hhmmssss = A_volk(:,Volk.count_hhmmssss);

Sima.unixtime = round(time2unix(Sima.hhmmssss, Sima.ddmmyyyy),2);
Volk.unixtime = round(time2unix(Volk.hhmmssss, Volk.ddmmyyyy),2);


% figure
% hold on
% grid on
% ylim([0 5])
% plot(Sima.unixtime, 2*ones(1, length(Sima.unixtime)))
% plot(Volk.unixtime, 1*ones(1, length(Volk.unixtime)))

%%

Sima.count_Lat = find(Sima.headers == '[Координаты в географической СК] Широта (микро град)');
Sima.count_Lng = find(Sima.headers == '[Координаты в географической СК] Долгота (микро град)');
Sima.count_Alt = find(Sima.headers == '[Координаты в географической СК] Высота (м)');

Volk.count_Lat = find(Volk.headers == '[Координаты в географической СК] Широта (микро град)');
Volk.count_Lng = find(Volk.headers == '[Координаты в географической СК] Долгота (микро град)');
Volk.count_Alt = find(Volk.headers == '[Координаты в географической СК] Высота (м)');

Volk.count_TargetLat = find(Volk.headers == '[Точка цели] Широта (микроград)');
Volk.count_TargetLng = find(Volk.headers == '[Точка цели] Долгота (микроград)');
Volk.count_TargetAlt = find(Volk.headers == '[Точка цели] Высота (м)');

Sima.Lat = A_sima(:, Sima.count_Lat)/1e6;
Sima.Lng = A_sima(:, Sima.count_Lng)/1e6;
Sima.Alt = A_sima(:, Sima.count_Alt);

Volk.Lat = A_volk(:, Volk.count_Lat)/1e6;
Volk.Lng = A_volk(:, Volk.count_Lng)/1e6;
Volk.Alt = A_volk(:, Volk.count_Alt);

Volk.TargetLat = A_volk(:, Volk.count_TargetLat)/1e6;
Volk.TargetLng = A_volk(:, Volk.count_TargetLng)/1e6;
Volk.TargetAlt = A_volk(:, Volk.count_TargetAlt)+222.73;

% Перевод из геодезической СК в геоцентрическую
[Sima.Xgeo, Sima.Ygeo, Sima.Zgeo] = LLA2XYZ(Sima.Lat, Sima.Lng, Sima.Alt);
[Volk.Xgeo, Volk.Ygeo, Volk.Zgeo] = LLA2XYZ(Volk.Lat, Volk.Lng, Volk.Alt);
[Volk.TargetXgeo, Volk.TargetYgeo, Volk.TargetZgeo] = LLA2XYZ(Volk.TargetLat, Volk.TargetLng, Volk.TargetAlt);


% зададим точку стояния как первую точку полета
HomePoint.Lat = Sima.Lat(1);
HomePoint.Lng = Sima.Lng(1);
HomePoint.Alt = Sima.Alt(1);

% перевод из геоцентрической СК в местную СК

Sima.length = length(Sima.Alt);
for iter = 1:Sima.length
    [Sima.X(iter,1), Sima.Y(iter,1), Sima.Z(iter,1)] = ...
        XYZ2NEU(HomePoint, Sima.Xgeo(iter), Sima.Ygeo(iter), Sima.Zgeo(iter));
end

Volk.length = length(Volk.Alt);
for iter=1:Volk.length
    [Volk.X(iter,1), Volk.Y(iter,1), Volk.Z(iter,1)] = ...
        XYZ2NEU(HomePoint, Volk.Xgeo(iter), Volk.Ygeo(iter), Volk.Zgeo(iter));
    [Volk.TargetX(iter,1), Volk.TargetY(iter,1), Volk.TargetZ(iter,1)] = ...
        XYZ2NEU(HomePoint, Volk.TargetXgeo(iter), Volk.TargetYgeo(iter), Volk.TargetZgeo(iter));
end

% Выделение самонаведения (наведение по координатам)
Volk.count_Autoguidance = find(Volk.headers == '[Канал автопилота] Относительное положение');
Volk.count_Course = find(Volk.headers == '[Автопилот] Текущий курс (град)');

Volk.Autoguidance = A_volk(:, Volk.count_Autoguidance);
Volk.Course = A_volk(:, Volk.count_Course);



temp3 = 0;

Time(:,1) = min(Sima.unixtime(1), Volk.unixtime(1)):0.01:max(Sima.unixtime(Sima.length), Volk.unixtime(Volk.length));

% figure
% hold on
% grid on
% view([25 75])
% axis([min(Sima.X)-20 max(Sima.X)+20 min(Sima.Y)-20 max(Sima.Y)+20])
% plot3(Sima.X, Sima.Y, Sima.Z)
% plot3(Volk.X, Volk.Y, Volk.Z)

% figure('Units','normalized','Position',[0 0 1 1])
% hold on
% grid on
% view([25 45])
% axis([min(Sima.X)-20 max(Sima.X)+20 min(Sima.Y)-20 max(Sima.Y)+20])
% for iter=1:10:length(Time)
%     temp = find(Sima.unixtime == Time(iter));
%     if temp
%         plot3(Sima.X(temp), Sima.Y(temp), Sima.Z(temp), '.k')
%     end
%     temp = find(Volk.unixtime == Time(iter));
%     if temp
%         plot3(Volk.X(temp), Volk.Y(temp), Volk.Z(temp), '.r')
%     end
%     pause(0.002)
% end

Volk.AutoguidanceCountNum = 0;
Volk.AutoguidanceFirstCount = [];
Volk.AutoguidanceCountLength = [];
flag = false;

for iter = 1:Volk.length
    if Volk.Autoguidance(iter)== 100 
        if flag == false
            Volk.AutoguidanceCountNum = Volk.AutoguidanceCountNum + 1;
            flag = true;
            Volk.AutoguidanceFirstCount = [Volk.AutoguidanceFirstCount iter];
            Volk.AutoguidanceCountLength = [Volk.AutoguidanceCountLength 1];
        else
            Volk.AutoguidanceCountLength(Volk.AutoguidanceCountNum) = ...
                Volk.AutoguidanceCountLength(Volk.AutoguidanceCountNum) + 1;
        end
    else
        if flag == true
            flag = false;
        end
    end

end

[X,  Y,  Z]  = cylinder([0 20], 4); Z  = Z*20;

for iter=1:Volk.AutoguidanceCountNum
    figure('Units','normalized','Position',[0 0 1 1])
    hold on
    grid on
%     view([25 45])
    axis([min(Sima.X)-20 max(Sima.X)+20 min(Sima.Y)-20 max(Sima.Y)+20])
    if flagVideo
        set(gca);
        fileNameVideo = strcat('intercept',num2str(iter));
        v = VideoWriter(fileNameVideo);
        open(v);
    end

    for count1 = 0 : 10 : Volk.AutoguidanceCountLength(iter)-1
        count = count1 + Volk.AutoguidanceFirstCount(iter);
        plot3(Volk.X(count), Volk.Y(count), Volk.Z(count), '.r')
        temp = find(Sima.unixtime == (Volk.unixtime(count)) );
        plot3(Sima.X(temp), Sima.Y(temp), Sima.Z(temp), '.k')
        if mod(count1,20)==0
            M = makehgtform('translate', ...
                [Volk.X(count),Volk.Y(count), Volk.Z(count)], 'yrotate', pi/2, 'xrotate', -Volk.Course(count)*pi/180, 'zrotate', pi/4);
            surf(X,  Y,  Z,  'Parent', hgtransform('Matrix', M), 'LineStyle', 'none', ...
                'FaceColor', 'blue', 'FaceAlpha', 0.01);
        end
        if flagVideo
            frame = getframe(gcf);
            writeVideo(v,frame);
        else
            pause(0.001)
        end
    end
    if flagVideo
        close(v);
    end
end


Volk.count_VelocityHoriz = find(Volk.headers == '[Скорость относительно Земли] Горизонтальная (м-с)');
Sima.count_VelocityHoriz = find(Sima.headers == '[Скорость относительно Земли] Горизонтальная (м-с)');

Sima.VelocityHoriz = A_sima(:, Sima.count_VelocityHoriz);
Volk.VelocityHoriz = A_volk(:, Volk.count_VelocityHoriz);

% figure
% hold on
% grid on
% plot(Volk.unixtime - Volk.unixtime(1), Volk.VelocityHoriz)
% plot(Volk.unixtime - Volk.unixtime(1), Volk.Autoguidance/10)
% plot(Volk.Autoguidance)

% figure
% hold on
% grid on
% plot(Sima.unixtime - Sima.unixtime(1), Sima.VelocityHoriz)


TimeCalc = toc;