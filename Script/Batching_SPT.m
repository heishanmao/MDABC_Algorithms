 %% 
 % @Author: Scott Zheng
 % @Date: 2022-03-02 21:32:55
 % @LastEditors: Scott Zheng
 % @LastEditTime: 2022-03-02 22:52:18
 % @FilePath: \Code\Script\Batching_SPT.m
 % @Description: 
 % @
 % @Copyright (c) 2022 by Scott Zheng, All Rights Reserved. 
 %% 
function [Batch, Cmax, TEC] = Batching_SPT(Instance, B, PlotSwitch)
    %  Shortest Processing time batching on the first machine
    numOfJobs = size(Instance,2);
    
    %% 以第一台机器加工时间非增排列
    Instance = sortrows(Instance',3)';
        
    %% batching   
    m = 7;  % Instance的第 m 行用来存储分批情况
    b = 1;
    for i=1:numOfJobs
        if i == 1
            Instance(m,i) = b;
        else
            indexSet = find(Instance(m,:)==b);
            % Calculate batch remain size
            batchRemainSize = B - sum(Instance(2,indexSet));
            if Instance(2,i) <= batchRemainSize
                Instance(m,i) = b;
            else
                b = b + 1;
                Instance(m,i) = b;
            end
        end
    end
    
    Batch = {};
    for k = 1:b
        bIndex = find(Instance(m,:)==k);
        Batch{1,k} = Instance(1,bIndex);  % 批内工件编号
        Batch{2,k} = sum(Instance(2,bIndex));   % 批的size
        Batch{3,k} = max(Instance(3,bIndex));   % 批的P1
        Batch{4,k} = sum(Instance(4,bIndex));   % 批的P2
        Batch{5,k} = mode(Instance(5,bIndex));  % Calculate machine 1 speed depending on the most frequently occurring value in A   
        Batch{6,k} = mode(Instance(6,bIndex));  % Calculate machine 2 speed
    end
    
    %% Obj
    [Cmax, TEC] = GetObjective(Batch, PlotSwitch);
end

