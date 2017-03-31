function varargout = ClassificationGUI(varargin)
% CLASSIFICATIONGUI MATLAB code for ClassificationGUI.fig
%      CLASSIFICATIONGUI, by itself, creates a new CLASSIFICATIONGUI or raises the existing
%      singleton*.
%
%      H = CLASSIFICATIONGUI returns the handle to a new CLASSIFICATIONGUI or the handle to
%      the existing singleton*.
%
%      CLASSIFICATIONGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CLASSIFICATIONGUI.M with the given input arguments.
%
%      CLASSIFICATIONGUI('Property','Value',...) creates a new CLASSIFICATIONGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ClassificationGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ClassificationGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ClassificationGUI

% Last Modified by GUIDE v2.5 02-Dec-2016 13:23:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @ClassificationGUI_OpeningFcn, ...
    'gui_OutputFcn',  @ClassificationGUI_OutputFcn, ...
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


% --- Executes just before ClassificationGUI is made visible.
function ClassificationGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ClassificationGUI (see VARARGIN)

% Choose default command line output for ClassificationGUI
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ClassificationGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ClassificationGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double
global videoInputDirectory;
videoInputDirectory = get(hObject, 'String');


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName] = uigetfile('*.*','Select the video file');
handles.videoInputDirectory = [PathName FileName];
set(handles.edit2,'string',handles.videoInputDirectory);


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Have to run this for vl functions to work.

run('../../vlfeat-0.9.20-bin/vlfeat-0.9.20-bin/vlfeat-0.9.20/toolbox/vl_setup')

%Training Image Database folder
train_data_path = '../../Data/TrainImages/';

train_path_np = fullfile(train_data_path, 'NoParking');
train_path_stop = fullfile(train_data_path, 'Stop');
train_path_negative = fullfile(train_data_path, 'Negative');

% Feature pararmeters for HoG
feature_params = struct('template_size', 36, 'hog_cell_size', 6);


%% Step 1. Load positive training crops and random negative examples

if ~exist('features_np.mat', 'file')
    fprintf('No existing NoParking features found. Computing one from training images\n')
    features_np = get_features( train_path_np, feature_params );
    save('features_np.mat', 'features_np')
else
    fprintf('features_np found\n')
    load('features_np.mat')
end

if ~exist('features_stop.mat', 'file')
    fprintf('No existing features_stop found. Computing one from training images\n')
    features_stop = get_features( train_path_stop, feature_params );
    save('features_stop.mat', 'features_stop')
else
    fprintf('features_stop found\n')
    load('features_stop.mat')
end

if ~exist('features_neg.mat', 'file')
    fprintf('No existing features_neg found. Computing one from training images\n')
    features_neg = get_features( train_path_negative, feature_params);
    save('features_neg.mat', 'features_neg')
else
    fprintf('features_neg found\n')
    load('features_neg.mat')
end

%% step 2. Train Classifier
%YOU CODE classifier training. Make sure the outputs are 'w' and 'b'.
numNPFeatures = size(features_np,1);
numStopFeatures = size(features_stop,1);
numNegFeatures = size(features_neg,1);
lambda = 0.00001;

% For No-Parking
y1 = ones(numNPFeatures,1);
y2 = -1*ones(numNegFeatures,1);
Y = [y1;y2];
X = [features_np', features_neg'];
[w, b] = vl_svmtrain(X, Y, lambda);

% For stop
y11 = ones(numStopFeatures,1);
y21 = -1*ones(numNegFeatures,1);
Y1 = [y11;y21];
X1 = [features_stop', features_neg'];
[w1, b1] = vl_svmtrain(X1, Y1, lambda);

%% Step 5. Run detector on test set.
readerobj = VideoReader(handles.edit2.String);
input = handles.edit3.String;
videoWriterObj = VideoWriter(input);
space = 'rgb';
thresh = 0.67;
open(videoWriterObj);

tic
lengthOfVideo = readerobj.Duration;
h = waitbar(0,'Please wait...');

while hasFrame(readerobj)
    percentage_completed = readerobj.CurrentTime/lengthOfVideo;
    waitbar(percentage_completed)
    guidata(hObject, handles);
    
    image = readFrame(readerobj);
    image1 = image;
    out = blobAnalysis(image, space);
    % Restricting the circle radius between 10 and 100
    [center_old, radius_old] = imfindcircles(out, [10 100], 'Sensitivity', 0.93, 'Method', 'twostage');
    [center, radius] = mergeOverlappingCircles(center_old, radius_old);
    
    if(~isempty(center))
        offset = 3;
        
        % Running for all segments found by blob anaysis and imfindcircles
        for z = 1 : size(center, 1)
            % Draawing the bounding box for radius greater than 20
            x = center(z, 1)-offset;
            y = center(z, 2)-offset;
            width = radius(z)+(2*offset);
            
            if(width > 20 & width < 150)
                if((x-width > 0) && (y-width > 0) && (x+width < size(image, 2)) && (y+width < size(image, 1)))
                    rect =  [x-width y-width width*2 width*2];
                    test_image_segments = imcrop(image, rect);
                    [~, confidences, label] = run_detector(test_image_segments, w, b, feature_params, 'NoParking');
                    [~, confidences1, label1] = run_detector(test_image_segments, w1, b1, feature_params, 'Stop');
                    
                    if(isempty(confidences1) & confidences > thresh)
                        image1 = visualise(rect, confidences, image, label);
                    elseif(isempty(confidences) & confidences1 > thresh)
                        image1 = visualise(rect, confidences1, image, label1);
                    elseif (confidences1 <= confidences & confidences > thresh)
                        image1 = visualise(rect, confidences, image, label);
                    elseif(confidences1 > confidences & confidences1 > thresh)
                        image1 = visualise(rect, confidences1, image, label1);
                    end
                end
            end
        end
    end
    writeVideo(videoWriterObj,  image1);
end
toc
close(videoWriterObj);
close(h);
implay(handles.edit3.String);

function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double
global videoDestinationDirectory;
videoDestinationDirectory = get(hObject, 'String');


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName] = uiputfile('*.*','Select the video file');
filename = get(handles.edit2, 'String');
temp = strsplit(filename, '.');
filename = strcat(PathName,FileName, '.', temp{end});
handles.videoDestinationDirectory = filename;
set(handles.edit3,'string',handles.videoDestinationDirectory);



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double



% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
