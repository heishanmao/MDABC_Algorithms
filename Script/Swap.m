 %% 
 % @Author: Scott Zheng
 % @Date: 2022-03-02 21:32:56
 % @LastEditors: Scott Zheng
 % @LastEditTime: 2022-03-02 22:52:40
 % @FilePath: \Code\Script\Swap.m
 % @Description: 
 % @
 % @Copyright (c) 2022 by Scott Zheng, All Rights Reserved. 
 %% 
function Instance = Swap(Instance)
    numOfJobs = size(Instance,2);
    % 随机产生两个工件位置，交换
    %pos = randi([1,numOfJobs],1,2);
    pos = randperm(numOfJobs,2);  %不重复
    Instance(:,pos) = Instance(:,fliplr(pos));
end