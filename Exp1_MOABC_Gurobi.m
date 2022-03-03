 %% 
 % @Author: Scott Zheng
 % @Date: 2022-03-02 21:32:55
 % @LastEditors: Scott Zheng
 % @LastEditTime: 2022-03-02 22:40:05
 % @FilePath: \Code\Exp1_MOABC_Gurobi.m
 % @Description: 
 % @
 % @Copyright (c) 2022 by Scott Zheng, All Rights Reserved. 
 %% 

%% experiment1-data processing and plot
clear
clc
%% Gurobi results loading
fileNames = [10,20,50,120,300];
R = {};
for i = 1:5 % number of instance
    R{i,3} = readmatrix(".\GUROBIModel\Leveled_J"+ num2str(fileNames(i))+" S4 P20.csv",'TrimNonNumeric',true);
    R{i,1} = R{i,3}(:,2:6);
    R{i,1}(:,[1,2]) = R{i,1}(:,[2,1]);
    R{i,1} = sortrows(R{i,1},1,{'ascend'});
    R{i,2} = mean(R{i,1}(:,3));
    R{i,1} = num2cell(R{i,1});
    R{i,4} = num2str(fileNames(i));
end

%% matlab results
load('Results-experiment1.mat')
NAME = 'MOABC';
mark = ["-o",'-*','-+','-x', '--p'];
upBound = [350, 770, 1630, 3855, 9059];
for j = 1:5 % results only for J10 instance
    list = [1,7,13,19,25];
    h = list(j);
    a = Results(:,:,h);
    disp(a{1,3});
    a(5,1:2) = R(j,1:2); % gurobi results
    for i = 1:5 % 5 methods
        XY = cell2mat(a{i,1});
        if j == 1
            XY = sortrows(XY,2,{'descend'});
        else
            XY = sortrows(XY,2,{'descend'});
        end
        figure(j);
        set(gca,'FontSize',13)
        hold on;
        box on;
        %title(num2str(h))
        if i == 5
            XY = XY(XY(:,2) < upBound(j),:);
            [FrontNO,MaxFNO] = NDSort(XY,1);
            XY = XY(FrontNO==1,1:2);
            plot(XY(:,1),XY(:,2),mark(i),'MarkerSize',6,'MarkerFaceColor','#77AC30');
        else
            plot(XY(:,1),XY(:,2),mark(i),'MarkerSize',4);
        end
        %legend([NAME,'-FF'],[NAME,'-Johnson'],[NAME,'-LPT'],[NAME,'-SPT'],'GUROBI(Possible)');
        xlabel('$C_{max}$','Interpreter','latex','FontWeight','bold')
        ylabel('$TEC$','Interpreter','latex','FontWeight','bold')           
        %saveas(gcf,[num2str(h),'.pdf'])
    end
    %% Check if optimal exist
    Points = cell2mat(a{5,1});
    Pxy = Points(Points(:,4)==1,1:2);
    Gaps = ceil(mean(Points(Points(:,4)~=1,5))*100);
    if ~isempty(Pxy)
        Pxy = Pxy(Pxy(:,2)<upBound(j),:);
        plot(Pxy(:,1),Pxy(:,2),'Color','#A2142F','Marker','p','MarkerSize',6,'MarkerFaceColor','#A2142F','LineStyle','none');
        % legend([NAME,'-FF'],[NAME,'-Johnson'],[NAME,'-LPT'],[NAME,'-SPT'],['GUROBI (',num2str(Gaps),'% Gaps)'],'GUROBI (Optimal)');
        legend([NAME,'-FF'],[NAME,'-Johnson'],[NAME,'-LPT'],[NAME,'-SPT'],'GUROBI (Suboptimal)','GUROBI (Optimal)');
    else
        % legend([NAME,'-FF'],[NAME,'-Johnson'],[NAME,'-LPT'],[NAME,'-SPT'],['GUROBI (',num2str(Gaps),'% Gaps)']);
        legend([NAME,'-FF'],[NAME,'-Johnson'],[NAME,'-LPT'],[NAME,'-SPT'],'GUROBI (Suboptimal)');
    end
    %% save files
    name = a{1,3};
    name = deblank(name);
    name = regexp(name, '\', 'split');
    name = regexp(name, '.mat', 'split');
    name = name{1,3}{1};
    name = deblank(name);  
    hold off;
    fig = gcf;
    hgexport(fig,['.\Figures\',NAME,'_',name]);
    [result,msg] = eps2xxx(['.\Figures\',NAME,'_',name,'.eps'],{'pdf'},'C:\Program Files\gs\gs9.53.3\bin\gswin64c.exe');
    delete (['.\Figures\',NAME,'_',name,'.eps']);
end
