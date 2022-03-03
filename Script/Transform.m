 %% 
 % @Author: Scott Zheng
 % @Date: 2022-03-02 21:32:56
 % @LastEditors: Scott Zheng
 % @LastEditTime: 2022-03-02 22:52:42
 % @FilePath: \Code\Script\Transform.m
 % @Description: 
 % @
 % @Copyright (c) 2022 by Scott Zheng, All Rights Reserved. 
 %% 
function Instance = Transform(Instance)
    % find any one position for each instance and replace a brand new speed
    % for each machine
    numOfJobs = size(Instance, 2);
    position = randperm(numOfJobs,1);
    Instance(5:6,position) = randi([1,3],2,1);  % 分配一组随机[1,3]的速度行向量 构成初始instance machine 1&2
end