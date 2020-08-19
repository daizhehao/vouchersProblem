% DATA
gdpCN=dataProcessor("./data/gdpCN.csv");
opts = detectImportOptions("./data/gdpUSA.csv");
opts.Encoding = 'UTF-8';
opts.PreserveVariableNames = true;
gdpUSA = readtable("./data/gdpUSA.csv", opts);
opts = detectImportOptions("./data/gdpJAP.csv");
opts.Encoding = 'UTF-8';
opts.PreserveVariableNames = true;
gdpJAP = readtable("./data/gdpJAP.csv");

%
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


trainUSA= table2array(gdpUSA(1:16,2));
diff1USA=diff(trainUSA,1);
diff2USA=diff(trainUSA,2);
diff3USA=diff(trainUSA,3);
diff4USA=diff(trainUSA,4);
figure(1);
subplot(2,2,1);
plot(diff1USA);
subplot(2,2,2);
plot(diff2USA);
subplot(2,2,3);
plot(diff3USA);
subplot(2,2,4);
plot(diff4USA);
%取阶数为2，做自相关和偏相关检验
figure(2)
autocorr(diff1USA(:,1));
figure(3)
parcorr(diff1USA(:,1));
modelUSA=arima(2,12,1);
test(modelUSA,trainUSA(:,1));