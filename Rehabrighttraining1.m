%% REHABRIGHT - PART 1: TRAIN AND SAVE
%  First run:  trains from GoogLeNet (scratch)
%  Repeat runs: loads myNet.mat and continues training
%  After this finishes, close MATLAB and run Part 2.

%% Load Image Data
imds = imageDatastore('Scenario 1', ...
    'IncludeSubfolders', true, ...
    'LabelSource', 'foldernames');

countEachLabel(imds)

[imdsTrain, imdsVal] = splitEachLabel(imds, 0.7, 'randomized');

%% Load Network
if isfile('myNet.mat')
    % Continue training from saved network
    disp('Found myNet.mat - continuing training from saved network...');
    load('myNet.mat', 'myNet');
    lgraph = layerGraph(myNet);
else
    % First time - start from GoogLeNet
    disp('No saved network found - starting fresh from GoogLeNet...');
    net = googlenet;
    lgraph = layerGraph(net);

    numClasses = 4;

    newFC = fullyConnectedLayer(numClasses, ...
        'Name', 'new_fc', ...
        'WeightLearnRateFactor', 10, ...
        'BiasLearnRateFactor', 10);

    newClassOutput = classificationLayer('Name', 'new_output');

    lgraph = replaceLayer(lgraph, 'loss3-classifier', newFC);
    lgraph = replaceLayer(lgraph, 'output', newClassOutput);
end

%% Resize Images
inputSize = [224 224];
augimdsTrain = augmentedImageDatastore(inputSize, imdsTrain);

%% Training Options
options = trainingOptions('sgdm', ...
    'MiniBatchSize', 10, ...
    'MaxEpochs', 6, ...
    'InitialLearnRate', 1e-4, ...
    'Verbose', true, ...
    'Plots', 'training-progress');

%% Train and Save
myNet = trainNetwork(augimdsTrain, lgraph, options);
save('myNet.mat', 'myNet');
disp('--- DONE. Network saved. Now run Part 2. ---');