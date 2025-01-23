function varargout = InvMod(varargin)
% Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @InvMod_OpeningFcn, ...
                   'gui_OutputFcn',  @InvMod_OutputFcn, ...
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

%Figure1 Opening Event 
function InvMod_OpeningFcn(hObject, eventdata, handles, varargin)
    handles.output = hObject;
    guidata(hObject, handles);
    movegui(gcf,'center');
    global edit_cc edit_mm edit_nn edit_pp 
    global edit_xx edit_xxb edit_xxs
    global edit_qq edit_AA edit_zz edit_TT
    global qb qs qa Eps
    global x Vc
    global minZ maxZ z1 z2 edit_Sb
    global edit_minZ edit_maxZ ModAxes RMS
    global RB_all RB_best smax edit_epss
    global RMS_Axes Depth_Axes A_Axes T_Axes dirname
    clc
    edit_cc=handles.edit_c;
    edit_mm=handles.edit_m;
    edit_nn=handles.edit_n;
    edit_pp=handles.edit_p;
    edit_qq=handles.edit_q;
    edit_AA=handles.edit_A;
    edit_xx=handles.edit_x;
    edit_xxb=handles.edit_xb;
    edit_xxs=handles.edit_xs;

    edit_zz=handles.edit_z;
    edit_TT=handles.edit_Theta;
    edit_minZ=handles.edit_minZ;
    edit_maxZ=handles.edit_maxZ;
    ModAxes=handles.AnoAxes;
    RMS_Axes=handles.RMS_Axes;
    A_Axes=handles.A_Axes;
    Depth_Axes=handles.Depth_Axes;
    T_Axes=handles.T_Axes;
    RMS=handles.edit_RMS;
    RB_all=handles.RB_all;
    RB_best=handles.RB_best;
    edit_Sb=handles.edit_Sb;
    edit_epss=handles.edit_eps;

qb=0.5;qs=1.5;qa=0.5;
Eps=1e-8;

x=[];
Vc=[];
minZ=1;
maxZ=20;
smax=30;
z1=minZ;
z2=maxZ;
edit_epss=8;
  set(edit_Sb,'String',smax);

  set(edit_minZ,'String',minZ);
  set(edit_maxZ,'String',maxZ);
  set(handles.edit_qb,'String',qb);
  set(handles.edit_qs,'String',qs);
  set(handles.edit_qa,'String',qa);
  set(handles.edit_eps,'String',edit_epss);

%dirname='D:\SenGRSPint\';




function varargout = InvMod_OutputFcn(hObject, eventdata, handles) 
    varargout{1} = handles.output;


function saveAnomalyBtn_Callback(hObject, eventdata, handles)
global nData x Vc xmm BestAnomaly
global Best_q Best_A Best_z Best_Theta Best_x0
global RMS1 D11 D1 A11 A1 T11 T1 X11 X1 tson ttson sson 
global RMS_It D11_It A11_It T11_It X11_It  smax 
global filename dirname

[filepath,name,ext] = fileparts(filename);
filename1=[ dirname name '_Results' '.txt'];
[file,path] = uiputfile(filename1); 


if isequal(file,0) || isequal(path,0)
  %set(handles.modelPrmTable,'Data',iniA_itodData);
else
  file=fullfile(path,file);
  f=fopen(file,'wt');
  fprintf(f,'%12s %12s %12s %12s\n','Distance','Observed','Calculated','Difference');
  for i=1:nData
    fprintf(f,'%12.2f %12.3f %12.3f %12.3f\n',xmm(i),Vc(i),BestAnomaly(i),Vc(i)-BestAnomaly(i));
  end
  fclose(f);
 end;
 %*******************


[filepath,name,ext] = fileparts(filename);
filename1=[ dirname name '_ModIter' '.txt'];
[file,path] = uiputfile(filename1); 

if isequal(file,0) || isequal(path,0)
  %set(handles.modelPrmTable,'Data',iniA_itodData);
else
  file=fullfile(path,file);
  f=fopen(file,'wt');
  fprintf(f,'%7s %12s %12s %12s %12s %12s %12s %12s %12s\n','S','RMS','x0','Depth','Ampl.','Angle','MeanDepth','MeanAmpl.','MeanAngle');
  for i=1:smax
    fprintf(f,'%7d %12.4e %12.4f %12.4f %12.4f %12.4f %12.4f %12.4f %12.4f\n',i,RMS_It(i),X11_It(i),D11_It(i),A11_It(i),T11_It(i),mean(D11_It(1:i)),mean(A11_It(1:i)),mean(T11_It(1:i)));
  end
  fclose(f);
 end;

%SAVE GRAPHICS Button Call Event
function saveFigureBtn_Callback(hObject, eventdata, handles)
global GR x Vc BestAnomaly;
global filename dirname
[filepath,name,ext] = fileparts(filename);
filename1=[ dirname name '.fig'];
[file,path] = uiputfile(filename1); 
  
  if isequal(file,0) || isequal(path,0)
  else
    file=fullfile(path,file);
    fig=InvMod;
    saveas(fig,file);
    end;




%LOAD Button Call Event
function loadAnomalyBtn_Callback(hObject, eventdata, handles)
global GR SP xmm xb xs;
global nData Vc x
global c m n p;
global edit_cc edit_mm edit_nn edit_pp 
global edit_qq edit_AA edit_zz edit_TT
global edit_xx edit_xxb edit_xxs xxx yyy
global filename dirname name
x=[];Vc=[];
    filename=[];name=[];
    [file,path] = uigetfile([ dirname '*.txt'],' ');%  file=fullfile([ path ],file)
    filename=file;
if isequal(file,0) || isequal(path,0)
else
  file=fullfile(path,file);
  f=fopen(file);
  data1 = textscan(f,'%s %s %f %f',1);
  data2 = textscan(f,'%s %s %f',1);
  if cell2mat(data1(3))==1
    GR=1;SP=0;
    c=0;m=0;n=0;p=1;
  end
  if cell2mat(data1(4))==1
    SP=1;GR=0;
    c=1;m=1;n=1;p=1;
  end
  nData=cell2mat(data2(3));
  data = textscan(f,'%s %s',1);
  for i=1:nData
    data = textscan(f,'%f %f',1);
    x(i)=cell2mat(data(1));
    Vc(i)=cell2mat(data(2));
  end

  xmm=x;
mu=0;sigma=20;nr=length(Vc);
%noise = normrnd(mu,sigma,[1, nr]);
%noise = mu + sigma*randn([1, nr])
  fclose(f);
  set(edit_cc,'String',c);
  set(edit_mm,'String',m);
  set(edit_nn,'String',n);
  set(edit_pp,'String',p);
  
  set(edit_qq,'String','');
  set(edit_AA,'String','');
  set(edit_zz,'String','');
  set(edit_TT,'String','');
  set(edit_xx,'String','');
  set(edit_xxb,'String','');
  set(edit_xxs,'String','');
  nX=length(x);
  cla(handles.AnoAxes);
  axes(handles.AnoAxes);
  plot(x,Vc,'ro','Markersize',4,'MarkerFaceColor','r'),hold on;
  
  if GR==1
  txt = sprintf('%5.1f', xb);set(edit_xxb,'String',txt);
  txt = sprintf('%5.1f', xs);set(edit_xxs,'String',txt);
  [Maxima,MaxIdx] = findpeaks(Vc);

    [Minima,MinIdx] = min(Vc);
    [Maxima,MaxIdx] = max(Vc);
    if abs(Maxima)>=abs(Minima)
      Mmax=MaxIdx;
    else
      Mmax=MinIdx;
    end      
  MaxIdx=Mmax;
  xb=x(MaxIdx-5);
  xs=x(MaxIdx+5);
  pp1=MaxIdx;
  pp2=MaxIdx-5;
  txt = sprintf('%5.1f', xb);set(edit_xxb,'String',txt);
  txt = sprintf('%5.1f', xs);set(edit_xxs,'String',txt);

  yyyy=get(gca,'ylim')
  xxxx(1)=x(MaxIdx);
  xxxx(2)=x(MaxIdx);
  plot(xxxx,yyyy,'g-')

  else
  [fobj_min,ind_min] = min(Vc);
  [fobj_min,ind_max] = max(Vc);
xx(2)=x(ind_min);
xx(1)=x(ind_max);
vv(2)=Vc(ind_min);
vv(1)=Vc(ind_max);

  [xxx,yyy]=polyxpoly(xx,vv,x,Vc);
  yyyy=get(gca,'ylim');
 [Rx,Cx] = find(x>xxx(2),1, 'first');
 
  xxxx(1)=xxx(2);
  xxxx(2)=xxx(2);
  
  xxxx(1)=x(Cx);
  xxxx(2)=x(Cx);
  plot(xxxx,yyyy,'g-')
  xb=x(Cx-8);
  xs=x(Cx+8);
  txt = sprintf('%5.1f', xb);set(edit_xxb,'String',txt);
  txt = sprintf('%5.1f', xs);set(edit_xxs,'String',txt);


