 %% 
 % @Author: Scott Zheng
 % @Date: 2022-03-02 21:32:55
 % @LastEditors: Scott Zheng
 % @LastEditTime: 2022-03-02 22:52:33
 % @FilePath: \Code\Script\Inseration.m
 % @Description: 
 % @
 % @Copyright (c) 2022 by Scott Zheng, All Rights Reserved. 
 %% 
function Instance = Inseration(Instance)
    numOfJobs = size(Instance,2);
    % 随机产生两个工件位置(不重复)，前插
    %pos = randi([1,numOfJobs],1,2);
    pos = randperm(numOfJobs,2);
    pos = sort(pos);
    jobs = Instance(1,:);
    inserJob = jobs(pos(2));
    right = jobs(pos(1):end);
    right(right==inserJob) = [];
    jobs(pos(1)) = inserJob;
    jobs(pos(1)+1:end) = right;
end