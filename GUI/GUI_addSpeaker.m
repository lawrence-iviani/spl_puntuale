function varargout = GUI_addSpeaker(varargin)
% GUI_ADDSPEAKER M-file for GUI_addSpeaker.fig
%      GUI_ADDSPEAKER, by itself, creates a new GUI_ADDSPEAKER or raises the existing
%      singleton*.
%
%      H = GUI_ADDSPEAKER returns the handle to a new GUI_ADDSPEAKER or the handle to
%      the existing singleton*.
%
%      GUI_ADDSPEAKER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_ADDSPEAKER.M with the given input arguments.
%
%      GUI_ADDSPEAKER('Property','Value',...) creates a new GUI_ADDSPEAKER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_addSpeaker_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_addSpeaker_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_addSpeaker

% Last Modified by GUIDE v2.5 06-Oct-2009 16:49:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_addSpeaker_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_addSpeaker_OutputFcn, ...
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


% --- Executes just before GUI_addSpeaker is made visible.
function GUI_addSpeaker_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_addSpeaker (see VARARGIN)

% Choose default command line output for GUI_addSpeaker
handles.output = hObject;
handles.end=false;
handles.speedOfSound=343;

%I primi tre parametri sono fissi, poi li voglio a gruppi di 2
%('Descrizone',parametro)
if (nargin >=5)
    for (n=1:2:(nargin-3) )
        switch (varargin{n})
            case 'RoomGeometry'
                handles.RoomGeometry=varargin{n+1};
            case 'SpeakerList'
                handles.SpeakerList=varargin{n+1};
            case 'SpeedOfSound'
                handles.speedOfSound=varargin{n+1};
        end
    end
end
setListBox(hObject, eventdata, handles);
listboxSpeaker_Callback(hObject, eventdata, handles)
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_addSpeaker wait for user response (see UIRESUME)
uiwait(handles.FigureAddSpeaker);

function setListBox(hObject, eventdata, handles) 

for n=1:length(handles.SpeakerList.speaker)
    spk=handles.SpeakerList.speaker(n);
    item{n}=spk.name; 
end
set(handles.listboxSpeaker, 'String', item);
%set(handles.listboxSpeaker,'Value',1);%Set al primo elemento sulla listbox
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = GUI_addSpeaker_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
varargout{2} = handles.speakerDescr;
varargout{3} = handles.end;
%if (handles.end) 
    uiresume(handles.FigureAddSpeaker);
%end

% --- Executes on button press in ButtonCancel.
function ButtonCancel_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonCancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in ButtonAdd.
function ButtonAdd_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonAdd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Trovo che speaker è stato selezionato
n=get(handles.listboxSpeaker,'Value');
%Preparo la struttura d'uscita
handles.speakerDescr=struct();
handles.speakerDescr.speaker=handles.SpeakerList.speaker(n);
handles.speakerDescr.posX=str2num(get(handles.posx,'String'));
handles.speakerDescr.posY=str2num(get(handles.posy,'String'));
handles.speakerDescr.posZ=str2num(get(handles.posz,'String'));
handles.speakerDescr.orientation=UTIL_deg2rad(str2num(get(handles.orientation,'String')));
handles.speakerDescr.delay=str2num(get(handles.delay,'String'));
handles.speakerDescr.reversePolarity=get(handles.reversePolarity,'Value');

%handles.speakerDescr.speaker=
%handles.speakerDescr.power_ o line power%TODO
%handles.speakerDescr.delay%TODO
guidata(hObject, handles);
GUI_addSpeaker_OutputFcn(hObject, eventdata, handles);

% --- Executes on button press in buttonEnd.
function buttonEnd_Callback(hObject, eventdata, handles)
% hObject    handle to buttonEnd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.end=true;
guidata(hObject, handles);
GUI_addSpeaker_OutputFcn(hObject, eventdata, handles);

function posx_Callback(hObject, eventdata, handles)
% hObject    handle to posx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of posx as text
%        str2double(get(hObject,'String')) returns contents of posx as a double

 

% --- Executes during object creation, after setting all properties.
function posx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to posx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function posy_Callback(hObject, eventdata, handles)
% hObject    handle to posy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of posy as text
%        str2double(get(hObject,'String')) returns contents of posy as a double


% --- Executes during object creation, after setting all properties.
function posy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to posy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listboxSpeaker.
function listboxSpeaker_Callback(hObject, eventdata, handles)
% hObject    handle to listboxSpeaker (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

n=get(handles.listboxSpeaker,'Value');
set(handles.textName, 'String' ,['Name            : ',handles.SpeakerList.speaker(n).name]);
set(handles.textManufacturer, 'String' ,['Manufacturer: ',handles.SpeakerList.speaker(n).manufacturer]);

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function listboxSpeaker_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listboxSpeaker (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function orientation_Callback(hObject, eventdata, handles)
% hObject    handle to orientation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of orientation as text
%        str2double(get(hObject,'String')) returns contents of orientation as a double
val=UTIL_deg2rad(str2double(get(hObject,'String')));
if (val <= -2*pi || val >= 2*pi)
    set(hObject,'String',num2str(0))
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function orientation_CreateFcn(hObject, eventdata, handles)
% hObject    handle to orientation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function delay_Callback(hObject, eventdata, handles)
% hObject    handle to delay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of delay as text
%        str2double(get(hObject,'String')) returns contents of delay as a double

ms=str2double(get(hObject,'String'))/1000;
set(handles.delayMeters,'String',num2str(ms*handles.speedOfSound));
guidata(hObject, handles);



function delayMeters_Callback(hObject, eventdata, handles)
% hObject    handle to delayMeters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of delayMeters as text
%        str2double(get(hObject,'String')) returns contents of delayMeters as a double

meters=str2double(get(hObject,'String'));
set(handles.delay,'String',num2str(1000*meters/handles.speedOfSound));
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function delay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to delay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function delayMeters_CreateFcn(hObject, eventdata, handles)
% hObject    handle to delayMeters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in reversePolarity.
function reversePolarity_Callback(hObject, eventdata, handles)
% hObject    handle to reversePolarity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of reversePolarity



function posz_Callback(hObject, eventdata, handles)
% hObject    handle to posz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of posz as text
%        str2double(get(hObject,'String')) returns contents of posz as a double


% --- Executes during object creation, after setting all properties.
function posz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to posz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


