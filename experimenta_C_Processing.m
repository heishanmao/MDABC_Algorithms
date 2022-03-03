 %% 
 % @Author: Scott Zheng
 % @Date: 2022-03-02 21:32:55
 % @LastEditors: Scott Zheng
 % @LastEditTime: 2022-03-02 22:41:18
 % @FilePath: \Code\experimenta_C_Processing.m
 % @Description: New export feature supported by Matlab r2020 or later
 % @ 
 % @Copyright (c) 2022 by Scott Zheng, All Rights Reserved. 
 %% 
%% ExParameters.m processing and plot
clear
clc
%ExParameters.m  C-metric.pdf

load('Results-all.mat')
%NAME = {'MDABC-LPT','MDABC-SPT','NSGA2-Johnson','NSGA2-SPT','SPEA2-Johnson','SPEA2-SPT'};
NAME = {'(MDABC-LPT,NSGA2-Johnson)','(NSGA2-Johnson,MDABC-LPT)','(MDABC-LPT,SPEA2-Johnson)','(SPEA2-Johnson,MDABC-LPT)','(NSGA2-Johnson,SPEA2-Johnson)','(SPEA2-Johnson,NSGA2-Johnson)'};
NAME2 = {'(MDABC-SPT,NSGA2-SPT)','(NSGA2-SPT,MDABC-SPT)','(MDABC-SPT,SPEA2-SPT)','(SPEA2-SPT,MDABC-SPT)','(NSGA2-SPT,SPEA2-SPT)','(SPEA2-SPT,NSGA2-SPT)'};
mark = ["-o",'--o','-*','--*','-d','--d'];

context = zeros(6,30);
for i = 1:30
    context(1,i) = GetCM(Results{1,1,i},Results{3,1,i});
    context(2,i) = GetCM(Results{3,1,i},Results{1,1,i});
    context(3,i) = GetCM(Results{1,1,i},Results{5,1,i});
    context(4,i) = GetCM(Results{5,1,i},Results{1,1,i});
    context(5,i) = GetCM(Results{3,1,i},Results{5,1,i});
    context(6,i) = GetCM(Results{5,1,i},Results{3,1,i});
end

context2 = zeros(6,30);
for i = 1:30
    context2(1,i) = GetCM(Results{2,1,i},Results{4,1,i});
    context2(2,i) = GetCM(Results{4,1,i},Results{2,1,i});
    context2(3,i) = GetCM(Results{2,1,i},Results{6,1,i});
    context2(4,i) = GetCM(Results{6,1,i},Results{2,1,i});
    context2(5,i) = GetCM(Results{4,1,i},Results{6,1,i});
    context2(6,i) = GetCM(Results{4,1,i},Results{4,1,i});
end



%% uisetcolor
colors = [[236,115,87];[253, 214, 146];[121,189,154];[207,240,158];[30, 192, 255];[163, 218, 255]]./255;

figure(1);
set(gca,'FontSize',14)
hold on;
box on;
grid on;
for j = 1:6 
    plot(1:30,context(j,:),mark(j),'color',colors(j,:),'LineWidth',2,'MarkerSize',6);
end

% ylim([0,1])   
% yticks(0:0.2:1)
% yticklabels({'0%','20%','40%','60%','80%','100%'})
xticks(1:2:30)
xlabel('Instances','FontWeight','bold');
ylabel('C-metric','FontWeight','bold');
legend(NAME,'Location','northoutside','Orientation','vertical','NumColumns',3)

set(gcf,'position',[0,0,1000,550])
exportgraphics(gca,'.\Figures\4-3-1.pdf','Resolution',300)  % matlab r2020 or later
hold off;

%% 2
figure(2);
set(gca,'FontSize',13)
hold on;
box on;
grid on;
for j = 1:6 
    plot(1:30,context2(j,:),mark(j),'color',colors(j,:),'LineWidth',2,'MarkerSize',8);
end

% ylim([0,1])   
% yticks(0:0.2:1)
% yticklabels({'0%','20%','40%','60%','80%','100%'})
xticks(1:2:30)
xlabel('Instances','FontWeight','bold');
ylabel('C-metric','FontWeight','bold');
legend(NAME2,'Location','northoutside','Orientation','vertical','NumColumns',3)

set(gcf,'position',[0,0,1000,550])
exportgraphics(gca,'.\Figures\4-3-2.pdf','Resolution',300)  % matlab r2020 or later
hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function CM_AB = GetCM(A,B)
    A = sortrows(cell2mat(A));
    B = sortrows(cell2mat(B));
    numOfA = size(A,1);
    numOfB = size(B,1);
    Num = 0;
    for i = 1:numOfB
        for j =1:numOfA
            if A(j,1)<=B(i,1) && A(j,2)<=B(i,2)
                Num = Num +1;
                break
            end
        end
    end
    CM_AB = Num / numOfB;
%     figure
%     hold on
%     plot(A(:,1),A(:,2),'-o')
%     plot(B(:,1),B(:,2),'-*')
end

