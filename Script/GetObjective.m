 %% 
 % @Author: Scott Zheng
 % @Date: 2022-03-02 21:32:55
 % @LastEditors: Scott Zheng
 % @LastEditTime: 2022-03-02 22:52:30
 % @FilePath: \Code\Script\GetObjective.m
 % @Description: 
 % @
 % @Copyright (c) 2022 by Scott Zheng, All Rights Reserved. 
 %% 
function [Cmax, TEC] = GetObjective(batch, PlotSwitch)
    %% 
    %Input：batch 
    %Output：两个目标
    numOfBatches = size(batch,2);
    
    startTime = zeros(2,numOfBatches);
    endTime = zeros(2,numOfBatches);
    
%     processingTime = cell2mat(batch(3:4,:));
%     speeds = cell2mat(batch(5:6,:));
%     processingTime = processingTime ./ speeds;
    
    [TEC, processingTime] = GetPower(batch);
    
    for i=1:numOfBatches
        if i == 1
            % 单独处理第一批 开始时间为0
            endTime(1,i) =  startTime(1,i) + processingTime(1,i); %第一台完工时间
            startTime(2,i) = endTime(1,i);   %第二台开始
            endTime(2,i) = startTime(2,i) + processingTime(2,i); %第二台完工
        else
            startTime(1,i) = endTime(1,i-1); % 开始时间等于上一批完成时间
            endTime(1,i) =  startTime(1,i) + processingTime(1,i);  %第一台完工时间
            startTime(2,i) = max( endTime(1,i), endTime(2,i-1));   %第二台开始 (第一台完工时间和第二台上一批完工时间)
            endTime(2,i) = startTime(2,i) + processingTime(2,i); %第二台完工
        end      
    end
    
    %% Return
    Cmax = endTime(2,numOfBatches);
    
    
    %% Plot
    if PlotSwitch
        figure; 
        hold on
        X = [startTime(1,:); endTime(1,:)];
        Y = [1; 1];
        X2 = [startTime(2,:); endTime(2,:)];
        Y2 = [2; 2];
        
        plot(X,Y, 'LineWidth',50);
        plot(X2,Y2,'LineWidth',50);
        
        %set(0,'DefaultAxesColorOrder',summer(numOfBatches))
        axis([0 inf 0 3])
        yticks([1 2])
        xlabel(['Cmax: ', num2str(Cmax), ' TEC: ' ,num2str(TEC)]);

        text(startTime(1,1)-10,1,'Processing')
        text(startTime(1,1)-10,1-0.5,'End')
        text(startTime(1,1)-10,2,'Processing')
        text(startTime(1,1)-10,2-0.5,'End')
        
        for i=1:numOfBatches
            for j=1:2
                text(startTime(j,i),j, mat2str(roundn(processingTime(j,i),-1))); % 加工时间
                text(startTime(j,i),j-0.5, mat2str(roundn(endTime(j,i),-1))); % 完工时间
            end
        end
    end

end

function [TEC, processingTime] = GetPower(batch)
    processingTime = cell2mat(batch(3:4,:));
    speeds = cell2mat(batch(5:6,:));
    processingTime = processingTime ./ speeds;  % 实际加工时间
    
    batches = size(batch,2);
    power = zeros(2,batches);
    
    for i = 1:2
        for j = 1:batches
            switch speeds(i,j)
                case 1
                    power(i,j) = 1;
                case 2
                    power(i,j) = 3;
                case 3
                    power(i,j) = 9;    
            end
        end
    end
    
    electricity = power .* processingTime;
    
    %% return
    TEC = sum(electricity(:));
end