end
  xlim([min(x) max(x)])
  xlabel('Distance (km)');
  if GR==1;
    ylabel('Gravity anomaly (mGal)');
  else
    ylabel('SP anomaly (mV)');
  end
end;
set(handles.InterprateBtn,'enable','on');
set(handles.saveAnomalyBtn,'enable','off');
set(handles.saveFigureBtn,'enable','off');
set(handles.saveModBtn,'enable','off');



    
    
function InterprateBtn_Callback(hObject, eventdata, handles)
  global GR SP
  global c m n p;
  global q A z Theta;
  global nData x dx Vc  F
  global qb qs qa
  global minZ maxZ z1 BestAnomaly
  global Best_q Best_A Best_z Best_Theta
  clc
   if get(handles.RB_fixed, 'Value')==1;fixed;end
   if get(handles.RB_bisection, 'Value')==1;Bisection;end
   if get(handles.RB_regula, 'Value')==1;Regula;end
   if get(handles.RB_secant, 'Value')==1;Secant;end
   if get(handles.RB_stefensen, 'Value')==1;Steffensen;end

  set(handles.saveAnomalyBtn,'enable','on');
  set(handles.saveFigureBtn,'enable','on');
  set(handles.saveModBtn,'enable','on');

%CLOSE Button Call Event
function closeBtn_Callback(hObject, eventdata, handles)
    close;

%figure1 Close Event
function figure1_CloseRequestFcn(hObject, eventdata, handles)
    global GR SP;
    global c m n p;
    global q A z Theta;
    global nData x dx Vc  F
    global qb qs qa
    global minZ maxZ z1 BestAnomaly
    global Best_q Best_A Best_z Best_Theta

    GR=[];
    SP=[];
    c=[];m=[];n=[];p=[];q=[];
    A=[];z=[];Theta=[];
    nData=[];x=[];dx=[];Vc=[];
    qb=[];qs=[];qa=[];
    minZ=[];maxZ=[];z1=[];BestAnomaly=[];
    Best_q=[];Best_A=[];Best_z=[];Best_Theta=[];    
    delete(hObject);



