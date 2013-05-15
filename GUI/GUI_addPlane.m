function varargout = GUI_addPlane(varargin)
% GUI_addPlane M-file for GUI_addPlane.fig
%      GUI_addPlane, by itself, creates a new GUI_addPlane or raises the existing
%      singleton*.
%
%      H = GUI_addPlane returns the handle to a new GUI_addPlane or the handle to
%      the existing singleton*.
%
%      GUI_addPlane('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_addPlane.M with the given input arguments.
%
%      GUI_addPlane('Property','Value',...) creates a new GUI_addPlane or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_addPlane_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_addPlane_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_addPlane

% Last Modified by GUIDE v2.5 26-Sep-2009 15:21:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_addPlane_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_addPlane_OutputFcn, ...
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


% --- Executes just before GUI_addPlane is made visible.
function GUI_addPlane_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_addPlane (see VARARGIN)

% Choose default command line output for GUI_addPlane
handles.output = hObject;

%I primi tre parametri sono fissi, poi li voglio a gruppi di 2
%('Descrizone',parametro)
if (nargin >=5)
    for (n=1:2:(nargin-3) )
        switch (varargin{n})
            case 'Plane'
                handles.plane=varargin{n+1};
        end
    end
end
    %Inizializzo un pò tutti i valori
    set(handles.vertexA_X,'String',num2str(handles.plane.A(1)) )
    set(handles.vertexA_Y,'String',num2str(handles.plane.A(2)) )
    set(handles.vertexA_Z,'String',num2str(handles.plane.A(3)) )
    set(handles.vertexB_X,'String',num2str(handles.plane.B(1)) )
    set(handles.vertexB_Y,'String',num2str(handles.plane.B(2)) )
    set(handles.vertexB_Z,'String',num2str(handles.plane.B(3)) )
    set(handles.vertexC_X,'String',num2str(handles.plane.C(1)) )
    set(handles.vertexC_Y,'String',num2str(handles.plane.C(2)) )
    set(handles.vertexC_Z,'String',num2str(handles.plane.C(3)) )
    set(handles.editResX,'String',num2str(handles.plane.resX) )
    set(handles.editResY,'String',num2str(handles.plane.resY) )
    set(handles.name,'String',handles.plane.name )
    
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_addPlane wait for user response (see UIRESUME)
uiwait(handles.FigureGUI_RoomGeometry);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_addPlane_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
%Controllo se handle esiste (potrebbe essere stata chiusa la finestra
%dall'utente
%if (ishandle(handles)==1)
    varargout{1} = handles.output;
    varargout{2} = handles.plane;
    uiresume(handles.FigureGUI_RoomGeometry);
%end

% --- Executes on button press in pushbuttonOK.
% --- Executes on button press in pushbuttonOK.
function pushbuttonOK_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonOK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Prendo i valori dalle caselle e li copio nell'handle
handles.plane.A(1)=str2double(get(handles.vertexA_X,'String'));
handles.plane.A(2)=str2double(get(handles.vertexA_Y,'String'));
handles.plane.A(3)=str2double(get(handles.vertexA_Z,'String'));
handles.plane.B(1)=str2double(get(handles.vertexB_X,'String'));
handles.plane.B(2)=str2double(get(handles.vertexB_Y,'String'));
handles.plane.B(3)=str2double(get(handles.vertexB_Z,'String'));
handles.plane.C(1)=str2double(get(handles.vertexC_X,'String'));
handles.plane.C(2)=str2double(get(handles.vertexC_Y,'String'));
handles.plane.C(3)=str2double(get(handles.vertexC_Z,'String'));
handles.plane.resX=str2double(get(handles.editResX,'String'));
handles.plane.resY=str2double(get(handles.editResY,'String'));
handles.plane.name=get(handles.name,'String');
%calcolate the plane... 
tplane=UTIL_calcolatePlaneFromData(handles.plane);
if isstruct(tplane)
    handles.plane.coordinates=tplane.coord;   
    disp(['GUI_addPlane: calcolated plane ' handles.plane.name] );
    guidata(hObject, handles);
    GUI_addPlane_OutputFcn(hObject, eventdata, handles);
else
    disp('GUI_addPlane: not calcolated, is invalid plane');
end




function pushbuttonCANCEL_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonCANCEL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%esco senza far nessuna modifica
GUI_addPlane_OutputFcn(hObject, eventdata, handles);


function vertexA_X_Callback(hObject, eventdata, handles)
% hObject    handle to vertexA_X (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of vertexA_X as text
%        str2double(get(hObject,'String')) returns contents of vertexA_X as a double


% --- Executes during object creation, after setting all properties.
function vertexA_X_CreateFcn(hObject, eventdata, handles)
% hObject    handle to vertexA_X (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function editSizeY_Callback(hObject, eventdata, handles)
% hObject    handle to editSizeY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editSizeY as text
%        str2double(get(hObject,'String')) returns contents of editSizeY as a double


% --- Executes during object creation, after setting all properties.
function editSizeY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editSizeY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editResX_Callback(hObject, eventdata, handles)
% hObject    handle to editResX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editResX as text
%        str2double(get(hObject,'String')) returns contents of editResX as a double


% --- Executes during object creation, after setting all properties.
function editResX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editResX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editResY_Callback(hObject, eventdata, handles)
% hObject    handle to editResY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editResY as text
%        str2double(get(hObject,'String')) returns contents of editResY as a double


% --- Executes during object creation, after setting all properties.
function editResY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editResY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function vertexA_Y_Callback(hObject, eventdata, handles)
% hObject    handle to vertexA_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of vertexA_y as text
%        str2double(get(hObject,'String')) returns contents of vertexA_y as a double


% --- Executes during object creation, after setting all properties.
function vertexA_Y_CreateFcn(hObject, eventdata, handles)
% hObject    handle to vertexA_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function vertexA_Z_Callback(hObject, eventdata, handles)
% hObject    handle to vertexA_z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of vertexA_z as text
%        str2double(get(hObject,'String')) returns contents of vertexA_z as a double


% --- Executes during object creation, after setting all properties.
function vertexA_Z_CreateFcn(hObject, eventdata, handles)
% hObject    handle to vertexA_z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function vertexB_X_Callback(hObject, eventdata, handles)
% hObject    handle to vertexB_X (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of vertexB_X as text
%        str2double(get(hObject,'String')) returns contents of vertexB_X as a double


% --- Executes during object creation, after setting all properties.
function vertexB_X_CreateFcn(hObject, eventdata, handles)
% hObject    handle to vertexB_X (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function vertexB_Y_Callback(hObject, eventdata, handles)
% hObject    handle to vertexB_Y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of vertexB_Y as text
%        str2double(get(hObject,'String')) returns contents of vertexB_Y as a double


% --- Executes during object creation, after setting all properties.
function vertexB_Y_CreateFcn(hObject, eventdata, handles)
% hObject    handle to vertexB_Y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function vertexB_Z_Callback(hObject, eventdata, handles)
% hObject    handle to vertexB_Z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of vertexB_Z as text
%        str2double(get(hObject,'String')) returns contents of vertexB_Z as a double


% --- Executes during object creation, after setting all properties.
function vertexB_Z_CreateFcn(hObject, eventdata, handles)
% hObject    handle to vertexB_Z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function vertexC_X_Callback(hObject, eventdata, handles)
% hObject    handle to vertexC_X (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of vertexC_X as text
%        str2double(get(hObject,'String')) returns contents of vertexC_X as a double


% --- Executes during object creation, after setting all properties.
function vertexC_X_CreateFcn(hObject, eventdata, handles)
% hObject    handle to vertexC_X (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function vertexC_Y_Callback(hObject, eventdata, handles)
% hObject    handle to vertexC_Y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of vertexC_Y as text
%        str2double(get(hObject,'String')) returns contents of vertexC_Y as a double


% --- Executes during object creation, after setting all properties.
function vertexC_Y_CreateFcn(hObject, eventdata, handles)
% hObject    handle to vertexC_Y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function vertexC_Z_Callback(hObject, eventdata, handles)
% hObject    handle to vertexC_Z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of vertexC_Z as text
%        str2double(get(hObject,'String')) returns contents of vertexC_Z as a double


% --- Executes during object creation, after setting all properties.
function vertexC_Z_CreateFcn(hObject, eventdata, handles)
% hObject    handle to vertexC_Z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


