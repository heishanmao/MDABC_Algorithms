 %% 
 % @Author: Scott Zheng
 % @Date: 2022-03-02 22:13:13
 % @LastEditors: Scott Zheng
 % @LastEditTime: 2022-03-02 22:41:05
 % @FilePath: \Code\ExParameters.m
 % @Description: 
 % @
 % @Copyright (c) 2022 by Scott Zheng, All Rights Reserved. 
%% 
clear
clc
%% Settting to get all resutls 
B = 15;
ITERATION = 200;
PLOT = false;
MutProbabili = 0.9;
Probabili = 0.9;

%% loop
t1=clock;
int = 1;
for j=1:5
    for s=1:3
        for p=1:2
            [name,Instance,N] = getInstance(j,s,p);
            SN = 2.5*N;
            OnlookerBee = ceil(0.6*SN); 
            ScoutBee = ceil(0.3*SN);
            [Results{1,1,int},Results{1,2,int}] = Main_NSABC_FF(Instance, B, SN, OnlookerBee,ScoutBee, ITERATION, PLOT);
            [Results{2,1,int},Results{2,2,int}] = Main_NSABC_SPT(Instance, B, SN, OnlookerBee,ScoutBee, ITERATION, PLOT);
            [Results{3,1,int},Results{3,2,int}] = Main_NSGA_FF(Instance, B, SN, MutProbabili, ITERATION, PLOT);
            [Results{4,1,int},Results{4,2,int}] = Main_NSGA_SPT(Instance, B, SN, MutProbabili, ITERATION, PLOT);
            [Results{5,1,int},Results{5,2,int}] = Main_SPEA_FF(Instance, B, SN, Probabili, ITERATION, PLOT);
            [Results{6,1,int},Results{6,2,int}] = Main_SPEA_SPT(Instance, B, SN, Probabili, ITERATION, PLOT);
            
            Results{1,3,int} = name;
            
            save Results-all.mat Results;
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
    name = ['./Instance/','J',num2str(J(j)),' S',num2str(S(s,2)),' P',num2str(P(p,2)),'.mat'];
    load(name);
    %disp(name);
    N = J(j);
end
    