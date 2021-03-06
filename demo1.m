
clc
clear all;
close all;
%% Load the Parameters of the Stereo Camera
% Load the |stereoParameters| object, which is the result of calibrating

% Load the stereoParameters object.
load('handshakeStereoParams.mat');

% Visualize camera extrinsics.
 %showExtrinsics(stereoParams);

% Create Video File Readers and the Video Player
% Create System Objects for reading and displaying the video
videoFileLeft = 'handshake_left.avi';
videoFileRight = 'handshake_right.avi';

readerLeft = vision.VideoFileReader(videoFileLeft, 'VideoOutputDataType', 'uint8');
readerRight = vision.VideoFileReader(videoFileRight, 'VideoOutputDataType', 'uint8');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Read and Rectify Video Frames
%1st pointCloud
frameLeft = readerLeft.step();
frameRight = readerRight.step();
[ptCloudRef,disparityMap]=stereo_to_ply(frameLeft,frameRight,stereoParams);
figure;
subplot(121)
imshow(ptCloudRef.Color);
subplot(122);
imshow(disparityMap, [0, 64]);
title('Disparity Map');
colormap jet
colorbar

% Create a streaming point cloud viewer
player3D = pcplayer([-3, 3], [-3, 3], [0, 8], 'VerticalAxis', 'y', ...
    'VerticalAxisDir', 'down');

% Visualize the point cloud
view(player3D, ptCloudRef);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 2nd PointCloud

frameLeft = readerLeft.step();
frameRight = readerRight.step();

[ptCloudCurrent,disparityMap]=stereo_to_ply(frameLeft,frameRight,stereoParams);
figure;

subplot(121);
imshow(ptCloudRef.Color);
subplot(122);
imshow(disparityMap, [0, 64]);
title('Disparity Map');
colormap jet;
colorbar;


% Create a streaming point cloud viewer
player1_3D = pcplayer([-3, 3], [-3, 3], [0, 8], 'VerticalAxis', 'y', ...
    'VerticalAxisDir', 'down');

% Visualize the point cloud
view(player1_3D, ptCloudCurrent);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
 gridSize = 0.1;
 fixed = pcdownsample(ptCloudRef, 'gridAverage', gridSize);
 moving = pcdownsample(ptCloudCurrent, 'gridAverage', gridSize);

% Note that the downsampling step does not only speed up the registration,
% but can also improve the accuracy.



tform = pcregrigid(moving, fixed, 'Metric','pointToPlane','Extrapolate', true);
ptCloudAligned = pctransform(ptCloudCurrent,tform);



mergeSize = 0.015;
ptCloudScene = pcmerge(ptCloudRef, ptCloudAligned, mergeSize);

% Visualize the input images.
figure
subplot(1,2,1)
imshow(ptCloudRef.Color)
title('First input image')
drawnow

subplot(1,2,2)
imshow(ptCloudCurrent.Color)
title('Second input image')
drawnow

player3_3D = pcplayer([-3, 3], [-3, 3], [0, 8], 'VerticalAxis', 'y', ...
    'VerticalAxisDir', 'down');

% Visualize the point cloud
view(player3_3D, ptCloudScene);
title('Final PointCloud');
figure;
pcshowpair(ptCloudRef,ptCloudCurrent);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Clean up.
reset(readerLeft);
reset(readerRight);



