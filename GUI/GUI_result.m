function varargout = GUI_result(varargin)
% GUI_RESULT M-file for GUI_result.fig
%      GUI_RESULT, by itself, creates a new GUI_RESULT or raises the existing
%      singleton*.
%
%      H = GUI_RESULT returns the handle to a new GUI_RESULT or the handle to
%      the existing singleton*.
%
%      GUI_RESULT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_RESULT.M with the given input arguments.
%
%      GUI_RESULT('Property','Value',...) creates a new GUI_RESULT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_result_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_result_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_result

% Last Modified by GUIDE v2.5 06-Oct-2009 18:18:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_result_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_result_OutputFcn, ...
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


% --- Executes just before GUI_result is made visible.
function GUI_result_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_result (see VARARGIN)

% Choose default command line output for GUI_result
handles.output = hObject;

%I primi tre parametri sono fissi, poi li voglio a gruppi di 2
%('Descrizone',parametro)
if (nargin >=5)
    for (n=1:2:(nargin-3) )
        switch (varargin{n})
            case 'SpaceGrid'
                handles.spaceGrid=varargin{n+1};
        end
    end
end
handles.nplane=0; %Set all  plane
%set(gcf,'CloseRequestFcn',@GUI_result_MyClosingFcn)
%un array dove mettere tutte le figure aperte
handles.handleSPLFigure=[];
handles.handleFreqRespFigure=[];
handles.HiLimSPL=130;
handles.LoLimSPL=75;
%Appronto la list box per scegiere le frequenze
setPlaneListBox(hObject, eventdata, handles);
setFrequencyListBox(hObject, eventdata, handles);
%listboxFrequency_Callback(hObject, eventdata, handles)

% Update handles structure
guidata(hObject, handles);


% UIWAIT makes GUI_result wait for user response (see UIRESUME)
uiwait(handles.figure1);

function setPlaneListBox(hObject, eventdata, handles) 
tGeometry=handles.spaceGrid.geometry;
item{1}='All';
for n=1:length(tGeometry.plane)
    item{n+1}=tGeometry.plane(n).name;
end
set(handles.listboxPlane, 'String', item);
guidata(hObject, handles);

function setFrequencyListBox(hObject, eventdata, handles) 
tPlane=handles.spaceGrid.geometry.plane(1);
for n=1:length(tPlane.freqSlice)
    item{n}=num2str(tPlane.freqSlice(n).f);
end
set(handles.listboxFrequency, 'String', item);
set(handles.listboxFrequency,'Value',1);%Set al primo elemento sulla listbox


set(handles.hilimit, 'String' , num2str(handles.HiLimSPL));%Set hi limit for spl
set(handles.lowlimit, 'String' , num2str(handles.LoLimSPL));%Set low limit for spl
t_x=(max(tPlane.coordinates.X)-min(tPlane.coordinates.X))/2;
t_y=(max(tPlane.coordinates.Y)-min(tPlane.coordinates.Y))/2;
t_z=(max(tPlane.coordinates.Z)-min(tPlane.coordinates.Z))/2;
set(handles.micXpos, 'String' , num2str(t_x));
set(handles.micYpos, 'String' , num2str(t_y));
guidata(hObject, handles);

%ridefinisco la funzione di chiusura
function GUI_result_MyClosingFcn(hObject, eventdata)

GUI_result_OutputFcn(hObject, eventdata, handles) 
delete(gcf)

% --- Outputs from this function are returned to the command line.
function varargout = GUI_result_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
if (ishandle(handles))
    varargout{1} = handles.output ;
    pushbuttonCloseSPL_Callback(hObject, eventdata, handles)
    uiresume(handles.figure1);
end

% --- Executes on selection change in listboxFrequency.
function listboxFrequency_Callback(hObject, eventdata, handles)
% hObject    handle to listboxFrequency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listboxFrequency contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listboxFrequency

nfreq=get(handles.listboxFrequency,'Value');
handles.LoLimSPL=str2num(get(handles.lowlimit,'String'));
handles.HiLimSPL=str2num(get(handles.hilimit,'String'));
if handles.nplane==0;
    hFigSPL=UTIL_displayAllPlaneSPL(handles.spaceGrid.geometry ,nfreq , handles.LoLimSPL  , handles.HiLimSPL );
else
    hFigSPL=UTIL_displayPlaneSPL(handles.spaceGrid.geometry.plane(handles.nplane) ,nfreq , handles.LoLimSPL  , handles.HiLimSPL );%Gli utlimi due valori sn i db max e min che voglio.. 
end
    %length(handle.handleSPLFigure)
