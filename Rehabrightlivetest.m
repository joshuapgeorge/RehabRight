%% REHABRIGHT - LIVE PHONE CAMERA TEST
%  Uses MATLAB Mobile smartphone camera.
%  Make sure MATLAB Mobile is running on your phone
%  and connected to the same MathWorks account.
%  3 second countdown, then 30 seconds of rep tracking.

clear all;
load('myNet.mat', 'myNet');

inputSize = [224 224];
duration = 30;

% Connect to phone camera
m = mobiledev;
cam = camera(m, 'back');

%% 3 Second Countdown
fig = figure('Name', 'RehabRight Live Test', 'NumberTitle', 'off', ...
    'Color', [0.21 0.10 0.33]);

for countdown = 3:-1:1
    img = snapshot(cam, 'immediate');
    imshow(img);
    title(sprintf('GET READY...  %d', countdown), ...
        'FontSize', 36, 'Color', 'yellow', 'FontWeight', 'bold');
    drawnow;
    pause(1);
end

% Flash "GO!"
img = snapshot(cam, 'immediate');
imshow(img);
title('GO!', 'FontSize', 48, 'Color', 'green', 'FontWeight', 'bold');
drawnow;
pause(0.5);

%% Live Classification with Rep Counting
label = "Waiting...";
confidence = 0;
frameCount = 0;
reps = 0;
stage = 0;  % 0=waiting for Palm, 1=got Palm waiting for Fist
startTime = tic;

while toc(startTime) < duration && ishandle(fig)
    frameCount = frameCount + 1;
    img = snapshot(cam, 'immediate');

    % Classify every frame at 4fps
    imgResized = imresize(img, inputSize);
    [label, score] = classify(myNet, imgResized);
    confidence = max(score) * 100;

    % Track reps: Palm -> Fist
    if stage == 0 && label == "Palm"
        stage = 1;
    elseif stage == 1 && label == "Fist"
        reps = reps + 1;
        stage = 0;
    end

    % Show frame
    imshow(img);
    timeLeft = round(duration - toc(startTime));
    title(sprintf('%s (%.1f%%)  |  Reps: %d  |  %ds left', ...
        string(label), confidence, reps, timeLeft), ...
        'FontSize', 18, 'Color', 'green', 'FontWeight', 'bold');
    drawnow;

    % Control speed to 4fps
    elapsed = toc(startTime) - (frameCount - 1) * (1/4);
    pause(max(0, (1/4) - elapsed));
end

%% Session Summary
if ishandle(fig)
    img = snapshot(cam, 'immediate');
    imshow(img);
    title(sprintf('SESSION COMPLETE  -  Total Reps: %d', reps), ...
        'FontSize', 24, 'Color', 'yellow', 'FontWeight', 'bold');
    drawnow;
end

clear('cam');
fprintf('\n=== Session Complete ===\n');
fprintf('Total Reps: %d\n', reps);
fprintf('Frames captured: %d\n', frameCount);
fprintf('Avg FPS: %.1f\n', frameCount / duration);
disp('Live test ended.');
