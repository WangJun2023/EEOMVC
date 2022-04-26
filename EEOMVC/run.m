close all; clear all; clc
warning off;
addpath(genpath('ClusteringMeasure'));
addpath(genpath('utils'));
MaxResSavePath = 'maxRes/';

if(~exist(MaxResSavePath,'file'))
    mkdir(MaxResSavePath);
    addpath(genpath(MaxResSavePath));
end

dataPath = 'datasets/';
datasetName = {'CiteSeer', 'ALOI_100', 'scene-15_3v','Caltech101_4deep','Cifar10_test_4deep'};

for dataIndex = 1
    dataName = [dataPath datasetName{dataIndex} '.mat'];
    load(dataName);
    numClust = length(unique(gt));
    fea = NormalizeData(fea);
    
    ResBest = zeros(1, 8);
    ResStd = zeros(1, 8);
    
    % parameters setting
    r1 = [0.01, 0.05, 0.1, 0.5, 1];
    r2 = [0.01, 0.05, 0.1, 0.5, 1];
    [anc_idx, anc_allidx] = generate_anchor(fea,gt);
    
    for r3Index = 1 : length(anc_idx)
        r3Temp = r3Index;
        for r1Index = 1 : length(r1)
            r1Temp = r1(r1Index);
            for r2Index = 1 : length(r2)
                r2Temp = r2(r2Index);
                disp(['Dataset: ', datasetName{dataIndex}, ...
                    ', --r1--: ', num2str(r1Temp), ', --r2--: ', num2str(r2Temp),', --r3--: ', num2str(r3Temp)]);
                [res, Y, Hstar,obj] = EEOMVC_main(fea, numClust, gt, r1Temp, r2Temp, r3Temp, anc_idx, anc_allidx);
                tempResBest(1, : ) = res(1, : );
                acc(r1Index, r2Index, r3Index) = tempResBest(1, 7);
                nmi(r1Index, r2Index, r3Index) = tempResBest(1, 4);
                purity(r1Index, r2Index, r3Index) = tempResBest(1, 8);
            end
        end
        % The maximum values for each group of anchors in terms of acc, nmi, and purity
        ACC(r3Index) = max(max(acc));
        NMI(r3Index) = max(max(nmi));
        Purity(r3Index) = max(max(purity));
    end
    resFile = [MaxResSavePath datasetName{dataIndex}, '.mat'];
    save(resFile, 'ACC', 'NMI', 'Purity');
end