function edit_c_Callback(hObject, eventdata, handles)
% hObject    handle to edit_c (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_c as text
%        str2double(get(hObject,'String')) returns contents of edit_c as a double
global c
c=str2num(get(hObject,'String'));


% --- Executes during object creation, after setting all properties.
function edit_c_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_c (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_m_Callback(hObject, eventdata, handles)
% hObject    handle to edit_m (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_m as text
%        str2double(get(hObject,'String')) returns contents of edit_m as a double
global m
m=str2num(get(hObject,'String'));


% --- Executes during object creation, after setting all properties.
function edit_m_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_m (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_n_Callback(hObject, eventdata, handles)
% hObject    handle to edit_n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_n as text
%        str2double(get(hObject,'String')) returns contents of edit_n as a double
global n
n=str2num(get(hObject,'String'));


% --- Executes during object creation, after setting all properties.
function edit_n_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_p_Callback(hObject, eventdata, handles)
% hObject    handle to edit_p (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_p as text
%        str2double(get(hObject,'String')) returns contents of edit_p as a double
global p
p=str2num(get(hObject,'String'));


% --- Executes during object creation, after setting all properties.
function edit_p_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_p (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_q_Callback(hObject, eventdata, handles)
% hObject    handle to edit_q (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_q as text
%        str2double(get(hObject,'String')) returns contents of edit_q as a double


% --- Executes during object creation, after setting all properties.
function edit_q_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_q (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_A_Callback(hObject, eventdata, handles)
  global A
% hObject    handle to edit_A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_A as text
%        str2double(get(hObject,'String')) returns contents of edit_A as a double
A=str2num(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function edit_A_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_z_Callback(hObject, eventdata, handles)
  global z
% hObject    handle to edit_z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_z as text
%        str2double(get(hObject,'String')) returns contents of edit_z as a double
z=str2num(get(hObject,'String'));


% --- Executes during object creation, after setting all properties.
function edit_z_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Theta_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Theta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Theta as text
%        str2double(get(hObject,'String')) returns contents of edit_Theta as a double
global Theta
Theta=str2num(get(hObject,'String'));


% --- Executes during object creation, after setting all properties.
function edit_Theta_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Theta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_dx_Callback(hObject, eventdata, handles)
% hObject    handle to edit_dx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_dx as text
%        str2double(get(hObject,'String')) returns contents of edit_dx as a double


% --- Executes during object creation, after setting all properties.
function edit_dx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_dx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_nData_Callback(hObject, eventdata, handles)
% hObject    handle to edit_nData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_nData as text
%        str2double(get(hObject,'String')) returns contents of edit_nData as a double


% --- Executes during object creation, after setting all properties.
function edit_nData_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_nData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_qb_Callback(hObject, eventdata, handles)
% hObject    handle to edit_qb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_qb as text
%        str2double(get(hObject,'String')) returns contents of edit_qb as a double
global qb
qb=str2num(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function edit_qb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_qb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_qa_Callback(hObject, eventdata, handles)
% hObject    handle to edit_qa (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_qa as text
%        str2double(get(hObject,'String')) returns contents of edit_qa as a double
global qa
qa=str2num(get(hObject,'String'));


% --- Executes during object creation, after setting all properties.
function edit_qa_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_qa (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_qs_Callback(hObject, eventdata, handles)
% hObject    handle to edit_qs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_qs as text
%        str2double(get(hObject,'String')) returns contents of edit_qs as a double
global qs
qs=str2num(get(hObject,'String'));
% --- Executes during object creation, after setting all properties.
function edit_qs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_qa (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton24.
function pushbutton24_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





function edit_Ss_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Ss (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Ss as text
%        str2double(get(hObject,'String')) returns contents of edit_Ss as a double


% --- Executes during object creation, after setting all properties.
function edit_Ss_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Ss (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Sa_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Sa (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Sa as text
%        str2double(get(hObject,'String')) returns contents of edit_Sa as a double


% --- Executes during object creation, after setting all properties.
function edit_Sa_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Sa (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Sb_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Sb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Sb as text
%        str2double(get(hObject,'String')) returns contents of edit_Sb as a double
global smax
smax=str2num(get(hObject,'String'));


% --- Executes during object creation, after setting all properties.
function edit_Sb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Sb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_maxZ_Callback(hObject, eventdata, handles)
% hObject    handle to edit_maxZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_maxZ as text
%        str2double(get(hObject,'String')) returns contents of edit_maxZ as a double
global maxZ z2
maxZ=str2num(get(hObject,'String'));
z2=maxZ;

% --- Executes during object creation, after setting all properties.
function edit_maxZ_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_maxZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_minZ_Callback(hObject, eventdata, handles)
% hObject    handle to edit_minZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_minZ as text
%        str2double(get(hObject,'String')) returns contents of edit_minZ as a double
global minZ z1
minZ=str2num(get(hObject,'String'));
z1=minZ;

% --- Executes during object creation, after setting all properties.
function edit_minZ_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_minZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_eps_Callback(hObject, eventdata, handles)
% hObject    handle to edit_eps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_eps as text
%        str2double(get(hObject,'String')) returns contents of edit_eps as a double
global Eps edit_epss
Eps=10^(-str2num(get(hObject,'String')));



% --- Executes during object creation, after setting all properties.
function edit_eps_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_eps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in saveModBtn.
function saveModBtn_Callback(hObject, eventdata, handles)
% hObject    handle to saveModBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global nData x Vc BestAnomaly
global Best_q Best_A Best_z Best_Theta Best_x0 Best_RMS
global filename dirname
[filepath,name,ext] = fileparts(filename);
filename1=[ dirname name '_BestMod' '.txt'];
[file,path] = uiputfile(filename1);  

%[file,path] = uiputfile(fileName3);
if isequal(file,0) || isequal(path,0)
  %set(handles.modelPrmTable,'Data',iniA_itodData);
else
            file=fullfile(path,file);
  f=fopen(file,'wt');

  fprintf(f,'Shape_factor_(q)  : %7.2f \n',Best_q);
  fprintf(f,'Amplitude_(K)     : %7.2f \n',Best_A);
  fprintf(f,'Depth_(z)         : %7.2f \n',Best_z);
  fprintf(f,'Dip_Angle(Theta)  : %7.2f \n',Best_Theta);
  fprintf(f,'Best_x0(m)        : %7.2f \n',Best_x0);
  fprintf(f,'Best_RMS          : %7.6e \n',Best_RMS);
  
  fclose(f);
end;



function edit_RMS_Callback(hObject, eventdata, handles)
% hObject    handle to edit_RMS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_RMS as text
%        str2double(get(hObject,'String')) returns contents of edit_RMS as a double


% --- Executes during object creation, after setting all properties.
function edit_RMS_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_RMS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function [ dep ]=CalcZ(Ndata,x,Vcc,Vo,z11,q,s,F,sum1,sum2)
  global ddx
      for i=1:Ndata
        PAY1=(x(i)^2)*(x(i)*(F-1)+s*(F+1)*ddx);
        PYD1=(x(i)^2+z11^2)^(q+1);
        A1=PAY1/PYD1;
        PAY2=(x(i)^2)*(x(i)*(F-1)+s*(F+1)*ddx)^2;
        PYD2=(x(i)^2+z11^2)^(2*q+1.);
        A2=(PAY2/PYD2);
        sum1=sum1+Vcc(i)*A1;
        sum2=sum2+(Vo/(s*(F+1)*ddx))*A2;
      end
      dep=((abs(sum1/sum2)))^(1/(2*q));
      
      function [ AAAC,theta,th11 ]=CalcA(Vo,dep,s,q,c,m,p,F,GR)
        global ddx
 if GR==1 
%            if q==0.5;p=1.0;end
%            if q==0.6;p=0.8;end
%            if q==0.7;p=0.6;end
%            if q==0.8;p=0.4;end
%            if q==0.9;p=0.2;end
%           if q>=1.0;p=1.0;end
%           if q>=0.9;p=0.8;end
%           if q>=0.8;p=0.6;end
%           if q>=0.7;p=0.4;end
%           if q>=0.6;p=0.2;end
%           if q>=0.2;p=0.0;end
          
          if q>=0.2;p=0.0;end
          if q>=0.6;p=0.2;end          
          if q>=0.7;p=0.4;end
          if q>=0.8;p=0.6;end
          if q>=0.9;p=0.8;end
          if q>=1.0;p=1.0;end
    gg1=c*F*s*ddx+c*s*ddx;
    gg2=F*dep^p-dep^p;
    th11=90*pi/180;
    theta=th11*180/pi;
    gg3=Vo*dep^(2*q-p);
    gg4=sin(th11)^m;
    AAAC=gg3/gg4;
 else
    gg1=c*F*s*ddx+c*s*ddx;
    gg2=F*dep^p-dep^p;
    th11=atan(gg1/gg2);
    theta=th11*180/pi;
    gg3=Vo*dep^(2*q-p);
    gg4=sin(th11)^m;
    AAAC=gg3/gg4;  
 end
% ********************************************

function [ ]=fixed()
  global GR xb xs;
  global c m n p;
  global q A z Theta;
  global nData x dx Vc  F
  global qb qs qa
  global minZ maxZ z1 z2 BestAnomaly
  global Best_q Best_A Best_z Best_Theta ModAxes RMS Best_x0 Best_RMS
  global edit_cc edit_mm edit_nn edit_pp
  global edit_qq edit_AA edit_zz edit_TT 
  global edit_xx edit_xxb edit_xxs
  global RB_all RB_best smax
  global RMS_Axes Depth_Axes A_Axes T_Axes
  global ddx xmm
  global RMS1 D11 D1 A11 A1 T11 T1 X11 X1 tson ttson sson 
  global RMS_It D11_It A11_It T11_It  X11_It 
  global  xxx yyy Eps

      A_itt=[];
      theta_itt=[];
      dep_itt=[];
      qq=[]; qq2=[];
      D11=[];X1=[];A11=[];T11=[];
      S1=[];D1=[];X1=[];A1=[];T1=[];RMS1=[];
      S2=[];D2=[];X2=[];A2=[];T2=[];RMS2=[];
      S3=[];D3=[];X3=[];A3=[];T3=[];RMS3=[];

      rmss=[];
      R1_min=[];R1_ind=[];
      RR=[];RMS_It=[];D11_It=[];A11_It=[];T11_It=[];X11_It=[];
  cla(ModAxes);
  axes(ModAxes);
    plot(xmm,Vc,'ko','markerfacecolor','r','Markersize',4,'linewidth',1)
  drawnow

  t=0;
  qm=qb:qa:qs;
  cmap=cool(length(qm));
  cmap=hsv(length(qm));
  rms=[];
  Ns=fix(nData/2);
        ddx=abs(x(2)-x(1));

  for q=qb:qa:qs
    t=t+1;
    tt=0;

    R1=[];R2=[];R2_min=[];R2_ind=[];
for xm=xb:ddx:xs
      A_itt=[];
      theta_itt=[];
      dep_itt=[];
  tt=tt+1;
    for s=1:smax
      for i=1:nData
       x=xmm-xm; 
        if x(i)<=0.1;Vo=Vc(i);end
        if abs(x(i)-s*ddx)<=0.1;Vps=Vc(i);end
        if abs(x(i)+s*ddx)<=0.1;Vms=Vc(i);end
      end
      vv=inf;
      F=Vps/Vms;

      z1=minZ;
      z2=maxZ;
      ss=0;
      sum1=0;sum2=0;
      while(vv>Eps)
        ss=ss+1;
        dep=CalcZ(nData,x,Vc,Vo,z1,q,s,F,sum1,sum2);
        vv=abs(z1/dep-1);
        z1=dep;
        if ss==1000;break;end
      end
      [AAC,theta,th11]=CalcA(Vo,dep,s,q,c,m,p,F,GR) ;
      A_itt(s)=AAC;
      theta_itt(s)=theta;
      dep_itt(s)=dep;
      x=xmm-xm;
      qq(t,tt,s)=q;
      S1(t,tt,s)=s;
      SS1(t,tt,s)=ss;

      X1(t,tt,s)=xm;
      D1(t,tt,s)=mean(dep_itt);
      A1(t,tt,s)=mean(A_itt);
      T1(t,tt,s)=mean(theta_itt);
      D11(t,tt,s)=dep;
      T11(t,tt,s)=theta;
      A11(t,tt,s)=AAC;
[Vcal1] = CalcAno( nData,x,mean(dep_itt),mean(A_itt),mean(theta_itt),mean(theta_itt)*pi/180,q,c,m,n,p,GR );
      res=(Vc'-Vcal1');
      E=((res'*res)/nData);
      rmss(t,s)=sqrt(E);
      %R(t,tt,s)=sqrt(E);
      R1(tt,s)=sqrt(E);
      RMS1(t,tt,s)=sqrt(E);
    end
      [fobj_min,ind_s] = min(R1(tt,:));
      R2_min(tt)=fobj_min;
      R2_ind(tt)=ind_s;
      x=xmm-X1(t,tt,ind_s);
      [Vcal1] = CalcAno( nData,x,D1(t,tt,ind_s),A1(t,tt,ind_s),T1(t,tt,ind_s),T1(t,tt,ind_s)*pi/180,S1(t,tt,ind_s),c,m,n,p,GR );
end
tt_son=tt;
[fobj_min,ind_tt] = min(R2_min);
RR(t)=R2_min(ind_tt);
qq(t)=q;

  end
  t_son=t;
   
Best_RMS=min(min(min( RMS1)));

          for t=1:t_son
            for tt=1:tt_son
              for s=1:smax
                if Best_RMS==RMS1(t,tt,s)
                  tson=t;
                  ttson=tt;
                  sson=s;
                  ss_son= SS1(t,tt,s);
                  Best_z=D1(t,tt,s);
                  Best_x0=X1(t,tt,s);
                  Best_A=A1(t,tt,s);
                  Best_Theta=T1(t,tt,s);
                  Best_q=qq(t,tt,s);
                    break
                  
                end
              end
            end
          end

x=xmm-Best_x0;

  txt = sprintf('%2.2f', Best_q);set(edit_qq,'String',txt);
  txt = sprintf('%7.2f', Best_A);set(edit_AA,'String',txt);
  txt = sprintf('%5.2f', Best_z);set(edit_zz,'String',txt);
  txt = sprintf('%5.2f', Best_Theta);set(edit_TT,'String',txt);
  txt = sprintf('%7.3f', Best_RMS);set(RMS,'String',txt);
  txt = sprintf('%7.2f', Best_x0);set(edit_xx,'String',txt);

x=xmm;%+Best_x0;
  

for t=1:t_son
           x=xmm-Best_x0;
if get(RB_all, 'Value')==1;
    [Vcal2] = CalcAno( nData,x,D1(t,ttson,sson),A1(t,ttson,sson),T1(t,ttson,sson),T1(t,ttson,sson)*pi/180,qq(t,ttson,sson),c,m,n,p,GR );

      hold on;  plot(xmm,Vcal2','color',[cmap(t,1) cmap(t,2) cmap(t,3)])
    end
end
    [ BestAnomaly] = CalcAno( nData,x,Best_z,Best_A,Best_Theta,Best_Theta*pi/180,Best_q,c,m,n,p,GR );
     hold on;plot(xmm,BestAnomaly','b','linewidth',3)
  hold on;plot(xmm,Vc,'ko','markerfacecolor','r','Markersize',5,'linewidth',1)

     xlim([min(xmm) max(xmm)])

           RMS1(tson,ttson,:);
%%
  X11_It(:,1)=X1(tson,ttson,:);

  cla(RMS_Axes);
  axes(RMS_Axes);
  for i=1:smax
    mx(i)=i;
  end
  RMS_It(:,1)=RMS1(tson,ttson,:);
  plot(RMS_It,'b','linewidth',1);hold on
yTicks = get(gca,'ytick');
  semilogy(sson,RMS1(tson,ttson,sson),'go','linewidth',1);hold on
  xlabel('s');
  if GR==1;ylabel('RMS (mGal)');else;ylabel('RMS (mV)');end
%% 
  cla(Depth_Axes);
  axes(Depth_Axes);
  D11_It(:,1)=D11(tson,ttson,:);
  for i=1:smax
    mx(i)=i;
    my(i)=mean(D11_It(1:i,1));
  end
  plot(D11_It,'b','linewidth',1);hold on
  plot(mx,my,'r','linewidth',1);hold on
  plot(sson,D1(tson,ttson,sson),'go','linewidth',1);hold on
  xlabel('s');
  ylabel('Depth (km)');
%%
  cla(A_Axes);
  axes(A_Axes);
  A11_It(:,1)=A11(tson,ttson,:);
  plot(A11_It,'b','linewidth',1);hold on
  for i=1:smax
    mx(i)=i;
    my(i)=mean(A11(tson,ttson,1:i));
  end
  plot(mx,my,'r','linewidth',1);hold on
  plot(sson,A1(tson,ttson,sson),'go','linewidth',1);hold on
  plot(mx(sson),my(sson),'go','linewidth',1);hold on
if GR==1;ylabel('K (mGal. m^(^2^q^-^1^))');end
if GR==0;ylabel('K (mV. m^(^2^q^-^1^))');end
  xlabel('s');
  %%
  cla(T_Axes);
  axes(T_Axes);
      T11_It(:,1)=T11(tson,ttson,:);

  plot(T11_It,'b','linewidth',1);hold on
  for i=1:smax
    mx(i)=i;
    my(i)=mean(T11_It(1:i,1));
  end
  plot(mx,my,'r','linewidth',1);hold on
  plot(sson,T1(tson,ttson,sson),'go','linewidth',1);hold on
  plot(mx(sson),my(sson),'go','linewidth',1);hold on

  xlabel('s');
  ylabel('{\theta} (^o)');


%fprintf('iter=%6d  s=%6d\n',ss_son,sson)
%%
   function [ ]=Bisection()
  global GR xb xs;
  global c m n p;
  global q A z Theta;
  global nData x dx Vc  F
  global qb qs qa
  global minZ maxZ z1 z2 BestAnomaly
  global Best_q Best_A Best_z Best_Theta ModAxes RMS Best_x0 Best_RMS
  global edit_cc edit_mm edit_nn edit_pp
  global edit_qq edit_AA edit_zz edit_TT 
  global edit_xx edit_xxb edit_xxs
  global RB_all RB_best smax
  global RMS_Axes Depth_Axes A_Axes T_Axes
  global ddx xmm
  global RMS1 D11 D1 A11 A1 T11 T1 X11 X1 tson ttson sson 
  global RMS_It D11_It A11_It T11_It  X11_It 
  global  xxx yyy Eps
      A_itt=[];
      theta_itt=[];
      dep_itt=[];
      qq=[]; qq2=[];
      D11=[];X1=[];A11=[];T11=[];
      S1=[];D1=[];X1=[];A1=[];T1=[];RMS1=[];
      S2=[];D2=[];X2=[];A2=[];T2=[];RMS2=[];
      S3=[];D3=[];X3=[];A3=[];T3=[];RMS3=[];

      rmss=[];
      R1_min=[];R1_ind=[];
      RR=[];RMS_It=[];D11_It=[];A11_It=[];T11_It=[];X11_It=[];
  cla(ModAxes);
  axes(ModAxes);
    plot(xmm,Vc,'ko','markerfacecolor','r','Markersize',4,'linewidth',1)
  drawnow

  t=0;
  qm=qb:qa:qs;
  cmap=cool(length(qm));
  cmap=hsv(length(qm));
  rms=[];
  Ns=fix(nData/2);
  ddx=abs(x(2)-x(1));

  for q=qb:qa:qs
    t=t+1;
    tt=0;

    R1=[];R2=[];R2_min=[];R2_ind=[];
for xm=xb:ddx:xs
      A_itt=[];
      theta_itt=[];
      dep_itt=[];
  tt=tt+1;
       for s=1:smax
         for i=1:nData
       x=xmm-xm; 
        if x(i)<=0.1;Vo=Vc(i);end
        if abs(x(i)-s*ddx)<=0.1;Vps=Vc(i);end
        if abs(x(i)+s*ddx)<=0.1;Vms=Vc(i);end
         end
       vv=inf;
         F=Vps/Vms;
    z1=minZ;
    z2=maxZ;
         
         ss=0;
         sum1=0;sum2=0;
         sum11=0;sum22=0;
         dep11=CalcZ(nData,x,Vc,Vo,z1,q,s,F,sum1,sum2);
         dep22=CalcZ(nData,x,Vc,Vo,z2,q,s,F,sum1,sum2);
         dep33=(dep11+dep22)/2;
         
         z11=z2;
         dep1=z1;
         dep2=z2;
         while(vv>Eps)
           ss=ss+1;
           dep1=CalcZ(nData,x,Vc,Vo,z1,q,s,F,sum1,sum2);
           dep2=CalcZ(nData,x,Vc,Vo,z2,q,s,F,sum1,sum2);
           dep3=(dep1+dep2)/2;
           [AAC_1,theta_1,th11_1]=CalcA(Vo,dep1,s,q,c,m,p,F,GR) ;
           [AAC_2,theta_2,th11_2]=CalcA(Vo,dep2,s,q,c,m,p,F,GR) ;
           [AAC_3,theta_3,th11_3]=CalcA(Vo,dep3,s,q,c,m,p,F,GR) ;
           
           [Vcal1] = CalcAno( nData,x,dep1,AAC_1,theta_1,th11_1,q,c,m,n,p,GR );
           [Vcal2] = CalcAno( nData,x,dep2,AAC_2,theta_2,th11_2,q,c,m,n,p,GR );
           [Vcal3] = CalcAno( nData,x,dep3,AAC_3,theta_3,th11_3,q,c,m,n,p,GR );
           rms_1=sum((Vc-Vcal1))/nData;
           rms_2=sum((Vc-Vcal2))/nData;
           rms_3=sum((Vc-Vcal3))/nData;
           if (rms_3*rms_1 < 0)
             dep2 = dep3;
             z2=dep3;
             vv=abs(rms_3);
           else
             dep1 = dep3;
             vv=abs(rms_3);
             z1=dep3;
           end
           vv=abs(z11/dep3-1);
           z11=dep3;
           sss=ss;
           sm(s,ss)=dep3;
           smson(s)=ss;
                   if ss==1000;break;end

         end
      [AAC,theta,th11]=CalcA(Vo,dep3,s,q,c,m,p,F,GR) ;
      A_itt(s)=AAC;
      theta_itt(s)=theta;
      dep_itt(s)=dep3;

      x=xmm-xm;
      qq(t,tt,s)=q;
      S1(t,tt,s)=s;
            SS1(t,tt,s)=ss;

      X1(t,tt,s)=xm;
      D1(t,tt,s)=mean(dep_itt);
      A1(t,tt,s)=mean(A_itt);
      T1(t,tt,s)=mean(theta_itt);
      D11(t,tt,s)=dep3;
      T11(t,tt,s)=theta;
      A11(t,tt,s)=AAC;

[Vcal1] = CalcAno( nData,x,mean(dep_itt),mean(A_itt),mean(theta_itt),mean(theta_itt)*pi/180,q,c,m,n,p,GR );
      res=(Vc'-Vcal1');
      E=((res'*res)/nData);
      rmss(t,s)=sqrt(E);
      R1(tt,s)=sqrt(E);
      RMS1(t,tt,s)=sqrt(E);
       end
      [fobj_min,ind_s] = min(R1(tt,:));
      R2_min(tt)=fobj_min;
      R2_ind(tt)=ind_s;
      x=xmm-X1(t,tt,ind_s);
      [Vcal1] = CalcAno( nData,x,D1(t,tt,ind_s),A1(t,tt,ind_s),T1(t,tt,ind_s),T1(t,tt,ind_s)*pi/180,S1(t,tt,ind_s),c,m,n,p,GR );
end
tt_son=tt;
[fobj_min,ind_tt] = min(R2_min);
RR(t)=R2_min(ind_tt);
qq(t)=q;

  end
  t_son=t;
 
Best_RMS=min(min(min( RMS1)));

          for t=1:t_son
            for tt=1:tt_son
              for s=1:smax
                if Best_RMS==RMS1(t,tt,s)
                  tson=t;
                  ttson=tt;
                  sson=s;
                  ss_son= SS1(t,tt,s);

                  Best_z=D1(t,tt,s);
                  Best_x0=X1(t,tt,s);
                  Best_A=A1(t,tt,s);
                  Best_Theta=T1(t,tt,s);
                  Best_q=qq(t,tt,s);
                    break
                  
                end
              end
            end
          end
x=xmm-Best_x0;

  
  txt = sprintf('%2.2f', Best_q);set(edit_qq,'String',txt);
  txt = sprintf('%7.2f', Best_A);set(edit_AA,'String',txt);
  txt = sprintf('%5.2f', Best_z);set(edit_zz,'String',txt);
  txt = sprintf('%5.2f', Best_Theta);set(edit_TT,'String',txt);
  txt = sprintf('%7.3f', Best_RMS);set(RMS,'String',txt);
  txt = sprintf('%7.2f', Best_x0);set(edit_xx,'String',txt);

x=xmm;%+Best_x0;
  

for t=1:t_son
           x=xmm-Best_x0;
if get(RB_all, 'Value')==1;
    [Vcal2] = CalcAno( nData,x,D1(t,ttson,sson),A1(t,ttson,sson),T1(t,ttson,sson),T1(t,ttson,sson)*pi/180,qq(t,ttson,sson),c,m,n,p,GR );

      hold on;  plot(xmm,Vcal2','color',[cmap(t,1) cmap(t,2) cmap(t,3)])
    end
end
    [ BestAnomaly] = CalcAno( nData,x,Best_z,Best_A,Best_Theta,Best_Theta*pi/180,Best_q,c,m,n,p,GR );
     hold on;plot(xmm,BestAnomaly','b','linewidth',3)
  hold on;plot(xmm,Vc,'ko','markerfacecolor','r','Markersize',5,'linewidth',1)

     xlim([min(xmm) max(xmm)])
           RMS1(tson,ttson,:);
%%
  X11_It(:,1)=X1(tson,ttson,:);

  cla(RMS_Axes);
  axes(RMS_Axes);
  for i=1:smax
    mx(i)=i;
  end
  RMS_It(:,1)=RMS1(tson,ttson,:);
  plot(RMS_It,'b','linewidth',1);hold on
yTicks = get(gca,'ytick');
  semilogy(sson,RMS1(tson,ttson,sson),'go','linewidth',1);hold on
  xlabel('S');
  if GR==1;ylabel('RMS (mGal)');else;ylabel('RMS (mV)');end
%% 
  cla(Depth_Axes);
  axes(Depth_Axes);
  D11_It(:,1)=D11(tson,ttson,:);
  for i=1:smax
    mx(i)=i;
    my(i)=mean(D11_It(1:i,1));
  end
  plot(D11_It,'b','linewidth',1);hold on
  plot(mx,my,'r','linewidth',1);hold on
  plot(sson,D1(tson,ttson,sson),'go','linewidth',1);hold on
  xlabel('S');
  ylabel('Depth (km)');
%%
  cla(A_Axes);
  axes(A_Axes);
  A11_It(:,1)=A11(tson,ttson,:);
  plot(A11_It,'b','linewidth',1);hold on
  for i=1:smax
    mx(i)=i;
    my(i)=mean(A11(tson,ttson,1:i));
  end
  plot(mx,my,'r','linewidth',1);hold on
  plot(sson,A1(tson,ttson,sson),'go','linewidth',1);hold on
  plot(mx(sson),my(sson),'go','linewidth',1);hold on

  xlabel('S');
  %%
  cla(T_Axes);
  axes(T_Axes);
      T11_It(:,1)=T11(tson,ttson,:);

  plot(T11_It,'b','linewidth',1);hold on
  for i=1:smax
    mx(i)=i;
    my(i)=mean(T11_It(1:i,1));
  end
  plot(mx,my,'r','linewidth',1);hold on
  plot(sson,T1(tson,ttson,sson),'go','linewidth',1);hold on
  plot(mx(sson),my(sson),'go','linewidth',1);hold on

  xlabel('S');
  ylabel('{\theta} (^o)');
% fprintf('iter=%6d  s=%6d\n',ss_son,sson)
%%
 function [ ]=Regula()

  global GR xb xs;
  global c m n p;
  global q A z Theta;
  global nData x dx Vc  F
  global qb qs qa
  global minZ maxZ z1 z2 BestAnomaly
  global Best_q Best_A Best_z Best_Theta ModAxes RMS Best_x0 Best_RMS
  global edit_cc edit_mm edit_nn edit_pp
  global edit_qq edit_AA edit_zz edit_TT 
  global edit_xx edit_xxb edit_xxs
  global RB_all RB_best smax
  global RMS_Axes Depth_Axes A_Axes T_Axes
  global ddx xmm
  global RMS1 D11 D1 A11 A1 T11 T1 X11 X1 tson ttson sson 
  global RMS_It D11_It A11_It T11_It  X11_It 
  global  xxx yyy Eps
      A_itt=[];
      theta_itt=[];
      dep_itt=[];
      qq=[]; qq2=[];
      D11=[];X1=[];A11=[];T11=[];
      S1=[];D1=[];X1=[];A1=[];T1=[];RMS1=[];
      S2=[];D2=[];X2=[];A2=[];T2=[];RMS2=[];
      S3=[];D3=[];X3=[];A3=[];T3=[];RMS3=[];

      rmss=[];
      R1_min=[];R1_ind=[];
      RR=[];RMS_It=[];D11_It=[];A11_It=[];T11_It=[];X11_It=[];
  cla(ModAxes);
  axes(ModAxes);
    plot(xmm,Vc,'ko','markerfacecolor','r','Markersize',4,'linewidth',1)
  drawnow

  t=0;
  qm=qb:qa:qs;
  cmap=cool(length(qm));
  cmap=hsv(length(qm));
  rms=[];
  Ns=fix(nData/2);
  ddx=abs(x(2)-x(1));

  for q=qb:qa:qs
    t=t+1;
    tt=0;

    R1=[];R2=[];R2_min=[];R2_ind=[];
for xm=xb:ddx:xs
      A_itt=[];
      theta_itt=[];
      dep_itt=[];
  tt=tt+1;
       for s=1:smax
         for i=1:nData
       x=xmm-xm; 
        if x(i)<=0.1;Vo=Vc(i);end
        if abs(x(i)-s*ddx)<=0.1;Vps=Vc(i);end
        if abs(x(i)+s*ddx)<=0.1;Vms=Vc(i);end
         end
       vv=inf;
         F=Vps/Vms;
    z1=minZ;
    z2=maxZ;

    ss=0;
    sum1=0;sum2=0;
    sum11=0;sum22=0;
      dep11=CalcZ(nData,x,Vc,Vo,z1,q,s,F,sum1,sum2);
      dep22=CalcZ(nData,x,Vc,Vo,z2,q,s,F,sum1,sum2);
      dep33=(dep11+dep22)/2;
z11=z2;
dep1=z1;
dep2=z2;
    while(vv>Eps)
      ss=ss+1;

      dep1=CalcZ(nData,x,Vc,Vo,z1,q,s,F,sum1,sum2);
      dep2=CalcZ(nData,x,Vc,Vo,z2,q,s,F,sum1,sum2);
    
    [AAC_1,theta_1,th11_1]=CalcA(Vo,dep1,s,q,c,m,p,F,GR) ;  
    [AAC_2,theta_2,th11_2]=CalcA(Vo,dep2,s,q,c,m,p,F,GR) ;   

    [Vcal1] = CalcAno( nData,x,dep1,AAC_1,theta_1,th11_1,q,c,m,n,p,GR );
    [Vcal2] = CalcAno( nData,x,dep2,AAC_2,theta_2,th11_2,q,c,m,n,p,GR );
    rms_1=sum((Vc-Vcal1))/nData;
    rms_2=sum((Vc-Vcal2))/nData;

     dep3 = (dep1*rms_2-dep2*rms_1)/(rms_2 - rms_1);
     [AAC_3,theta_3,th11_3]=CalcA(Vo,dep3,s,q,c,m,p,F,GR) ;   
     [Vcal3] = CalcAno( nData,x,dep3,AAC_3,theta_3,th11_3,q,c,m,n,p,GR );
     rms_3=sum((Vc-Vcal3))/nData;

  if (rms_3*rms_1 < 0)
        dep2 = dep3;
        z2=dep3;
        vv=abs(rms_3);
    else 
        dep1 = dep3;
        vv=abs(rms_3);
        z1=dep3;
    end
      vv=abs(z11/dep3-1);
z11=dep3;
sss=ss;
           sm(s,ss)=dep3;
           smson(s)=ss;
                   if ss==1000;break;end

   end
      [AAC,theta,th11]=CalcA(Vo,dep3,s,q,c,m,p,F,GR) ;
      A_itt(s)=AAC;
      theta_itt(s)=theta;
      dep_itt(s)=dep3;

      x=xmm-xm;
      qq(t,tt,s)=q;
      S1(t,tt,s)=s;
            SS1(t,tt,s)=ss;

      X1(t,tt,s)=xm;
      D1(t,tt,s)=mean(dep_itt);
      A1(t,tt,s)=mean(A_itt);
      T1(t,tt,s)=mean(theta_itt);
      D11(t,tt,s)=dep3;
      T11(t,tt,s)=theta;
      A11(t,tt,s)=AAC;
[Vcal1] = CalcAno( nData,x,mean(dep_itt),mean(A_itt),mean(theta_itt),mean(theta_itt)*pi/180,q,c,m,n,p,GR );
      res=(Vc'-Vcal1');
      E=((res'*res)/nData);
      rmss(t,s)=sqrt(E);
      R1(tt,s)=sqrt(E);
      RMS1(t,tt,s)=sqrt(E);
       end
      [fobj_min,ind_s] = min(R1(tt,:));
      R2_min(tt)=fobj_min;
      R2_ind(tt)=ind_s;
      x=xmm-X1(t,tt,ind_s);
      [Vcal1] = CalcAno( nData,x,D1(t,tt,ind_s),A1(t,tt,ind_s),T1(t,tt,ind_s),T1(t,tt,ind_s)*pi/180,S1(t,tt,ind_s),c,m,n,p,GR );
end
tt_son=tt;
[fobj_min,ind_tt] = min(R2_min);
RR(t)=R2_min(ind_tt);
qq(t)=q;
  end
  t_son=t;
Best_RMS=min(min(min( RMS1)));

          for t=1:t_son
            for tt=1:tt_son
              for s=1:smax
                if Best_RMS==RMS1(t,tt,s)
                  tson=t;
                  ttson=tt;
                  sson=s;
                  ss_son= SS1(t,tt,s);

                  Best_z=D1(t,tt,s);
                  Best_x0=X1(t,tt,s);
                  Best_A=A1(t,tt,s);
                  Best_Theta=T1(t,tt,s);
                  Best_q=qq(t,tt,s);
                    break
                  
                end
              end
            end
          end
x=xmm-Best_x0;

  
  txt = sprintf('%2.2f', Best_q);set(edit_qq,'String',txt);
  txt = sprintf('%7.2f', Best_A);set(edit_AA,'String',txt);
  txt = sprintf('%5.2f', Best_z);set(edit_zz,'String',txt);
  txt = sprintf('%5.2f', Best_Theta);set(edit_TT,'String',txt);
  txt = sprintf('%7.3f', Best_RMS);set(RMS,'String',txt);
  txt = sprintf('%7.2f', Best_x0);set(edit_xx,'String',txt);
x=xmm;%+Best_x0;
  

for t=1:t_son
           x=xmm-Best_x0;
if get(RB_all, 'Value')==1;
    [Vcal2] = CalcAno( nData,x,D1(t,ttson,sson),A1(t,ttson,sson),T1(t,ttson,sson),T1(t,ttson,sson)*pi/180,qq(t,ttson,sson),c,m,n,p,GR );

      hold on;  plot(xmm,Vcal2','color',[cmap(t,1) cmap(t,2) cmap(t,3)])
    end
end
    [ BestAnomaly] = CalcAno( nData,x,Best_z,Best_A,Best_Theta,Best_Theta*pi/180,Best_q,c,m,n,p,GR );
     hold on;plot(xmm,BestAnomaly','b','linewidth',3)
  hold on;plot(xmm,Vc,'ko','markerfacecolor','r','Markersize',5,'linewidth',1)

     xlim([min(xmm) max(xmm)])
           RMS1(tson,ttson,:);
%%
  X11_It(:,1)=X1(tson,ttson,:);

  cla(RMS_Axes);
  axes(RMS_Axes);
  for i=1:smax
    mx(i)=i;
  end
  RMS_It(:,1)=RMS1(tson,ttson,:);
  plot(RMS_It,'b','linewidth',1);hold on
yTicks = get(gca,'ytick');
  semilogy(sson,RMS1(tson,ttson,sson),'go','linewidth',1);hold on
  xlabel('S');
  if GR==1;ylabel('RMS (mGal)');else;ylabel('RMS (mV)');end
%% 
  cla(Depth_Axes);
  axes(Depth_Axes);
  D11_It(:,1)=D11(tson,ttson,:);
  for i=1:smax
    mx(i)=i;
    my(i)=mean(D11_It(1:i,1));
  end
  plot(D11_It,'b','linewidth',1);hold on
  plot(mx,my,'r','linewidth',1);hold on
  plot(sson,D1(tson,ttson,sson),'go','linewidth',1);hold on
  xlabel('S');
  ylabel('Depth (km)');
%%
  cla(A_Axes);
  axes(A_Axes);
  A11_It(:,1)=A11(tson,ttson,:);
  plot(A11_It,'b','linewidth',1);hold on
  for i=1:smax
    mx(i)=i;
    my(i)=mean(A11(tson,ttson,1:i));
  end
  plot(mx,my,'r','linewidth',1);hold on
  plot(sson,A1(tson,ttson,sson),'go','linewidth',1);hold on
  plot(mx(sson),my(sson),'go','linewidth',1);hold on

  xlabel('S');
  %%
  cla(T_Axes);
  axes(T_Axes);
      T11_It(:,1)=T11(tson,ttson,:);

  plot(T11_It,'b','linewidth',1);hold on
  for i=1:smax
    mx(i)=i;
    my(i)=mean(T11_It(1:i,1));
  end
  plot(mx,my,'r','linewidth',1);hold on
  plot(sson,T1(tson,ttson,sson),'go','linewidth',1);hold on
  plot(mx(sson),my(sson),'go','linewidth',1);hold on

  xlabel('S');
  ylabel('{\theta} (^o)');
% fprintf('iter=%6d  s=%6d\n',ss_son,sson)
%%
 function [ ]=Secant()

  global GR xb xs;
  global c m n p;
  global q A z Theta;
  global nData x dx Vc  F
  global qb qs qa
  global minZ maxZ z1 z2 BestAnomaly
  global Best_q Best_A Best_z Best_Theta ModAxes RMS Best_x0 Best_RMS
  global edit_cc edit_mm edit_nn edit_pp
  global edit_qq edit_AA edit_zz edit_TT 
  global edit_xx edit_xxb edit_xxs
  global RB_all RB_best smax
  global RMS_Axes Depth_Axes A_Axes T_Axes
  global ddx xmm
  global RMS1 D11 D1 A11 A1 T11 T1 X11 X1 tson ttson sson 
  global RMS_It D11_It A11_It T11_It  X11_It 
  global  xxx yyy Eps
      A_itt=[];
      theta_itt=[];
      dep_itt=[];
      qq=[]; qq2=[];
      D11=[];X1=[];A11=[];T11=[];
      S1=[];D1=[];X1=[];A1=[];T1=[];RMS1=[];
      S2=[];D2=[];X2=[];A2=[];T2=[];RMS2=[];
      S3=[];D3=[];X3=[];A3=[];T3=[];RMS3=[];

      rmss=[];
      R1_min=[];R1_ind=[];
      RR=[];RMS_It=[];D11_It=[];A11_It=[];T11_It=[];X11_It=[];
  cla(ModAxes);
  axes(ModAxes);
    plot(xmm,Vc,'ko','markerfacecolor','r','Markersize',4,'linewidth',1)
  drawnow

  t=0;
  qm=qb:qa:qs;
  cmap=cool(length(qm));
  cmap=hsv(length(qm));
  rms=[];
  Ns=fix(nData/2);
  ddx=abs(x(2)-x(1));

  for q=qb:qa:qs
    t=t+1;
    tt=0;

    R1=[];R2=[];R2_min=[];R2_ind=[];
for xm=xb:ddx:xs
      A_itt=[];
      theta_itt=[];
      dep_itt=[];
  tt=tt+1;
       for s=1:smax
         for i=1:nData
       x=xmm-xm; 
        if x(i)<=0.1;Vo=Vc(i);end
        if abs(x(i)-s*ddx)<=0.1;Vps=Vc(i);end
        if abs(x(i)+s*ddx)<=0.1;Vms=Vc(i);end
         end
       vv=inf;
         F=Vps/Vms;
     z1=minZ;
    z2=maxZ;
   
    ss=0;
    sum1=0;sum2=0;
    sum11=0;sum22=0;
    z11=z1;
    dep1=z1;
    dep2=z2;
    dx = inf;
      [AAC_1,theta_1,th11_1]=CalcA(Vo,dep1,s,q,c,m,p,F,GR) ;
      [Vcal1] = CalcAno( nData,x,dep1,AAC_1,theta_1,th11_1,q,c,m,n,p,GR );
      res=(Vc'-Vcal1'); rms_1=sqrt((res'*res)/nData);
      rms_1=sum((Vc'-Vcal1'))/nData;
      [AAC_2,theta_2,th11_2]=CalcA(Vo,dep2,s,q,c,m,p,F,GR) ;
      [Vcal2] = CalcAno( nData,x,dep2,AAC_2,theta_2,th11_2,q,c,m,n,p,GR );
      res=(Vc'-Vcal2'); rms_2=sqrt((res'*res)/nData);
      rms_2=sum((Vc'-Vcal2'))/nData;
    while(vv>Eps)
      ss=ss+1;
      dx = (dep2 - dep1)*rms_2/(rms_2 - rms_1);
      dep3 = (dep2 - dx);
     [AAC_3,theta_3,th11_3]=CalcA(Vo,dep3,s,q,c,m,p,F,GR) ;
      [Vcal3] = CalcAno( nData,x,dep3,AAC_3,theta_3,th11_3,q,c,m,n,p,GR );
      res=(Vc'-Vcal3'); rms_3=sqrt((res'*res)/nData);
      rms_3=sum((Vc'-Vcal3'))/nData;
      dep1 = dep2;
      rms_1 = rms_2;
      dep2 = dep3;
      rms_2 = rms_3;
      vv=abs(z11/dep3-1);
      z11=dep3;
      sss=ss;
        sm(s,ss)=dep3;
        smson(s)=ss;
                if ss==1000;break;end

    end
      [AAC,theta,th11]=CalcA(Vo,dep3,s,q,c,m,p,F,GR) ;
      A_itt(s)=AAC;
      theta_itt(s)=theta;
      dep_itt(s)=dep3;

      x=xmm-xm;
      qq(t,tt,s)=q;
      S1(t,tt,s)=s;
            SS1(t,tt,s)=ss;

      X1(t,tt,s)=xm;
      D1(t,tt,s)=mean(dep_itt);
      A1(t,tt,s)=mean(A_itt);
      T1(t,tt,s)=mean(theta_itt);
      D11(t,tt,s)=dep3;
      T11(t,tt,s)=theta;
      A11(t,tt,s)=AAC;
[Vcal1] = CalcAno( nData,x,mean(dep_itt),mean(A_itt),mean(theta_itt),mean(theta_itt)*pi/180,q,c,m,n,p,GR );
      res=(Vc'-Vcal1');
      E=((res'*res)/nData);
      rmss(t,s)=sqrt(E);
      R1(tt,s)=sqrt(E);
      RMS1(t,tt,s)=sqrt(E);
       end
      [fobj_min,ind_s] = min(R1(tt,:));
      R2_min(tt)=fobj_min;
      R2_ind(tt)=ind_s;
      x=xmm-X1(t,tt,ind_s);
      [Vcal1] = CalcAno( nData,x,D1(t,tt,ind_s),A1(t,tt,ind_s),T1(t,tt,ind_s),T1(t,tt,ind_s)*pi/180,S1(t,tt,ind_s),c,m,n,p,GR );
end
tt_son=tt;
[fobj_min,ind_tt] = min(R2_min);
RR(t)=R2_min(ind_tt);
qq(t)=q;
  end
  t_son=t;
Best_RMS=min(min(min( RMS1)));

          for t=1:t_son
            for tt=1:tt_son
              for s=1:smax
                if Best_RMS==RMS1(t,tt,s)
                  tson=t;
                  ttson=tt;
                  sson=s;
                  ss_son= SS1(t,tt,s);

                  Best_z=D1(t,tt,s);
                  Best_x0=X1(t,tt,s);
                  Best_A=A1(t,tt,s);
                  Best_Theta=T1(t,tt,s);
                  Best_q=qq(t,tt,s);
                    break
                  
                end
              end
            end
          end
x=xmm-Best_x0;

  
  txt = sprintf('%2.2f', Best_q);set(edit_qq,'String',txt);
  txt = sprintf('%7.2f', Best_A);set(edit_AA,'String',txt);
  txt = sprintf('%5.2f', Best_z);set(edit_zz,'String',txt);
  txt = sprintf('%5.2f', Best_Theta);set(edit_TT,'String',txt);
  txt = sprintf('%7.3f', Best_RMS);set(RMS,'String',txt);
  txt = sprintf('%7.2f', Best_x0);set(edit_xx,'String',txt);

x=xmm;%+Best_x0;
  

for t=1:t_son
           x=xmm-Best_x0;

if get(RB_all, 'Value')==1;
    [Vcal2] = CalcAno( nData,x,D1(t,ttson,sson),A1(t,ttson,sson),T1(t,ttson,sson),T1(t,ttson,sson)*pi/180,qq(t,ttson,sson),c,m,n,p,GR );

      hold on;  plot(xmm,Vcal2','color',[cmap(t,1) cmap(t,2) cmap(t,3)])
    end
end
    [ BestAnomaly] = CalcAno( nData,x,Best_z,Best_A,Best_Theta,Best_Theta*pi/180,Best_q,c,m,n,p,GR );
     hold on;plot(xmm,BestAnomaly','b','linewidth',3)
  hold on;plot(xmm,Vc,'ko','markerfacecolor','r','Markersize',5,'linewidth',1)

     xlim([min(xmm) max(xmm)])

           RMS1(tson,ttson,:);
%%
  X11_It(:,1)=X1(tson,ttson,:);

  cla(RMS_Axes);
  axes(RMS_Axes);
  for i=1:smax
    mx(i)=i;
  end
  RMS_It(:,1)=RMS1(tson,ttson,:);
  plot(RMS_It,'b','linewidth',1);hold on
yTicks = get(gca,'ytick');
  semilogy(sson,RMS1(tson,ttson,sson),'go','linewidth',1);hold on
  xlabel('S');
  if GR==1;ylabel('RMS (mGal)');else;ylabel('RMS (mV)');end
%% 
  cla(Depth_Axes);
  axes(Depth_Axes);
  D11_It(:,1)=D11(tson,ttson,:);
  for i=1:smax
    mx(i)=i;
    my(i)=mean(D11_It(1:i,1));
  end
  plot(D11_It,'b','linewidth',1);hold on
  plot(mx,my,'r','linewidth',1);hold on
  plot(sson,D1(tson,ttson,sson),'go','linewidth',1);hold on
  xlabel('S');
  ylabel('Depth (km)');
%%
  cla(A_Axes);
  axes(A_Axes);
  A11_It(:,1)=A11(tson,ttson,:);
  plot(A11_It,'b','linewidth',1);hold on
  for i=1:smax
    mx(i)=i;
    my(i)=mean(A11(tson,ttson,1:i));
  end
  plot(mx,my,'r','linewidth',1);hold on
  plot(sson,A1(tson,ttson,sson),'go','linewidth',1);hold on
  plot(mx(sson),my(sson),'go','linewidth',1);hold on

  xlabel('S');
  %%
  cla(T_Axes);
  axes(T_Axes);
      T11_It(:,1)=T11(tson,ttson,:);

  plot(T11_It,'b','linewidth',1);hold on
  for i=1:smax
    mx(i)=i;
    my(i)=mean(T11_It(1:i,1));
  end
  plot(mx,my,'r','linewidth',1);hold on
  plot(sson,T1(tson,ttson,sson),'go','linewidth',1);hold on
  plot(mx(sson),my(sson),'go','linewidth',1);hold on

  xlabel('S');
  ylabel('{\theta} (^o)');
% fprintf('iter=%6d  s=%6d\n',ss_son,sson)
%%
 function [ ]=Steffensen()

  global GR xb xs;
  global c m n p;
  global q A z Theta;
  global nData x dx Vc  F
  global qb qs qa
  global minZ maxZ z1 z2 BestAnomaly
  global Best_q Best_A Best_z Best_Theta ModAxes RMS Best_x0 Best_RMS
  global edit_cc edit_mm edit_nn edit_pp
  global edit_qq edit_AA edit_zz edit_TT 
  global edit_xx edit_xxb edit_xxs
  global RB_all RB_best smax
  global RMS_Axes Depth_Axes A_Axes T_Axes
  global ddx xmm
  global RMS1 D11 D1 A11 A1 T11 T1 X11 X1 tson ttson sson 
  global RMS_It D11_It A11_It T11_It  X11_It 
  global  xxx yyy Eps
      A_itt=[];
      theta_itt=[];
      dep_itt=[];
      qq=[]; qq2=[];
      D11=[];X1=[];A11=[];T11=[];
      S1=[];D1=[];X1=[];A1=[];T1=[];RMS1=[];
      S2=[];D2=[];X2=[];A2=[];T2=[];RMS2=[];
      S3=[];D3=[];X3=[];A3=[];T3=[];RMS3=[];

      rmss=[];
      R1_min=[];R1_ind=[];
      RR=[];RMS_It=[];D11_It=[];A11_It=[];T11_It=[];X11_It=[];
  cla(ModAxes);
  axes(ModAxes);
    plot(xmm,Vc,'ko','markerfacecolor','r','Markersize',4,'linewidth',1)
  drawnow
  t=0;
  qm=qb:qa:qs;
  cmap=cool(length(qm));
  cmap=hsv(length(qm));
  rms=[];
  Ns=fix(nData/2);
  ddx=abs(x(2)-x(1));

  for q=qb:qa:qs
    t=t+1;
    tt=0;

    R1=[];R2=[];R2_min=[];R2_ind=[];
for xm=xb:ddx:xs
      A_itt=[];
      theta_itt=[];
      dep_itt=[];
  tt=tt+1;
       for s=1:smax
         for i=1:nData
       x=xmm-xm; 
        if x(i)<=0.1;Vo=Vc(i);end
        if abs(x(i)-s*ddx)<=0.1;Vps=Vc(i);end
        if abs(x(i)+s*ddx)<=0.1;Vms=Vc(i);end
         end
       vv=inf;
         F=Vps/Vms;
    z1=minZ;
    z2=maxZ;
    dep=z1;
    ss=0;
    sum1=0;sum2=0;
    while(vv>Eps)
      ss=ss+1;
      dep=CalcZ(nData,x,Vc,Vo,z1,q,s,F,sum1,sum2);
      [AAC,theta,th11]=CalcA(Vo,dep,s,q,c,m,p,F,GR) ;
      [Vcal] = CalcAno( nData,x,dep,AAC,theta,th11,q,c,m,n,p,GR );
      h=20;
      rms_x0=(sum((Vc-Vcal))/nData);
      [Vcal1] = CalcAno( nData,x,dep+h,AAC,theta,th11,q,c,m,n,p,GR );

    rms_x00=h*sum((Vc-Vcal1))/nData;
   dep3=abs(dep-(rms_x0^1)/(rms_x00-rms_x0)) ;   
      vv=abs(z1/dep3-1);
      z1=dep3;
      sss=ss;

      if ss>200;break;end
        sm(s,ss)=dep3;
        smson(s)=ss;
        if ss==1000;break;end
    end
      [AAC,theta,th11]=CalcA(Vo,dep3,s,q,c,m,p,F,GR) ;
      A_itt(s)=AAC;
      theta_itt(s)=theta;
      dep_itt(s)=dep3;
      x=xmm-xm;
      qq(t,tt,s)=q;
      S1(t,tt,s)=s;
            SS1(t,tt,s)=ss;

      X1(t,tt,s)=xm;
      D1(t,tt,s)=mean(dep_itt);
      A1(t,tt,s)=mean(A_itt);
      T1(t,tt,s)=mean(theta_itt);
      D11(t,tt,s)=dep3;
      T11(t,tt,s)=theta;
      A11(t,tt,s)=AAC;
[Vcal1] = CalcAno( nData,x,mean(dep_itt),mean(A_itt),mean(theta_itt),mean(theta_itt)*pi/180,q,c,m,n,p,GR );
      res=(Vc'-Vcal1');
      E=((res'*res)/nData);
      rmss(t,s)=sqrt(E);
      R1(tt,s)=sqrt(E);
      RMS1(t,tt,s)=sqrt(E);
       end
      [fobj_min,ind_s] = min(R1(tt,:));
      R2_min(tt)=fobj_min;
      R2_ind(tt)=ind_s;
      x=xmm-X1(t,tt,ind_s);
      [Vcal1] = CalcAno( nData,x,D1(t,tt,ind_s),A1(t,tt,ind_s),T1(t,tt,ind_s),T1(t,tt,ind_s)*pi/180,S1(t,tt,ind_s),c,m,n,p,GR );
end
tt_son=tt;
[fobj_min,ind_tt] = min(R2_min);
RR(t)=R2_min(ind_tt);
qq(t)=q;
  end
  t_son=t;
 
Best_RMS=min(min(min( RMS1)));

          for t=1:t_son
            for tt=1:tt_son
              for s=1:smax
                if Best_RMS==RMS1(t,tt,s)
                  tson=t;
                  ttson=tt;
                  sson=s;
                  ss_son= SS1(t,tt,s);

                  Best_z=D1(t,tt,s);
                  Best_x0=X1(t,tt,s);
                  Best_A=A1(t,tt,s);
                  Best_Theta=T1(t,tt,s);
                  Best_q=qq(t,tt,s);
                    break
                  
                end
              end
            end
          end

x=xmm-Best_x0;

  
  txt = sprintf('%2.2f', Best_q);set(edit_qq,'String',txt);
  txt = sprintf('%7.2f', Best_A);set(edit_AA,'String',txt);
  txt = sprintf('%5.2f', Best_z);set(edit_zz,'String',txt);
  txt = sprintf('%5.2f', Best_Theta);set(edit_TT,'String',txt);
  txt = sprintf('%7.3f', Best_RMS);set(RMS,'String',txt);
  txt = sprintf('%7.2f', Best_x0);set(edit_xx,'String',txt);

x=xmm;%+Best_x0;
  

for t=1:t_son
           x=xmm-Best_x0;
if get(RB_all, 'Value')==1;
    [Vcal2] = CalcAno( nData,x,D1(t,ttson,sson),A1(t,ttson,sson),T1(t,ttson,sson),T1(t,ttson,sson)*pi/180,qq(t,ttson,sson),c,m,n,p,GR );

      hold on;  plot(xmm,Vcal2','color',[cmap(t,1) cmap(t,2) cmap(t,3)])
    end
end
    [ BestAnomaly] = CalcAno( nData,x,Best_z,Best_A,Best_Theta,Best_Theta*pi/180,Best_q,c,m,n,p,GR );
     hold on;plot(xmm,BestAnomaly','b','linewidth',3)
  hold on;plot(xmm,Vc,'ko','markerfacecolor','r','Markersize',5,'linewidth',1)

     xlim([min(xmm) max(xmm)])
           RMS1(tson,ttson,:);
%%
  X11_It(:,1)=X1(tson,ttson,:);

  cla(RMS_Axes);
  axes(RMS_Axes);
  for i=1:smax
    mx(i)=i;
  end
  RMS_It(:,1)=RMS1(tson,ttson,:);
  plot(RMS_It,'b','linewidth',1);hold on
yTicks = get(gca,'ytick');
  semilogy(sson,RMS1(tson,ttson,sson),'go','linewidth',1);hold on
  xlabel('S');
  if GR==1;ylabel('RMS (mGal)');else;ylabel('RMS (mV)');end
%% 
  cla(Depth_Axes);
  axes(Depth_Axes);
  D11_It(:,1)=D11(tson,ttson,:);
  for i=1:smax
    mx(i)=i;
    my(i)=mean(D11_It(1:i,1));
  end
  plot(D11_It,'b','linewidth',1);hold on
  plot(mx,my,'r','linewidth',1);hold on
  plot(sson,D1(tson,ttson,sson),'go','linewidth',1);hold on
  xlabel('S');
  ylabel('Depth (km)');
%%
  cla(A_Axes);
  axes(A_Axes);
  A11_It(:,1)=A11(tson,ttson,:);
  plot(A11_It,'b','linewidth',1);hold on
  for i=1:smax
    mx(i)=i;
    my(i)=mean(A11(tson,ttson,1:i));
  end
  plot(mx,my,'r','linewidth',1);hold on
  plot(sson,A1(tson,ttson,sson),'go','linewidth',1);hold on
  plot(mx(sson),my(sson),'go','linewidth',1);hold on

  xlabel('S');
  %%
  cla(T_Axes);
  axes(T_Axes);
      T11_It(:,1)=T11(tson,ttson,:);

  plot(T11_It,'b','linewidth',1);hold on
  for i=1:smax
    mx(i)=i;
    my(i)=mean(T11_It(1:i,1));
  end
  plot(mx,my,'r','linewidth',1);hold on
  plot(sson,T1(tson,ttson,sson),'go','linewidth',1);hold on
  plot(mx(sson),my(sson),'go','linewidth',1);hold on

  xlabel('S');
  ylabel('{\theta} (^o)');
% fprintf('iter=%6d  s=%6d\n',ss_son,sson)
function edit_x_Callback(hObject, eventdata, handles)
% hObject    handle to edit_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_x as text
%        str2double(get(hObject,'String')) returns contents of edit_x as a double


% --- Executes during object creation, after setting all properties.
function edit_x_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_xs_Callback(hObject, eventdata, handles)
% hObject    handle to edit_xs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_xs as text
%        str2double(get(hObject,'String')) returns contents of edit_xs as a double
global xs
xs=str2num(get(hObject,'String'));


% --- Executes during object creation, after setting all properties.
function edit_xs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_xs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_xb_Callback(hObject, eventdata, handles)
% hObject    handle to edit_xb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_xb as text
%        str2double(get(hObject,'String')) returns contents of edit_xb as a double
global xb
xb=str2num(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function edit_xb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_xb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
