function varargout = capture_GUI2(varargin)
% CAPTURE_GUI2 MATLAB code for capture_GUI2.fig
%      CAPTURE_GUI2, by itself, creates a new CAPTURE_GUI2 or raises the existing
%      singleton*.
%
%      H = CAPTURE_GUI2 returns the handle to a new CAPTURE_GUI2 or the handle to
%      the existing singleton*.
%
%      CAPTURE_GUI2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CAPTURE_GUI2.M with the given input arguments.
%
%      CAPTURE_GUI2('Property','Value',...) creates a new CAPTURE_GUI2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before capture_GUI2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to capture_GUI2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help capture_GUI2

% Last Modified by GUIDE v2.5 03-Jan-2017 13:27:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @capture_GUI2_OpeningFcn, ...
                   'gui_OutputFcn',  @capture_GUI2_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before capture_GUI2 is made visible.
function capture_GUI2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to capture_GUI2 (see VARARGIN)

% Choose default command line output for capture_GUI2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes capture_GUI2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = capture_GUI2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
set(handles.start,'string','START'); 
imaqreset
path = 'C:\Users\ashishHP\Desktop\test1';
set(handles.start,'string','START'); 
global vid1 vid2 path_left path_right k format_a max_left max_right
 k=0;
 [path_left,path_right] = date_folder(path); 
 format_a = 'F7_YUV422_320x240_Mode5';
  %format_a = 'MJPG_640x480';
 
 
 max_left=0;
 max_right=0;
 
%   vid1 = videoinput('winvideo', 3, format_a); % Left
  vid1 = videoinput('pointgrey', 1, format_a); % Left
%   src = getselectedsource(vid1);
% Set camera parameters
% src.ExposureMode = 'Manual';
% src.Exposure = 1.8;

  set(vid1,'ReturnedColorSpace','rgb');
    set(vid1,'FramesPerTrigger',1);
    set(vid1,'TriggerRepeat',inf);
    triggerconfig(vid1,'manual'); 
    start(vid1);
%vid2 = videoinput('winvideo', 4, format_a); % Right
 vid2 = videoinput('pointgrey', 2, format_a); % Left

    set(vid2,'ReturnedColorSpace','rgb');
    set(vid2,'FramesPerTrigger',1);
    set(vid2,'TriggerRepeat',inf);
    triggerconfig(vid2,'manual'); 
    start(vid2);
% src = getselectedsource(vid2);
% 
% % Set camera parameters
% src.ExposureMode = 'Manual';
% src.Exposure = 1.8;
    pause(2);


% --- Executes on button press in capture.
function capture_Callback(hObject, eventdata, handles)
% hObject    handle to capture (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im1 im2 flag1 path_left path_right k 

flag1 = 2;
axes(handles.axes1);% to show left camera image
imshow(im1);
axes(handles.axes2);% to show right camera image
imshow(im2);
k = k + 1;
a = k ;
set(handles.count,'string',num2str(a));
fn1 = sprintf('cam--1-%d.tiff', a); % Left
fn2 = sprintf('cam--0-%d.tiff', a); % Right
file1 = fullfile(path_left,fn1);
file2 = fullfile(path_right,fn2);
imwrite(im1, file1); 
imwrite(im2, file2);





% --- Executes on button press in start.
function start_Callback(hObject, eventdata, handles)
% hObject    handle to start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.start,'string','RESTART');

global vid1 vid2 flag1 im1 im2 max_left max_right


flag1=1;
while(flag1==1)
    trigger(vid1);%trigger for left camera
    im1=getdata(vid1);
    im1= fliplr(im1);
    [focus_left,max_left]= my_in_focus(im1,max_left);
    set(handles.current_val_l,'string',num2str(focus_left));
    set(handles.high_val_l,'string',num2str(max_left));
     axes(handles.axes1);
    imshow(im1);
    %trigger for right camera
    trigger(vid2);
    im2=getdata(vid2);
    im2= fliplr(im2);
%     [focus_right,max_right]= my_in_focus(im2,current_max2);
%     set(handles.current_right,'string',num2str(focus_right));
%     set(handles.high_right,'string',num2str(max_right));
    [focus_right,max_right]= my_in_focus(im2,max_right);
    set(handles.current_val_r,'string',num2str(focus_right));
    set(handles.high_val_r,'string',num2str(max_right));
    axes(handles.axes2);
    imshow(im2);
end























