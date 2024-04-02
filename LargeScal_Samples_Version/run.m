close all; clear all; clc
warning off;

dataPath = 'Datasets/Multi_view-Datasets/';
datasetName = {'Caltech101-20', 'EMNIST', 'YouTubeFace10_4Views', 'Hdigit','VGGFace2_100_4Views'};

MaxResSavePath = 'Demo_Anchor/maxRes/';

if(~exist(MaxResSavePath,'file'))
    mkdir(MaxResSavePath);
    addpath(genpath(MaxResSavePath));
end

for dataIndex = 1
    dataName = [dataPath datasetName{dataIndex} '.mat'];
    load(dataName);
    numClust = length(unique(gt));
    
    [fea] = NormalizeData(fea);

    
    ResBest = zeros(1, 8);
    ResStd = zeros(1, 8);
    
    % parameters setting
    r1 = [0.01, 0.05, 0.1, 0.5, 1];
    r2 = [0.01, 0.05, 0.1, 0.5, 1];
    [anc_idx,anc_allidx] = ancidx_generate(fea,gt);
    
    idx = 1;
    for r3Index = 1 : length(anc_idx)
        r3Temp = r3Index;
        for r1Index = 1 : length(r1)
            r1Temp = r1(r1Index);
            for r2Index = 1 : length(r2)
                r2Temp = r2(r2Index);
                fprintf('Please wait a few minutes\n');
                disp(['Dataset: ', datasetName{dataIndex}, ...
                    ', --r1--: ', num2str(r1Temp), ', --r2--: ', num2str(r2Temp),', --r3--: ', num2str(r3Temp)]);
                tic;
                [res, Y, Hstar,obj] = main(fea, numClust, gt, r1Temp, r2Temp, r3Temp, anc_idx, anc_allidx);
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
    end
    aRuntime = mean(Runtime);
    resFile = [MaxResSavePath datasetName{dataIndex}, '.mat'];
    save(resFile, 'ResBest', 'ResStd', 'aRuntime');
end
