close all; clear all; clc
warning off;

dataPath = 'Datasets/';
datasetName = {'MSRC_v1', 'HW', '100leaves_3v'};
metricName = {'squaredeuclidean', 'squaredeuclidean', 'squaredeuclidean'};

MaxResSavePath = 'maxRes/';
if(~exist(MaxResSavePath,'file'))
    mkdir(MaxResSavePath);
    addpath(genpath(MaxResSavePath));
end

for dataIndex = 1
    dataName = [dataPath datasetName{dataIndex} '.mat'];
    metric = metricName{dataIndex};
    load(dataName);
    numClust = length(unique(gt));
    knn0 = 15;
    [fea] = NormalizeData(fea);
    
    ResBest = zeros(1, 8);
    ResStd = zeros(1, 8);
    
    % parameters setting
    r1 = [0.01, 0.05, 0.1, 0.5, 1];
    r2 = [0.01, 0.05, 0.1, 0.5, 1];

    idx = 1;
    for r1Index = 1 : length(r1)
        r1Temp = r1(r1Index);
        for r2Index = 1 : length(r2)
            r2Temp = r2(r2Index);
            % Main algorithm
            fprintf('Please wait a few minutes\n');
            disp(['Dataset: ', datasetName{dataIndex}, ...
                ', --r1--: ', num2str(r1Temp), ', --r2--: ', num2str(r2Temp)]);
            tic;
            [res,Y,Hstar,obj] = main(fea, numClust, knn0, metric, gt, r1Temp, r2Temp);
            Runtime(idx) = toc;
            
            fprintf('ACC=%8.6f \tNMI=%8.6f \tF1=%8.6f \tTime:%8.6f \n',[res(1, 7) res(1, 4) res(1, 1) Runtime(idx)]);
            idx = idx + 1;
            tempResBest(1, : ) = res(1, : );
            tempResStd(1, : ) = res(2, : );

            if tempResBest(1, 7) > ResBest(1, 7)
                    ResBest(1, :) = tempResBest(1,:);
                    ResStd(1, :) = tempResStd(1, :);
            end
        end
    end
    aRuntime = mean(Runtime);
    resFile = [MaxResSavePath datasetName{dataIndex}, '.mat'];
    save(resFile, 'ResBest', 'ResStd', 'aRuntime');
end
