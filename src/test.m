function test(model,data)
%UNTITLED 此处显示有关此函数的摘要
EstMdl = estimate(model,data);
[res,~,logL] = infer(EstMdl,data); 
stdr = res/sqrt(EstMdl.Variance);
figure('Name','残差检验')
subplot(2,3,1)
plot(stdr)
title('Standardized Residuals')
subplot(2,3,2)
histogram(stdr,10)
title('Standardized Residuals')
subplot(2,3,3)
autocorr(stdr)
subplot(2,3,4)
parcorr(stdr)
subplot(2,3,5)
qqplot(stdr)
end

