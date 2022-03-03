 %% 
 % @Author: Scott Zheng
 % @Date: 2022-03-02 21:32:55
 % @LastEditors: Scott Zheng
 % @LastEditTime: 2022-03-02 22:52:27
 % @FilePath: \Code\Script\GetNextGen.m
 % @Description: 
 % @
 % @Copyright (c) 2022 by Scott Zheng, All Rights Reserved. 
 %% 
function [NextGen, PopPareto] = GetNextGen(Pop, SN)
    [FrontNO,~] = NDSort(cell2mat(Pop(:,3:4)),inf);
    FrontNO(2,:) = CrowdingDistance(cell2mat(Pop(:,3:4)));
    PopObj = [];
    PopPareto = Pop(FrontNO(1,:)==1,3:4);
    FrontNO(3,:) =1;
    while size(PopObj,2) < SN
        [~,minIndex] = find(FrontNO(1,:) == min(FrontNO(1,:)));
        [~,col] = find(FrontNO(3,minIndex) == 1);
        minIndex = minIndex(col);
        [~,maxminIndex] = find(FrontNO(2,minIndex)==max(FrontNO(2,minIndex)));
        MaxIndex = minIndex(maxminIndex);
        PopObj = [PopObj, MaxIndex(1)];
        FrontNO(3,MaxIndex(1)) = 0;
        FrontNO(1,MaxIndex(1)) = inf;
    end
    NextGen = Pop(PopObj,:);
end