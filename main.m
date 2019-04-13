N = 1500; % Sample 의 개수
X_matrix = mouse; % mouse sample 사용

k=3; % 군집 개수 설정

C = cell(1, k);
C_num = ones(1, k);

Z = zeros(k, 2);
Z_temp = zeros(k, 2);

for i = 1:k
    C{1, i} = cell(1, 1);
    Z(i, :) = X_matrix(i, :);
end

%% k-means 알고리즘: k개의 군집의 중심을 추정해나가는 알고리즘 
...지역 최적해, 연산빠름, 연산이 느린 EM알고리즘의 초기 데이터를 위해 사용
while 1
    for i = 1:k
        C_num(1, i) = 1;
        C{1, i} = cell(1, 1);
    end  
    
    
    %% Z(mu, sigma)에 따른 군집 배정
    for i = 1:N
       d = 28.28;
       for j = 1:k %중심점 C로부터 각 점 까지의 거리 계산
           d_temp = Euclidean_distance(Z(j, 1), Z(j, 2), X_matrix(i, 1), X_matrix(i, 2));
           if d_temp < d
               d = d_temp;
               Zgroup = j;
           end
       end
       %거리에 따른 군집 배정  % k변수에 따라 Generic 하지 못함 수정 요
       C{1, Zgroup}{1, C_num(1, Zgroup)} = X_matrix(i, :);
       C_num(1, Zgroup) = C_num(1, Zgroup) + 1;
    end
    C_num = C_num - 1;
    
    %% Z(mu, sigma)의 수정
    for i = 1:k
        Z_temp(i, :) = central_point(C_num(1, i), C{1, i});
    end
    
    temp = 1;
    for i = 1:k
        temp = temp & (Z_temp(i, :) == Z(i, :));
    end
    if temp == 1
       break
    else
       for i = 1:k
           Z(i, :) = Z_temp(i, :);
       end
    end
end


%% EM 알고리즘

C_matrix = cell(1,k);

C_sigma = cell(1, k);
C_mu = cell(1, k);
C_pi = cell(1, k);

for i = 1:k
    C_matrix{1, i} = zeros(C_num(1, k), 2);
end

for i = 1:k
    for j = 1:C_num(1, i)
        C_matrix{1, i}(j, :) = C{1, i}{1, j};
    end
end

% 평균
for i = 1:k
    C_mu{1, i} = sum(C_matrix{1, i}) ./ C_num(1, i);
end

for i = 1:k
    C_sigma{1, i} = zeros(2,2);
end

for i = 1:k
    for j = 1:C_num(1, i)
        C_sigma{1, i} = C_sigma{1, i} + (C_matrix{1, i}(j, :) - C_mu{1, i})' ...
            * (C_matrix{1, i}(j, :) - C_mu{1, i});
    end
end

% 분산 및 가중치
for i= 1:k
    C_sigma{1, i} = C_sigma{1, i} ./ C_num(1, i);
    C_pi{1, i} = C_num(1, i) / N;
end

cnt = 0;
while 1
    cnt = cnt + 1; % 몇회 수행시 종료되는지를 알려주는 변수
    end_flag = zeros(1, k); % 종료 조건 초기화
    C_z = zeros(N, k); % 은닉 변수 초기화
    %% E stap
    C_prob = zeros(1, k); % 각 sample 이 k군에 소속될 확률 변수
    for i = 1:N
        tempB = 0;
        for j = 1:k
                y = normal_distribution(X_matrix(i, :), C_mu{1, j}, C_sigma{1, j});
                tempB = tempB + C_pi{1, j} .* y; 
        end

        for j = 1:k
            y = normal_distribution(X_matrix(i, :), C_mu{1, j}, C_sigma{1, j});
            tempA = C_pi{1, j} * y;
            C_prob(1, j) = tempA / tempB;
        end
        [M, I] = max(C_prob);
        C_z(i, I) = 1;
%         if I == 1
%             C_z(i,:) = [1, 0, 0];
%         elseif I == 2
%             C_z(i,:) = [0, 1, 0];
%         elseif I == 3
%             C_z(i,:) = [0, 0, 1];
%         else %error
%             C_z(i,:) = [0, 0, 0];
%         end
    end
    
    %% M stap
    for j = 1:k
        temp_mu = 0;
        temp_sigma = 0;
        C_num(1, j) = sum(C_z(:, j));
        for i = 1:N
            temp_mu = temp_mu + C_z(i, j) .* X_matrix(i, :);
        end
        if 1 ./ C_num(1, j) * temp_mu == C_mu{1, j} %종료조건 계산
            end_flag(1, j) = 1;
        end
        C_mu{1, j} = 1 ./ C_num(1, j) * temp_mu;
        for i = 1:N
            temp_sigma = temp_sigma + C_z(i, j) .* ...
                (X_matrix(i, :) - C_mu{1, j})' * (X_matrix(i, :) - C_mu{1, j});
        end
        C_sigma{1, j} = 1 ./ C_num(1, j) * temp_sigma;
        C_pi{1, j} = C_num(1, j) / N;
    end
    
    %% 종료조건 (현재의 중심점이 이전 중심점의 값과 같으면 종료)
    if sum(end_flag) == k
        break
    end
end

%% GRAPH
figure('Name','EM')
hold on
for i = 1:N
    [M, I] = max(C_z(i, :));
    color_index = ones(1, 3);
    color_index(1, rem(I, 3) + 1) = 1 - I/k;
    scatter(X_matrix(i, 1), X_matrix(i, 2), [], color_index, 'filled')
end
for i = 1:k
    scatter(C_mu{1, i}(1, 1), C_mu{1, i}(1, 2),'MarkerEdgeColor',[0 .5 .5],...
   'LineWidth',2.5)        
end
hold off

