function YPred = lstmforecast(data)
% 基于LSTM网络的数值预测函数
%% 选取训练集和测试集
numTimeStepsTrain = floor(0.9*numel(data));

dataTrain = data(1:numTimeStepsTrain+1);
dataTest = data(numTimeStepsTrain+1:end);
%% 标准化
mu = mean(dataTrain);
sig = std(dataTrain);

dataTrainStandardized = (dataTrain - mu) / sig;
%% 预测变量和响应
XTrain = dataTrainStandardized(1:end-1);
YTrain = dataTrainStandardized(2:end);
%% 定义LSTM网络
numFeatures = 1;
numResponses = 1;
numHiddenUnits = 500;

layers = [ ...
    sequenceInputLayer(numFeatures)
    lstmLayer(numHiddenUnits)
    fullyConnectedLayer(numResponses)
    regressionLayer];

options = trainingOptions('adam', ...
    'MaxEpochs',500, ...
    'GradientThreshold',1, ...
    'InitialLearnRate',0.005, ...
    'LearnRateSchedule','piecewise', ...
    'LearnRateDropPeriod',200, ...
    'LearnRateDropFactor',0.2, ...
    'Verbose',0, ...
    'Plots','training-progress');
%% 训练LSTM网络
net = trainNetwork(XTrain,YTrain,layers,options);
%% 预测时间步
dataTestStandardized = (dataTest - mu) / sig;
XTest = dataTestStandardized(1:end-1);
% 预测
net = predictAndUpdateState(net,XTrain);
[net,YPred] = predictAndUpdateState(net,YTrain(end));
numTimeStepsTest = numel(XTest);
for i = 2:numTimeStepsTest+4
    [net,YPred(:,i)] = predictAndUpdateState(net,YPred(:,i-1),'ExecutionEnvironment','cpu');
end

% 取标准化
YPred = sig.*YPred + mu;
% 误差检验与均方根误差计算
YTest = dataTest(2:end);
rmse = sqrt(mean((YPred-YTest).^2));
%% 预测可视化
figure
plot(dataTrain(1:end-1))
hold on
idx = numTimeStepsTrain:(numTimeStepsTrain+numTimeStepsTest);
plot(idx,[data(numTimeStepsTrain) YPred],'.-')
hold off
xlabel("Quater");
ylabel("GDP");
title("Forecast");
legend("Observed","Forecast");
%% 与元数据进行比较
figure
subplot(2,1,1)
plot(YTest)
hold on
plot(YPred,'.-')
hold off
xlabel("Quater");
ylabel("GDP");
title("Forecast");
legend("Observed","Forecast");

subplot(2,1,2)
stem(YPred - YTest)
xlabel("Quater")
ylabel("Error")
title("RMSE = " + rmse)
end

