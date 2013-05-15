function varargout = GUI_RoomGeometry(varargin)
% GUI_ROOMGEOMETRY M-file for GUI_RoomGeometry.fig
%      GUI_ROOMGEOMETRY, by itself, creates a new GUI_ROOMGEOMETRY or raises the existing
%      singleton*.
%
%      H = GUI_ROOMGEOMETRY returns the handle to a new GUI_ROOMGEOMETRY or the handle to
%      the existing singleton*.
%
%      GUI_ROOMGEOMETRY('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_ROOMGEOMETRY.M with the given input arguments.
%
%      GUI_ROOMGEOMETRY('Property','Value',...) creates a new GUI_ROOMGEOMETRY or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_RoomGeometry_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_RoomGeometry_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_RoomGeometry

% Last Modified by GUIDE v2.5 27-Sep-2009 03:26:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_RoomGeometry_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_RoomGeometry_OutputFcn, ...
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


% --- Executes just before GUI_RoomGeometry is made visible.
function GUI_RoomGeometry_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_RoomGeometry (see VARARGIN)

% Choose default command line output for GUI_RoomGeometry
handles.output = hObject;
handles.RoomGeometry=struct();
%I primi tre parametri sono fissi, poi li voglio a gruppi di 2
%('Descrizone',parametro)
handles.nplane=1;
if (nargin >=5)
    for (n=1:2:(nargin-3) )
        switch (varargin{n})
            case 'RoomGeometry'
                handles.roomGeometry=varargin{n+1};
                handles.nplane=length(RoomGeometry.plane);
            case 'Plane'
                tplane=varargin{n+1};
                tplane.coordinates.X=0;
                tplane.coordinates.Y=0;
                tplane.coordinates.Z=0;
                handles.RoomGeometry.plane(handles.nplane)=tplane;
        end
    end
end

ncolor=10;
for n=1:ncolor    
    handles.colors(n)=(n-1)/ncolor;
end
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_RoomGeometry wait for user response (see UIRESUME)
uiwait(handles.FigureGUI_RoomGeometry);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_RoomGeometry_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
%Controllo se handle esiste (potrebbe essere stata chiusa la finestra
%dall'utente
%if (ishandle(handles)==1)
    disp('GUI_addPlane->GUI_RoomGeometry_OutputFcn: exit 1');
    varargout{1} = handles.output;
    disp('GUI_addPlane->GUI_RoomGeometry_OutputFcn: exit 2');
    varargout{2} = handles.RoomGeometry;
    disp('GUI_addPlane->GUI_RoomGeometry_OutputFcn: exit 3');
    uiresume(handles.FigureGUI_RoomGeometry);
    disp('GUI_addPlane->GUI_RoomGeometry_OutputFcn: exit 4');
%end

% --- Executes on button press in pushbuttonOK.
function pushbuttonOK_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonOK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Prendo i valori dalle caselle e li copio nell'handle
disp('GUI_addPlane->pushbuttonOK_Callback: exit 1');
guidata(hObject, handles);
disp('GUI_addPlane->pushbuttonOK_Callback: exit 2');
GUI_RoomGeometry_OutputFcn(hObject, eventdata, handles);
disp('GUI_addPlane->pushbuttonOK_Callback: exit 3');


% --- Executes on button press in pushbuttonCANCEL.
function pushbuttonCANCEL_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonCANCEL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%esco senza far nessuna modifica
GUI_RoomGeometry_OutputFcn(hObject, eventdata, handles);





% --- Executes on button press in pushbuttonAdd.
function pushbuttonAdd_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonAdd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




if (handles.nplane == 1)
    tplane=handles.RoomGeometry.plane(1);
else
    tplane=handles.RoomGeometry.plane(handles.nplane-1);
end
tplane.name=['Plane ' num2str(handles.nplane) ];
[h tplane]=GUI_addPlane('Plane', tplane);
close (h);

if isstruct(tplane)
    tplane.name=['Plane ' , num2str(handles.nplane) ];
    handles.RoomGeometry.plane(handles.nplane)=tplane;
    
    h=handles.axesRoomGeometry;
    disp(['added plane ' num2str(handles.nplane)])
    if handles.nplane==1
        cameratoolbar;
        title(h,'Room geometry');
        xlabel(h,'(X) meter')
        ylabel(h,'(Y) meter')
        zlabel(h,'(Z) meter');
        shading(h,'flat');
        colorLim(1)=min(handles.colors);
        colorLim(2)=max(handles.colors);
        caxis(h,colorLim);
    end
    hold(h, 'on');
    tX=tplane.coordinates.X;
    tY=tplane.coordinates.Y;
    tZ=tplane.coordinates.Z;
    [sy sx]=size(tZ);
    if length(tX)== 1
        tX=tX*ones(1,sx);
    end
    if length(tY)== 1
        tY=tY*ones(1,sy);
    end
    tColor=ones(size(tZ))*handles.colors(handles.nplane);
    
    %disp(['GUI_RoomGeometry - Dimensions: tX ' num2str(size(tX)) ' tY ' num2str(size(tY)) ' tZ ' num2str(size(tZ')) ]);
    %disp(['GUI_RoomGeometry - Dimensions: tColor ' num2str(size(tColor')) ]);
    mesh(h,tX,tY,tZ,tColor);
    
    hold(h, 'off');
    handles.nplane=handles.nplane+1;
    guidata(hObject, handles);
else
    disp('not a plane');
end

