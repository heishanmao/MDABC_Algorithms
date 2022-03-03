 %% 
 % @Author: Scott Zheng
 % @Date: 2022-03-02 21:32:56
 % @LastEditors: Scott Zheng
 % @LastEditTime: 2022-03-02 22:52:37
 % @FilePath: \Code\Script\Rearrange.m
 % @Description: 
 % @
 % @Copyright (c) 2022 by Scott Zheng, All Rights Reserved. 
 %% 
function Instance = Rearrange(Instance)
    % Replace all speed machines for one instance
    numOfJobs = size(Instance, 2);
    Instance(5:6,:) = randi([1,3],2,numOfJobs); % Rearrange
end