 %% 
 % @Author: Scott Zheng
 % @Date: 2022-03-02 21:32:55
 % @LastEditors: Scott Zheng
 % @LastEditTime: 2022-03-02 22:41:08
 % @FilePath: \Code\experiment1.m
 % @Description: 
 % @
 % @Copyright (c) 2022 by Scott Zheng, All Rights Reserved. 
 %% 
clear
clc
%% 
PLOT =false;
B = 15;
ITERATION = 200;

%%
t1=clock;
int = 1;
for j = 1:5
    for s=1:1
        for p=1:1
            [name,Instance,N] = getInstance(j,s,p);
            SN = 3*N;
            OnlookerBee = ceil(0.9*SN); 
            ScoutBee = ceil(0.9*SN);
               
            [Results{1,1,int},Results{1,2,int}] = Main_NSABC_FF(Instance, B, SN, OnlookerBee,ScoutBee, ITERATION, PLOT);
            [Results{2,1,int},Results{2,2,int}] = Main_NSABC_Johnson(Instance, B, SN, OnlookerBee,ScoutBee, ITERATION, PLOT);
            [Results{3,1,int},Results{3,2,int}] = Main_NSABC_LPT(Instance, B, SN, OnlookerBee,ScoutBee, ITERATION, PLOT);
            [Results{4,1,int},Results{4,2,int}] = Main_NSABC_SPT(Instance, B, SN, OnlookerBee,ScoutBee, ITERATION, PLOT);
            Results{1,3,int} = name;
            
            save Results-experiment1.mat Results;
            
            t2=clock;
            X = [name,' 已运行',num2str(int), '次 ',num2str(etime(t2,t1)), 's'];
            disp(X);
            
            int = int+1;
        end
    end
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [name,Instance,N] = getInstance(j,s,p)
    
    J = [10, 20, 50, 120, 300]; 
    S = [2, 4; 4, 8;1, 10];
    P = [1, 20; 1, 40];
    name = ['.\Instance\','J',num2str(J(j)),' S',num2str(S(s,2)),' P',num2str(P(p,2)),'.mat'];
    load(name);
    %disp(name);
    N = J(j);
end
    