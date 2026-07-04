%% REHABRIGHT - PART 2: ACCURACY CHECK
%  Run this AFTER Part 1 finishes.
%  Tip: type "clear all" before running this to free up memory.

clear all;

%% Load the saved network
load('myNet.mat', 'myNet');

%% Load the images again
imds = imageDatastore('Scenario 1', ...
    'IncludeSubfolders', true, ...
    'LabelSource', 'foldernames');

[~, imdsVal] = splitEachLabel(imds, 0.7, 'randomized');

%% Classify and check accuracy
inputSize = [224 224];
augimdsVal = augmentedImageDatastore(inputSize, imdsVal);

preds = classify(myNet, augimdsVal);
accuracy = mean(preds == imdsVal.Labels);
fprintf('Validation Accuracy: %.1f%%\n', accuracy * 100);

%% Confusion Chart
figure;
confusionchart(imdsVal.Labels, preds);
title('RehabRight - Validation Results');