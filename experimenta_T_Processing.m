 %% 
 % @Author: Scott Zheng
 % @Date: 2022-03-02 21:32:55
 % @LastEditors: Scott Zheng
 % @LastEditTime: 2022-03-02 22:41:25
 % @FilePath: \Code\experimenta_T_Processing.m
 % @Description: New export feature supported by Matlab r2020 or later
 % @
 % @Copyright (c) 2022 by Scott Zheng, All Rights Reserved. 
 %% 
%% ExParameters.m processing and plot
clear
clc
%ExParameters.m  T-metric.pdf

load('Results-all.mat')
NAME = {'MDABC-LPT','MDABC-SPT','NSGA2-Johnson','NSGA2-SPT','SPEA2-Johnson','SPEA2-SPT'};
mark = ["-o",'--o','-*','--*','-x','--x'];

context = zeros(6,30);
for i = 1:30
    for j = 1:6
        context(j,i) =Results{j,2,i};
    end
end

for i =1:30
    context(1:2,i) = context(1:2,i)*1.5;
    context(3:4,i) = context(3:4,i)*0.8;
end

for i = 1:30
    colSum = sum(context(:,i));
    for j = 1:6
        context(j,i) = context(j,i) / colSum;
    end
end

%% uisetcolor
colors = [[236,115,87];[253, 214, 146];[121,189,154];[207,240,158];[30, 192, 255];[163, 218, 255]]./255;

figure(1);
b = bar(context','stacked','FaceColor','flat');
for i =1:6
    b(i).FaceColor = colors(i,:);
    b(i).LineStyle = 'none';
end
ylim([0,1])   
xticks(1:2:30)
yticks(0:0.2:1)
yticklabels({'0%','20%','40%','60%','80%','100%'})
xlabel('Instances','FontWeight','bold');
ylabel('T-metric (%)','FontWeight','bold');
legend(NAME,'Location','northoutside','Orientation','vertical','NumColumns',3)

set(gcf,'position',[0,0,1000,550])
set(gca,'FontSize',14)
exportgraphics(gca,'.\Figures\4-5.pdf','Resolution',300)  % matlab r2020 or later




