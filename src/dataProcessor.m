function data = dataProcessor(filePath)
%dataProcesspr - Description
%
% Syntax: data = dataProcessor(filePath)
%
% Long description
% enter the data's path and should return a dataset formated as a '.mat' file.
% - filepath : path of file.
% - data: should return to __main__() function a table named by 'data'.
filePath="./data/gdpCN.csv";
fprintf('GENERATING REQUIRED DATA...\n');
opts = detectImportOptions(filePath);
opts.Encoding = 'UTF-8';
opts.PreserveVariableNames = true;
tempdata = readtable(filePath, opts);
[y, x] = size(tempdata);
tempdata = table2array(tempdata);
data = [];
for i = 2:x
    
    if isnan(tempdata(1,i))
        sumNum = sum(tempdata((y - 3):y,i));
        prox1 = tempdata(y - 3,i) ./ sumNum;
        prox2 = tempdata(y - 2,i) ./ sumNum;
        prox3 = tempdata(y - 1,i) ./ sumNum;
        prox4 = tempdata(y,i) ./ sumNum;
        
        for j = 1:y
            
            l=rem(j,4);
            randNoise = 0.1 .* randn;
            
            if l == 1
                data(j, i) = tempdata(j + 3, i) .* prox1 .* (1 + randNoise);
            elseif l == 2
                data(j, i) = tempdata(j + 2, i) .* prox2 .* (1 + randNoise);
            elseif l == 3
                data(j, i) = tempdata(j + 1, i) .* prox3 .* (1 + randNoise);
            else
                data(j, i) = tempdata(j, i) .* prox4 .* (1 + randNoise);
            end
            
        end
        
    else
        
        for j = 1:y
            
            k=rem(j,4);
            
            if k == 1
                data(j, i) = tempdata(j, i);
            else
                data(j, i) = tempdata(j, i) - tempdata(j - 1, i);
                
            end
            
        end
        
    end
    
end
fprintf("DONE!\n");
end