function varargout = Main(varargin)
% Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Main_OpeningFcn, ...
                   'gui_OutputFcn',  @Main_OutputFcn, ...
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

function Main_OpeningFcn(hObject, eventdata, handles, varargin)
    handles.output = hObject;
    guidata(hObject, handles);
    get(0,'ScreenSize')
    clc
    clear all

function varargout = Main_OutputFcn(hObject, eventdata, handles) 
    varargout{1} = handles.output;
    movegui(gcf,'center');

function Frwbutton_Callback(hObject, eventdata, handles)
    FrwMod();

function Invbutton_Callback(hObject, eventdata, handles)
    InvMod();

function Exitbutton_Callback(hObject, eventdata, handles)
    close;

function figure1_CloseRequestFcn(hObject, eventdata, handles)
    opts.Interpreter = 'tex';
    opts.Default = 'YES';
    quest = 'Are you sure you want to exit the program?';
    answer = questdlg(quest,'EXIT','YES','NO',opts);
    switch answer
        case 'YES'
            delete(hObject);
            close all;
    end
