clc
clear all
close all
%% Read images and stereo parameters from stored images
load logitech_stereo.mat
path_left ='C:\Users\ashishHP\Desktop\test1\16-Jan-2017\3\Left\*.tiff';
path_right = 'C:\Users\ashishHP\Desktop\test1\16-Jan-2017\3\Right\*tiff';
srcFiles_left= dir(path_left);
srcFiles_right= dir(path_right);

frameLeft = strcat('C:\Users\ashishHP\Desktop\test1\16-Jan-2017\3\Left\',srcFiles_left(1).name);
frameRight = strcat('C:\Users\ashishHP\Desktop\test1\16-Jan-2017\3\Right\',srcFiles_right(1).name);
frameLeft=imread(frameLeft);
frameRight=imread(frameRight);

figure;
subplot(421);
imshow(frameLeft);
title('Left View-1');
subplot(422);
imshow(frameRight);
title('Right View-1')

%%
% Read and Rectify Video Frames
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%1st pointCloud

[ptCloudRef,disparityMap]=stereo_to_ply(frameLeft,frameRight,stereoParams);
subplot(423)
imshow(disparityMap);
title('Disparity Map');
colormap jet
colorbar

% Create a streaming point cloud viewer
%player3D = pcplayer([-3, 3], [-3, 3], [0, 8], 'VerticalAxis', 'y', ...
 %   'VerticalAxisDir', 'down');

% Visualize the point cloud
%view(player3D, ptCloudRef);
subplot(424)
pcshow(ptCloudRef);

%% 2nd PointCloud

frameLeft = strcat('C:\Users\ashishHP\Desktop\test1\16-Jan-2017\3\Left\',srcFiles_left(2).name);
frameRight = strcat('C:\Users\ashishHP\Desktop\test1\16-Jan-2017\3\Right\',srcFiles_right(2).name);
frameLeft=imread(frameLeft);
frameRight=imread(frameRight);

figure;
subplot(421);
imshow(frameLeft);
title('Left View-2');
subplot(422);
imshow(frameRight);
title('Right View-2')



[ptCloudCurrent,disparityMap]=stereo_to_ply(frameLeft,frameRight,stereoParams);
subplot(423)
imshow(disparityMap);
title('Disparity Map');
colormap jet
colorbar


% Create a streaming point cloud viewer
% player1_3D = pcplayer([-3, 3], [-3, 3], [0, 8], 'VerticalAxis', 'y', ...
%     'VerticalAxisDir', 'down');

% Visualize the point cloud
% view(player1_3D, ptCloudCurrent);
subplot(424)
pcshow(ptCloudCurrent)
%%stichting
 gridSize = 0.1;
 fixed = pcdownsample(ptCloudRef, 'gridAverage', gridSize);
 moving = pcdownsample(ptCloudCurrent, 'gridAverage', gridSize);

% Note that the downsampling step does not only speed up the registration,
% but can also improve the accuracy.
tform = pcregrigid(moving, fixed, 'Metric','pointToPlane','Extrapolate', true);
ptCloudAligned = pctransform(ptCloudCurrent,tform);

mergeSize = 0.015;
ptCloudScene = pcmerge(ptCloudRef, ptCloudAligned, mergeSize);
figure
pcshow(ptCloudScene)
title('Combined PointCloud')


% Store the transformation object that accumulates the transformation.
accumTform = tform; 
count=2;
total_frames =length(srcFiles_left);
figure;
%% process rest of the frames
for i=3:10
    count=count+1;
    disp(count);
frameLeft = strcat('C:\Users\ashishHP\Desktop\test1\16-Jan-2017\3\Left\',srcFiles_left(i).name);
frameRight = strcat('C:\Users\ashishHP\Desktop\test1\16-Jan-2017\3\Right\',srcFiles_right(i).name);
frameLeft=imread(frameLeft);
frameRight=imread(frameRight);



 
 [ptCloudCurrent,disparityMap]=stereo_to_ply(frameLeft,frameRight,stereoParams); 
%     subplot(121)
%     imshow(ptCloudCurrent.Color)
%     title('YOLO')
%     drawnow;
%     subplot(122);
%     imshow(disparityMap, [0, 64]);
%     title('Disparity Map');
%     colormap jet
%     colorbar

    fixed = moving;
    moving = pcdownsample(ptCloudCurrent, 'gridAverage', gridSize);
    
    % Apply ICP registration.
    tform = pcregrigid(moving, fixed, 'Metric','pointToPlane','Extrapolate', true);

    % Transform the current point cloud to the reference coordinate system
    % defined by the first point cloud.
    accumTform = affine3d(tform.T * accumTform.T);
    ptCloudAligned = pctransform(ptCloudCurrent, accumTform);
    
    % Update the world scene.
    ptCloudScene = pcmerge(ptCloudScene, ptCloudAligned, mergeSize);

    
% Visualize the point cloud
pcshow(ptCloudScene);
 title('Combined pointCloud-%s',count)
end














