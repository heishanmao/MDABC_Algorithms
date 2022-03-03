 %% 
 % @Author: Scott Zheng
 % @Date: 2022-03-02 21:32:55
 % @LastEditors: Scott Zheng
 % @LastEditTime: 2022-03-02 22:43:09
 % @FilePath: \Code\Function\Main_NSGA_Johnson.m
 % @Description: 
 % @
 % @Copyright (c) 2022 by Scott Zheng, All Rights Reserved. 
 %% 
%% 两阶段差异工件流水车间批调度，考虑能耗
% Editor: Scott
% clear
% clc

function [Pareto,time] = Main_NSGA_Johnson(Instance, B, SN, MutProbabili, ITERATION, PLOT)
% M = 20; %初始种群的大小
% SN = 30; %子代种群的大小
% B = 10; %机器容量
% ITERATION = 200; %迭代次数
% MutProbabili = 0.9;

tic
    %% start
    for i = 1:SN*2
        Pop0{i,1} = getInstance(Instance);
        [Pop0{i,2}, Pop0{i,3}, Pop0{i,4}] = Batching_Johnson(Pop0{i,1}, B, false);
    end

    [Pop{1,1},Pop{1,2}] = GetNextGen(Pop0, SN);

    %% 迭代
    for i =1:ITERATION
        POP = Pop{i,1}; % cell
        for j = 1:SN
            POP{j,1} = Swap(POP{j,1}); %Crossover
            %POP{j,1} = Inseration(POP{j,1});
            if rand()>MutProbabili
                POP{j,1} = Rearrange(POP{j,1});     %Mutation
            end
            [POP{j,2}, POP{j,3}, POP{j,4}] = Batching_Johnson(POP{j,1}, B, false); % update results
        end
        %% 非支排序 选出下一代
        POP = [POP; Pop{i,1}];
        [Pop{i+1,1},Pop{i+1,2}] = GetNextGen(POP, SN);
    end
    if PLOT
        Plot(Pop{ITERATION,2});
    end
    Pareto = Pop{ITERATION,2};
    time =toc;
end

%% FUNCTION
function Instance = getInstance(Instance)
%     load('.\Instance\J300 S10 P40.mat');
    numOfJobs = size(Instance,2);
    %rng('default');  % 保证重复运行时是同一个实例，一般建议打开
    Instance(5,:) = randi([1,3],numOfJobs,1);  % 分配一组随机[1,3]的速度行向量 构成初始instance machine 1
    Instance(6,:) = randi([1,3],numOfJobs,1);  % 分配一组随机[1,3]的速度行向量 构成初始instance machine 2
    %rng('shuffle');
end

function Plot(Pt)
    figure(1);
    hold on;
    %numOfP = size(Pt,1);
    XY = cell2mat(sortrows(Pt,1));
    plot(XY(:,1), XY(:,2),'-o');
end
