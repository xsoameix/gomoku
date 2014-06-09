function varargout = chess(varargin)
% CHESS MATLAB code for chess.fig
%      CHESS, by itself, creates a new CHESS or raises the existing
%      singleton*.
%
%      H = CHESS returns the handle to a new CHESS or the handle to
%      the existing singleton*.
%
%      CHESS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CHESS.M with the given input arguments.
%
%      CHESS('Property','Value',...) creates a new CHESS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before chess_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to chess_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help chess

% Last Modified by GUIDE v2.5 06-Jun-2014 22:22:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @chess_OpeningFcn, ...
                   'gui_OutputFcn',  @chess_OutputFcn, ...
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


% --- Executes just before chess is made visible.
function chess_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to chess (see VARARGIN)

% Choose default command line output for chess
handles.output = hObject;
handles.board = Board(hObject);
guidata(hObject, handles);

% UIWAIT makes chess wait for user response (see UIRESUME)
% uiwait(handles.pane_figure);


% --- Outputs from this function are returned to the command line.
function varargout = chess_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function pane_figure_WindowButtonUpFcn(hObject, eventdata, handles)
% hObject    handle to pane_figure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
point = get(gca, 'CurrentPoint');
board = handles.board;
board.place(point(1, 1), point(1, 2));
handles.board = board;
guidata(hObject, handles);