%disp(['listboxFrequency_Callback enter handle_length=',num2str(length(handles.handleSPLFigure)) ]);
if (isempty(handles.handleSPLFigure)) 
    handles.handleSPLFigure(1)=hFigSPL;
    disp(['listboxFrequency_Callback handle_1=',num2str(handles.handleSPLFigure(1))])
else
    handles.handleSPLFigure(length(handles.handleSPLFigure) +1)=hFigSPL;
    %disp(['listboxFrequency_Callback handle_',num2str(length(handles.handleSPLFigure)), ...
    %                   '=',num2str(handles.handleSPLFigure(length(handles.handleSPLFigure)) )  ])
end
%disp(['listboxFrequency_Callback exiting handle_length=',num2str(length(handles.handleSPLFigure)) ]);
guidata(hObject, handles);




% --- Executes on button press in buttonGO.
function buttonGO_Callback(hObject, eventdata, handles)
% hObject    handle to buttonGO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

x=str2num(get(handles.micXpos,'String'));
y=str2num(get(handles.micYpos,'String'));

hFigFreqResp=UTIL_displayFreqResp(handles.spaceGrid , x, y);
%length(handle.handleSPLFigure)
%disp(['listboxFrequencyResp_Callback enter handle_length=',num2str(length(handles.handleSPLFigure)) ]);
if (isempty(handles.handleFreqRespFigure)) 
    handles.handleFreqRespFigure(1)=hFigFreqResp;
    %disp(['listboxFrequencyResp_Callback handle_1=',num2str(handles.handleFreqRespFigure(1))])
else
    handles.handleFreqRespFigure(length(handles.handleFreqRespFigure) +1)=hFigFreqResp;
    %disp(['listboxFrequencyResp_Callback handle_',num2str(length(handles.handleSPLFigure)), ...
    %                   '=',num2str(handles.handleSPLFigure(length(handles.handleSPLFigure)) )  ])
end
%disp(['listboxFrequencyResp_Callback exiting handle_length=',num2str(length(handles.handleSPLFigure)) ]);
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function listboxFrequency_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listboxFrequency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbuttonCloseSPL.
function pushbuttonCloseSPL_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonCloseSPL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp('pushbuttonCloseSPL_Callback enter');

if (~isempty(handles.handleSPLFigure)) 
    for n=1:length(handles.handleSPLFigure)
        if (ishandle(handles.handleSPLFigure(n))) 
            close (handles.handleSPLFigure(n));
        end
    end
    clear handles.handleSPLFigure;
    handles.handleSPLFigure=[];
end
guidata(hObject, handles);



% --- Executes on button press in pushbuttonCloseFreqResp.
function pushbuttonCloseFreqResp_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonCloseFreqResp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if (~isempty(handles.handleFreqRespFigure)) 
    for n=1:length(handles.handleFreqRespFigure)
        if (ishandle(handles.handleFreqRespFigure(n))) 
            close (handles.handleFreqRespFigure(n));
        end
    end
    clear handles.handleSPLFigure;
    handles.handleFreqRespFigure=[];
end
guidata(hObject, handles);

function lowlimit_Callback(hObject, eventdata, handles)
% hObject    handle to lowlimit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lowlimit as text
%        str2double(get(hObject,'String')) returns contents of lowlimit as a double


% --- Executes during object creation, after setting all properties.
function lowlimit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lowlimit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function hilimit_Callback(hObject, eventdata, handles)
% hObject    handle to hilimit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of hilimit as text
%        str2double(get(hObject,'String')) returns contents of hilimit as a double


% --- Executes during object creation, after setting all properties.
function hilimit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hilimit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function listboxFrequencyResp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listboxFrequencyResp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function micYpos_Callback(hObject, eventdata, handles)
% hObject    handle to micYpos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of micYpos as text
%        str2double(get(hObject,'String')) returns contents of micYpos as a double


% --- Executes during object creation, after setting all properties.
function micYpos_CreateFcn(hObject, eventdata, handles)
% hObject    handle to micYpos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function micXpos_Callback(hObject, eventdata, handles)
% hObject    handle to micXpos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of micXpos as text
%        str2double(get(hObject,'String')) returns contents of micXpos as a double


% --- Executes during object creation, after setting all properties.
function micXpos_CreateFcn(hObject, eventdata, handles)
% hObject    handle to micXpos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listboxPlane.
function listboxPlane_Callback(hObject, eventdata, handles)
% hObject    handle to listboxPlane (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listboxPlane contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listboxPlane
handles.nplane=get(handles.listboxPlane ,'Value')-1;
guidata(hObject, handles);
setFrequencyListBox(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function listboxPlane_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listboxPlane (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


