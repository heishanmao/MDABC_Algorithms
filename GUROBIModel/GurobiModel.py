'''
Author: Scott Zheng
Date: 2022-03-02 21:33:08
LastEditors: Scott Zheng
LastEditTime: 2022-03-02 22:41:52
FilePath: \Code\GUROBIModel\GurobiModel.py
Description: 

Copyright (c) 2022 by Scott Zheng, All Rights Reserved. 
'''

from gurobipy import *
import pandas as pd
from numpy import arange
from scipy.io import loadmat

def GModel(Jobs, Name, timeLimitiation, basedTEC):
    #Name = "Scheduling"
    model = Model(Name)

    ## parameters
    No = Jobs.shape[1]  # indexed by j
    Size = Jobs.loc['Size', :].to_numpy()
    PT1 = Jobs.loc['PT1', :].to_numpy()
    PT2 = Jobs.loc['PT2', :].to_numpy()
    K = 15
    M = 1000
    e_i_m = [[1, 1], [3, 3], [9, 9]]  # indexed by i
    v_i_m = [[1, 1], [2, 2], [3, 3]]

    ## Variables
    X_j_b = model.addVars(No, No, vtype=GRB.BINARY, name='X_j_b')
    Y_i_b_m = model.addVars(3, No, 2, vtype=GRB.BINARY, name='Y_i_b_m')
    P_b_m = model.addVars(No, 2, vtype=GRB.CONTINUOUS, lb=0, name="P_b_m")
    t_b_m = model.addVars(No, 2, vtype=GRB.CONTINUOUS, lb=0, name="t_b_m")
    E_b_m = model.addVars(No, 2, vtype=GRB.CONTINUOUS, lb=0, name='E_b_m')
    S_b_m = model.addVars(No, 2, vtype=GRB.CONTINUOUS, lb=0, name='S_b_m')

    ## Conts
    for j in range(No):
        model.addConstr(quicksum(X_j_b[j, b] for b in range(No)) == 1)

    for b in range(No):
        for m in range(2):
            model.addConstr(quicksum(Y_i_b_m[i, b, m] for i in range(3)) == 1)

    for b in range(No):
        model.addConstr(quicksum(Size[j] * X_j_b[j, b] for j in range(No)) <= K)

    for j in range(No):
        for b in range(No):
            model.addConstr(P_b_m[b, 0] - PT1[j] + M * (1 - X_j_b[j, b]) >= 0)

    for b in range(No):
        model.addConstr(P_b_m[b, 1] - quicksum(PT2[j] * X_j_b[j, b] for j in range(No)) >= 0)

    for i in range(3):
        for m in range(2):
            for b in range(No):
                model.addConstr(t_b_m[b, m] - P_b_m[b, m] / v_i_m[i][m] + M * (1 - Y_i_b_m[i, b, m]) >= 0)
                model.addConstr(E_b_m[b, m] - e_i_m[i][m] * t_b_m[b, m] + M * (1 - Y_i_b_m[i, b, m]) >= 0)

    for b in range(No):
        model.addConstr(S_b_m[b, 1] - S_b_m[b, 0] - t_b_m[b, 0] >= 0)

    for b in range(1, No):
        for m in range(2):
            model.addConstr(S_b_m[b, m] - S_b_m[b - 1, m] - t_b_m[b - 1, m] >= 0)

    # obj-constrant
    model.addConstr(quicksum(E_b_m[b, m] for m in range(2) for b in range(No)) <= basedTEC)

    ## Single-Obj
    model.setObjective(S_b_m[No-1,1]+P_b_m[No-1,1], GRB.MINIMIZE)
    # model.setObjective(quicksum(E_b_m[b, m] for m in range(2) for b in range(No)), GRB.MINIMIZE)

    ## Compile
    model.Params.timeLimit = timeLimitiation ## running time
    model.update()
    model.optimize()
    # model.write(ModelName + '.lp')

    Status = 'Optimal1' if model.Status == 2 else model.Status
    TEC = sum([var.x for var in model.getVars() if "E_b_m" in var.VarName])
    C_max = model.ObjVal


    return TEC, C_max, model.Runtime, Status, model.MIPGap

if __name__=='__main__':
    timeLimitation = 720 # seconds
    fileNames = ['J10 S4 P20', 'J20 S4 P20', 'J50 S4 P20', 'J120 S4 P20', 'J300 S4 P20']
    TECs = [114, 263, 604, 1606, 4314]

    Results = pd.DataFrame()
    for i, (fileName, TEC0) in enumerate(zip(fileNames, TECs)):
        if i >= 4:
            # loading
            Jobs = loadmat('./Instance\/' + fileName + '.mat')['Instance']
            Jobs = pd.DataFrame(Jobs, index=['No', 'Size', 'PT1', 'PT2'])
            for rate in range(11, 22, 1):
                print(rate)
                # run model
                basedTEC = rate/10 * TEC0
                print(basedTEC)
                TEC, C_max, Rtime, Status, Gaps = GModel(Jobs, fileName, timeLimitation, basedTEC)
                Results.loc[str(rate/10), 'TEC'] = TEC
                Results.loc[str(rate/10), 'C_max'] = C_max
                Results.loc[str(rate/10), 'Rtime'] = Rtime
                Results.loc[str(rate/10), 'Status'] = Status
                Results.loc[str(rate/10), 'Gaps'] = Gaps
                # write to file
                Results.to_csv('Leveled_' + str(fileName) + '.csv')