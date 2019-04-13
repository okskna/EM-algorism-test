rng(30);

N1 = 900; % 점의 개수 1
N2 = 300; % 점의 개수 1
N3 = 300; % 점의 개수 1
M1_x = 10; % 중심 좌표 1 
M1_y = 10;
M2_x = 5; % 중심 좌표 2
M2_y = 15;
M3_x = 15; % 중심 좌표 3
M3_y = 15;
r1 = 5; % 반지름
r2 = 2.07;
r3 = 2.07;
cnt = 1;
mouse = zeros(N1+N2+N3, 2);

%% mouse face
while 1
    x_1 = (rand(1) - r1 / 10) .* 10 + M1_x;
    y_1 = (rand(1) - r1 / 10) .* 10 + M1_y;
    if Euclidean_distance(M1_x, M1_y, x_1, y_1) <= r1
        mouse(cnt, :) = [x_1, y_1];
        cnt = cnt + 1;
        if cnt > N1
            break
        end
    else
    end
end

%% mouse left ear
while 1
    x_2 = (rand(1) - r2 / 10) .* 10 + M2_x;
    y_2 = (rand(1) - r2 / 10) .* 10 + M2_y;
    if Euclidean_distance(M2_x, M2_y, x_2, y_2) <= r2
        mouse(cnt, :) = [x_2, y_2];
        cnt = cnt + 1;
        if cnt > N2 + N1
            break
        end
    else
    end
end

%% mouse right ear
while 1
    x_3 = (rand(1) - r3 / 10) .* 10 + M3_x;
    y_3 = (rand(1) - r3 / 10) .* 10 + M3_y;
    if Euclidean_distance(M3_x, M3_y, x_3, y_3) <= r3
        mouse(cnt, :) = [x_3, y_3];
        cnt = cnt + 1;
        if cnt > N3 + N2 + N1
            break
        end
    else
    end
end


%% Draw graph
figure('Name','original')
hold on
for i = 1:(N1 + N2 + N3)
    if i > N1 + N2
        scatter(mouse(i, 1), mouse(i, 2), 'b', 'filled');
    elseif i > N1
        scatter(mouse(i, 1), mouse(i, 2), 'r', 'filled');
    else
        scatter(mouse(i, 1), mouse(i, 2), 'g', 'filled');
    end
end
scatter(M1_x, M1_y,'MarkerEdgeColor',[0 .5 .5],...
   'LineWidth',2.5)
scatter(M2_x, M2_y,'MarkerEdgeColor',[0 .5 .5],...
   'LineWidth',2.5)
scatter(M3_x, M3_y,'MarkerEdgeColor',[0 .5 .5],...
   'LineWidth',2.5)

hold off