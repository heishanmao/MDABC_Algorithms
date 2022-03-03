 %% 
 % @Author: Scott Zheng
 % @Date: 2022-03-02 21:32:55
 % @LastEditors: Scott Zheng
 % @LastEditTime: 2022-03-02 22:41:20
 % @FilePath: \Code\experimenta_D_Processing.m
 % @Description: New export feature supported by Matlab r2020 or later
 % @
 % @Copyright (c) 2022 by Scott Zheng, All Rights Reserved. 
 %% 
%% ExParameters.m processing and plot
clear
clc
%ExParameters.m  D-metric.pdf

load('Results-all.mat')
NAME = {'MDABC-LPT','MDABC-SPT','NSGA2-Johnson','NSGA2-SPT','SPEA2-Johnson','SPEA2-SPT'};
mark = ["-o",'--o','-*','--*','-d','--d'];

context = zeros(6,30);
for i = 1:30
    for j = 1:6
        context(j,i) =GetDM(Results{j,1,i});
    end
end

context = context([3,4,1,2,5,6],:);

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
ylabel('D-metric','FontWeight','bold');
legend(NAME,'Location','northoutside','Orientation','vertical','NumColumns',3)

set(gcf,'position',[0,0,1000,550])
exportgraphics(gca,'.\Figures\4-4.pdf','Resolution',300)  % matlab r2020 or later


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function DM = GetDM(Pt)
    Pt = cell2mat(sortrows(Pt,1));
    numOfPt = size(Pt,1);
    for i =1:numOfPt-1
        d(1,i)=sqrt((Pt(i,1)-Pt(i+1,1))^2+(Pt(i,2)-Pt(i+1,2))^2);
    end
    dMean = mean(d);
    DM = 0;
    for i = 1:numOfPt-1
        DM = DM + (d(i)-dMean)^2;
    end
    DM = sqrt(DM/numOfPt-1);
end

