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

%% CN_MODEL
trainCN = gdpCN(1:16,2:7);
diff1CN=diff(trainCN,1);
diff2CN=diff(trainCN,2);
diff3CN=diff(trainCN,3);
diff4CN=diff(trainCN,4);
figure(1);
subplot(2,2,1);
stackedplot(diff1CN);
subplot(2,2,2);
stackedplot(diff2CN);
subplot(2,2,3);
stackedplot(diff3CN);
subplot(2,2,4);
stackedplot(diff4CN);

subplot(2,2,1)
title('diff1')
xlabel('t')
subplot(2,2,2)
title('diff2')
xlabel('t')
subplot(2,2,3)
title('diff3')
xlabel('t')
subplot(2,2,4)
title('diff4')
xlabel('t')
%取阶数为1，认为CN组同分布，取CN1做自相关和偏相关检验
figure(2)
autocorr(diff1CN(:,1));
figure(3)
parcorr(diff1CN(:,1));
modelcn=arima(1,7,0);
test(modelcn,trainCN(:,1));

%% US_MODEL
trainUSA= table2array(gdpUSA(1:16,2));
diff1USA=diff(trainUSA,1);
diff2USA=diff(trainUSA,2);
diff3USA=diff(trainUSA,3);
diff4USA=diff(trainUSA,4);
figure(5);
subplot(2,2,1);
plot(diff1USA);
title("diff1");
xlabel('t');
subplot(2,2,2);
plot(diff2USA);
title("diff2");
xlabel('t');
subplot(2,2,3);
plot(diff3USA);
title("diff3");
xlabel('t');
subplot(2,2,4);
plot(diff4USA);
title("diff4");
xlabel('t');
%取阶数为2，做自相关和偏相关检验
figure(6)
autocorr(diff2USA(:,1));
figure(7)
parcorr(diff2USA(:,1));
modelUSA=arima(2,12,1);
test(modelUSA,trainUSA(:,1));

%% JAP_MODEL
trainJAP= table2array(gdpJAP(1:16,2));
diff1JAP=diff(trainJAP,1);
diff2JAP=diff(trainJAP,2);
diff3JAP=diff(trainJAP,3);
diff4JAP=diff(trainJAP,4);
figure(9);
subplot(2,2,1);
plot(diff1JAP);
title("diff1");
xlabel('t');
subplot(2,2,2);
plot(diff2JAP);
title("diff2");
xlabel('t');
subplot(2,2,3);
plot(diff3JAP);
title("diff3");
xlabel('t');
subplot(2,2,4);
plot(diff4JAP);
title("diff4");
xlabel('t');
%取阶数为1，做自相关和偏相关检验
figure(10)
autocorr(diff1JAP(:,1));
figure(11)
parcorr(diff1JAP(:,1));
modelJAP=arima(2,5,1);
test(modelJAP,trainJAP(:,1));

%% PROC_FORCAST
% cn
cnest=[];
cnf=[];
cnymse=[];
for i=1:6
    cnest=estimate(modelcn,trainCN(:,i));
    [cnf(:,i),cnymse(:,i)]=fcdata(cnest,4,trainCN(:,i));
end
% us
usest=estimate(modelUSA,trainUSA);
usf=forecast(usest,4,trainUSA);
% jp
jpest=estimate(modelJAP,trainJAP);
jpf=forecast(jpest,4,trainJAP);
% data_write
fcoutput=table(cnf,usf,jpf);
fcoutput = splitvars(fcoutput, 'cnf');
fcoutput.Properties.VariableNames={'Tianjin','Beijing','Shanghai','Chongqing','Hangzhou','Chengdu','US','Japan'};
writetable("../output/forcast.csv",fcoutput);

%% PROC_ETA
