 %% 
 % @Author: Scott Zheng
 % @Date: 2022-03-02 21:32:55
 % @LastEditors: Scott Zheng
 % @LastEditTime: 2022-03-02 22:41:30
 % @FilePath: \Code\Generate_Instance.m
 % @Description: 
 % @
 % @Copyright (c) 2022 by Scott Zheng, All Rights Reserved. 
 %% 
%% ���ɴ��⹤������
% Editor: Scott
clear
clc

%% ���� n, sj, pjm,
%mkdir('Instance', datestr(now,'yyyy_mm_dd HH_MM_SS'))

for j = 1:5
    for s = 1:3
        for p = 1:2
            [Instance,name] =  Generate(j, s, p);
            filename = ['./Instance/',name, '.mat'];
            save (filename , 'Instance');
        end
    end
end
% [Instance,name] =  GenerateInstance(1,2, 2, 2 ,B);
% % д���ļ�
% filename = ['./Instance/',name, '.mat'];
% save (filename , 'Instance');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                                            %   Function   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Instance,name] = Generate(j, s, p)
    %% ���ɲ��Թ���ʵ������
    %   j,s,p,r ����Ϊ0ʱ �������ʵ��
    % ��������ʵ��
    name = -1;
    J = [10, 20, 50, 120, 300]; 
    S = [2, 4; 4, 8;1, 10];
    P = [1, 20; 1, 40];
    
    if j == 0 && s == 0 && p == 0
        % ������ɲ���ʵ��       
        % ������ģ
        num = J(randi(size(J,2)));
        jobSet = zeros(5, num);
        % �������---��һ��
        jobSet(1,:) = 1:num; 
        
        % �����ߴ�--�ڶ���
        jobSize = randi(size(S,1));
        jobSet(2,:) = randi([S(jobSize,1),S(jobSize,2)],[1,num]);
        
        % �����ӹ�ʱ�䣬���׶�ʱ��ֲ�һ��---����������
        jobTime = randi(size(P,1));
        jobSet(3:4,:)= randi([P(jobTime,1),P(jobTime,2)],[2,num]);
        
        % �������������ܺ�--������
        %jobEnergy = randi(size(H,1));
        %jobSet(5,:) = randi([H(jobEnergy,1),H(jobEnergy,2)],[1,num]);
        
        % ��ʼ��
        name = ['J',num2str(num),' S',num2str(S(jobSize,2)),' P',num2str(P(jobTime,2))];
        disp([num2str(num),'-jobs:',name]);
    else 
        % ����������
        num = J(j);
        jobSet = zeros(4,num);
        % �������---��һ��
        jobSet(1,:) = 1:num; 

        % �����ߴ�---�ڶ���
        jobSet(2,:) = randi([S(s,1),S(s,2)],[1,num]);
        
        % �����ӹ�ʱ�䣬���׶�ʱ��ֲ�һ��,������
        jobSet(3:4,:)= randi([P(p,1),P(p,2)],[2,num]);
        
        % �������������ܺ�--������
        %jobSet(5,:) = randi([H(h,1),H(h,2)],[1,num]);
        
        % ��ʼ��
        name = ['J',num2str(num),' S',num2str(S(s,2)),' P',num2str(P(p,2))];
        disp([num2str(num),'-jobs:',name]);
    end

    Instance = jobSet;
end
