function varargout = FILE_convertMeasureGUI(varargin)
% FILE_CONVERTMEASUREGUI M-file for FILE_convertMeasureGUI.fig
%      FILE_CONVERTMEASUREGUI, by itself, creates a new FILE_CONVERTMEASUREGUI or raises the existing
%      singleton*.
%
%      H = FILE_CONVERTMEASUREGUI returns the handle to a new FILE_CONVERTMEASUREGUI or the handle to
%      the existing singleton*.
%
%      FILE_CONVERTMEASUREGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FILE_CONVERTMEASUREGUI.M with the given input arguments.
%
%      FILE_CONVERTMEASUREGUI('Property','Value',...) creates a new FILE_CONVERTMEASUREGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before FILE_convertMeasureGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to FILE_convertMeasureGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FILE_convertMeasureGUI

% Last Modified by GUIDE v2.5 11-Sep-2009 12:17:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FILE_convertMeasureGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @FILE_convertMeasureGUI_OutputFcn, ...
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


%My function
function measureTypeListBox_setBox(hObject, eventdata, handles) 

for n=1:length(handles.measureType)
    item{n}=handles.measureType(n);
end
set(handles.measureTypeListBox, 'String', [item{1} item{2}]);
%set(handles.listboxSpeaker,'Value',1);%Set al primo elemento sulla listbox
guidata(hObject, handles);


% --- Executes just before FILE_convertMeasureGUI is made visible.
function FILE_convertMeasureGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FILE_convertMeasureGUI (see VARARGIN)

%Preparo i tipi di misura effetuabili
%measType=['SMAART' 'CSVMAPP' ];

handles.measureType{1}='SMAART';
handles.measureType{2}='CSVMAPP';
handles.measureTypeDescription{1}='Measure excuted with SMAART';
handles.measureTypeDescription{2}='Measure imported from MAPP ON LINE';

% Choose default command line output for FILE_convertMeasureGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

measureTypeListBox_setBox(hObject, eventdata, handles) ;
% UIWAIT makes FILE_convertMeasureGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = FILE_convertMeasureGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function readPathText_Callback(hObject, eventdata, handles)
% hObject    handle to readPathText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of readPathText as text
%        str2double(get(hObject,'String')) returns contents of readPathText as a double


% --- Executes during object creation, after setting all properties.
function readPathText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to readPathText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function matrixNameFileText_Callback(hObject, eventdata, handles)
% hObject    handle to matrixNameFileText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of matrixNameFileText as text
%        str2double(get(hObject,'String')) returns contents of matrixNameFileText as a double


% --- Executes during object creation, after setting all properties.
function matrixNameFileText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to matrixNameFileText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in measureTypeListBox.
function measureTypeListBox_Callback(hObject, eventdata, handles)
% hObject    handle to measureTypeListBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns measureTypeListBox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from measureTypeListBox
n=get(handles.measureTypeListBox,'Value');
handles.measureTypeDescription{n}
set(handles.measureDescriptionText,'String',handles.measureTypeDescription{n});


% --- Executes during object creation, after setting all properties.
function measureTypeListBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to measureTypeListBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in convertButton.
function convertButton_Callback(hObject, eventdata, handles)
% hObject    handle to convertButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

writeFileName=get(handles.matrixNameFileText,'String');
readPath=get(handles.readPathText,'String');
formatType=handles.measureType(get(handles.measureTypeListBox,'Value'));
speakerName=get(handles.speakerName,'String');
speakerDescription=get(handles.speakerDescrption,'String');
SPLdBAt1meter=str2double(get(handles.SPLdBAt1mDescription ,'String'));
FILE_createMatrix(speakerName, speakerDescription, SPLdBAt1meter, formatType,readPath,writeFileName);

%per uscire....
guidata(hObject, handles);
FILE_convertMeasureGUI_OutputFcn(hObject, eventdata, handles);



function speakerName_Callback(hObject, eventdata, handles)
% hObject    handle to speakerName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of speakerName as text
%        str2double(get(hObject,'String')) returns contents of speakerName as a double


% --- Executes during object creation, after setting all properties.
function speakerName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to speakerName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function speakerDescrption_Callback(hObject, eventdata, handles)
% hObject    handle to speakerDescrption (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of speakerDescrption as text
%        str2double(get(hObject,'String')) returns contents of speakerDescrption as a double


% --- Executes during object creation, after setting all properties.
function speakerDescrption_CreateFcn(hObject, eventdata, handles)
% hObject    handle to speakerDescrption (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function SPLdBAt1mDescription_Callback(hObject, eventdata, handles)
% hObject    handle to SPLdBAt1mDescription (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SPLdBAt1mDescription as text
%        str2double(get(hObject,'String')) returns contents of SPLdBAt1mDescription as a double


% --- Executes during object creation, after setting all properties.
function SPLdBAt1mDescription_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SPLdBAt1mDescription (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


