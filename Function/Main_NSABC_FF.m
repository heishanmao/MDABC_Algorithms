 %% 
 % @Author: Scott Zheng
 % @Date: 2022-03-02 21:32:55
 % @LastEditors: Scott Zheng
 % @LastEditTime: 2022-03-02 22:42:29
 % @FilePath: \Code\Function\Main_NSABC_FF.m
 % @Description: 
 % @
 % @Copyright (c) 2022 by Scott Zheng, All Rights Reserved. 
 %% 
%% 两阶段差异工件流水车间批调度，考虑能耗
% Editor: Scott
% clear
% clc

function [Pareto,time] = Main_NSABC_FF(Instance, B, SN, OnlookerBee,ScoutBee, ITERATION, PLOT)
%Instance = getInstance();
% B = 10; % set machine capacity
% SN = 30;
% OnlookerBee = ceil(0.5*SN);
% ScoutBee = ceil(0.2*SN);
% ITERATION = 100;  % iteration_max
% PLOT = true;
    tic
    %% 初始种群 FF
    for i = 1:SN*2
        Pop0{i,1} = getInstance(Instance);
        [Pop0{i,2}, Pop0{i,3}, Pop0{i,4}] = Batching_FirstFit(Pop0{i,1,1}, B, false);
    end
    [Pop{1,1},Pop{1,2}] = GetNextGen(Pop0, SN);

    for i = 2:ITERATION
        POP = Pop{i-1,1};
        %% Employed bees
        for j = 1:SN
            POP{j,1} = Swap(POP{j,1});  
            POP{j,1} = Inseration(POP{j,1});
        end
        %% Onlooker bees
        % ramdamly find some individual update it with Transform
        OBIndex = randperm(SN,OnlookerBee); % 5 控制种群中变形个体的数目
        for obIndex = 1:size(OBIndex,2)
            POP{obIndex,1} = Transform(POP{obIndex,1});
        end
        %% Scout bees
        SBIndex = randperm(SN,ScoutBee); % 2 控制种群中重新安排个体的数目
        for sbIndex = 1:size(SBIndex,2)
            POP{sbIndex,1} = Rearrange(POP{sbIndex,1});
        end
        %% FF batching
        for j = 1:SN
            [POP{j,2}, POP{j,3}, POP{j,4}] = Batching_FirstFit(POP{j,1}, B, false); % update results
        end
        POP = [POP; Pop{i-1,1}]; % 合并上一代
        [Pop{i,1},Pop{i,2}] = GetNextGen(POP, SN);
    end
    if PLOT
        Plot(Pop{ITERATION,2});
    end
    Pareto = Pop{ITERATION,2};
    time = toc;
end 


%% FUNCTION
function Instance = getInstance(Instance)
    %load('.\Instance\J300 S10 P40.mat');
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
    plot(XY(:,1), XY(:,2),'-*');
end
