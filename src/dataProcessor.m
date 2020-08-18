function data = dataProcessor(filePath)
    %dataProcesspr - Description
    %
    % Syntax: data = dataProcessor(filePath)
    %
    % Long description
    % enter the data's path and should return a dataset formated as a '.mat' file.
    % - filepath : path of file.
    % - data: should return to __main__() function a table named by 'data'.
    fprintf('GENERATING REQUIRED DATA...\n');
    opts = detectImportOptions(filePath);
    opts.Encoding = 'UTF-8';
    opts.PreserveVariableNames = true;
    tempdata = readtable(filePath, opts);
    [y, x]size(tempdata);

    data = [];

    for i = 2:x

        if isnan(tempdata(i, 1))
            sumNum = sum(tempdata(i, y - 3:));
            prox1 = tempdata(i, y - 3) / sumNum;
            prox2 = tempdata(i, y - 2) / sumNum;
            prox3 = tempdata(i, y - 1) / sumNum;
            prox4 = tempdata(i, y) / sumNum;

            for j = 1:y

                for l = 1:4
                    randNoise = 0.1 * randn;

                    if l == 1
                        data(j, i) = tempdata(j + 3, i) * prox1 * (1 + randNoise);
                    elseif l == 2
                        data(j, i) = tempdata(j + 2, i) * prox2 * (1 + randNoise);
                    elseif l == 3
                        data(j, i) = tempdata(j + 1, i) * prox3 * (1 + randNoise);
                    else
                        data(j, i) = tempdata(j, i) * prox4 * (1 + randNoise);
                    end

                end

            end

        else

            for j = 1:y
                k = 4;

                for k = 1:4

                    if k == 1
                        data(j, i) = tempdata(j, i);
                    else
                        data(j, i) = tempdata(j, i) - data(j - 1, i);

                    end

                end

            end

        end

    end
