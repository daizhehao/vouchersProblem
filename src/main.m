close all;
clear;
clc;
%% DATA
gdpCN=dataProcessor("../data/gdpCN.csv");
opts = detectImportOptions("../data/gdpUSA.csv");
opts.Encoding = 'UTF-8';
opts.PreserveVariableNames = true;
gdpUSA = readtable("../data/gdpUSA.csv", opts);
opts = detectImportOptions("../data/gdpJAP.csv");
opts.Encoding = 'UTF-8';
opts.PreserveVariableNames = true;
gdpJAP = readtable("../data/gdpJAP.csv");
cntrain=dgpCN

%% PROC_ETA

