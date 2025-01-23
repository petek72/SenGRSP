function varargout = FrwMod(varargin)
% Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FrwMod_OpeningFcn, ...
                   'gui_OutputFcn',  @FrwMod_OutputFcn, ...
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
function FrwMod_OpeningFcn(hObject, eventdata, handles, varargin)
    handles.output = hObject;
    guidata(hObject, handles);
    movegui(gcf,'center');
    global edit_cc edit_mm edit_nn edit_pp edit_qq edit_xx0
    global Select_1s Select_2s Select_3s Select_Mod S1
    global RB_GRR RB_SPP stdEd meanEd noiseEd edit_The
    global R1 R2  N1 N2 dirname GR SP filename
    global c m n p q
    edit_xx0=handles.edit_x0;
    edit_cc=handles.edit_c;
    edit_mm=handles.edit_m;
    edit_nn=handles.edit_n;
    edit_pp=handles.edit_p;
    edit_qq=handles.edit_q;
    edit_The=handles.edit_Theta;
Select_1s=handles.Select_1;
Select_2s=handles.Select_2;
Select_3s=handles.Select_3;
RB_GRR=handles.RB_GR;
RB_SPP=handles.RB_SP;
R1=0;
R2=0;
N1=0;
N2=1;
GR=0;
SP=1;
Select_Mod=2;
  set(edit_cc,'String',1);c=1;
  set(edit_mm,'String',1);m=1;
  set(edit_nn,'String',1);n=1;
  set(edit_pp,'String',1);p=1;
  set(edit_qq,'String',0.5);q=1;


  set(handles.meanEdit,'String',0);
  set(handles.stdEdit,'String',5);
  set(handles.noiseEdit,'String',5);

stdEd=handles.stdEdit;
meanEd=handles.meanEdit;
noiseEd=handles.noiseEdit;


set(handles.Select_2,'Value',1);
set(handles.RB_SP,'Value',1);
set(handles.RB_Per,'Value',0);

set(handles.RB_Per,'Value',0);
set(handles.RB_Std,'Value',1);
    set(noiseEd,'enable','off');
    set(stdEd,'enable','off');
    set(meanEd,'enable','off');
        set(handles.computeAnoBtn,'enable','on');

  %dirname='D:\SenGRSPint\';
   

        function varargout = FrwMod_OutputFcn(hObject, eventdata, handles) 
    varargout{1} = handles.output;

%
function computeAnoBtn_Callback(hObject, eventdata, handles)
    global uitableData;
    global GR;
    global c m n p;
    global q A z Theta;
    global nData x x0 dx Vcal xx
    global cb_value
    global N1 N2 stdEd meanEd noiseEd
    
%%    
Con_K=(get(handles.edit_A,'String'));
if ~isempty(Con_K)
    if ~all(ismember(Con_K, '-.1234567890'))
        msgbox('The K value must be numeric');
        return
    else
    end
else
    msgbox('Please, enter the K value');
    return;
end
%%    
Con_z=get(handles.edit_z,'String');
if ~isempty(Con_z)
    if ~all(ismember(Con_z, '.1234567890'))
        msgbox('The z value must be numeric');
        return
    else
    end
else
    msgbox('Please, enter the z value');
    return
end
%%    
Con_Theta=get(handles.edit_Theta,'String');
if ~isempty(Con_Theta)
    if ~all(ismember(Con_Theta, '.1234567890'))
        msgbox('The Theta value must be numeric');
        return
    else
    end
else
    msgbox('Please, enter the Theta value');
    return;
end
%%    
Con_x0=get(handles.edit_x0,'String');
if ~isempty(Con_x0)
    if ~all(ismember(Con_x0, '.1234567890'))
        msgbox('The x0 value must be numeric');
        return
    else
    end
else
    msgbox('Please, enter the x0 value');
    return
end
%%    
Con_nData=get(handles.edit_nData,'String');
if ~isempty(Con_nData)
    if ~all(ismember(Con_nData, '.1234567890'))
        msgbox('The Number of Data value must be numeric');
        return
    else
    end
else
    msgbox('Please, enter the Number of Data value');
    return
end
%%    
Con_dx=get(handles.edit_dx,'String');
if ~isempty(Con_dx)
    if ~all(ismember(Con_dx, '.1234567890'))
        msgbox('The Sampling Interval value must be numeric');
        return
    else
    end
else
    msgbox('Please, enter the Sampling Interval value');
    return
end
%%    
Con_c=get(handles.edit_c,'String');
if ~isempty(Con_c)
    if ~all(ismember(Con_c, '.1234567890'))
        msgbox('The c value must be numeric');
        return
    else
    end
else
    msgbox('Please, enter the c value');
    return
end
%%    
Con_m=get(handles.edit_m,'String');
if ~isempty(Con_m)
    if ~all(ismember(Con_m, '.1234567890'))
        msgbox('The m value must be numeric');
        return
    else
    end
else
    msgbox('Please, enter the m value');
    return
end
%%    
Con_n=get(handles.edit_n,'String');
if ~isempty(Con_n)
    if ~all(ismember(Con_n, '.1234567890'))
        msgbox('The n value must be numeric');
        return
    else
    end
else
    msgbox('Please, enter the n value');
    return
end
%%    
Con_p=get(handles.edit_p,'String');
if ~isempty(Con_p)
    if ~all(ismember(Con_p, '.1234567890'))
        msgbox('The p value must be numeric');
        return
    else
    end
else
    msgbox('Please, enter the p value');
    return
end
%%    =
           
            
         
x=[];
Vcal=[];

nData;
Nss=fix(nData/2);

Ns=(Nss);
x=0:dx:(nData-1)*dx;
x=x-x0;

if GR==1
    for i=1:nData
        Th=Theta*pi/180;
        pay=c*x(i)*(cos(Th))^n+(z^p)*(sin(Th))^m;
        payda=(x(i)^2+z^2)^q;
        Vcal(i)=A*pay/payda;
    end
else
    for i=1:nData
        Th=Theta*pi/180;
        pay=c*x(i)*(cos(Th))^n+(z^p)*(sin(Th))^m;
        payda=(x(i)^2+z^2)^q;
        Vcal(i)=A*pay/payda ;
    end
end

        cb_value = get(handles.noiseChk, 'Value');
%    if cb_value==1
%      S=get(handles.noiseEdit,'String');
%            if ~isempty(S)
%                if ~all(ismember(S, '.1234567890'))
%                    msgbox('Noise percentage must be numeric');
%                    return;
%                else            
%                end;
%            else
%                %msgbox('Please, enter the noise percentage');
%                return;
%            end;  
%    end;
if cb_value==1

    if N1==1

        S=get(handles.noiseEdit,'String');
        if ~isempty(S)
            if ~all(ismember(S, '.1234567890'))
                msgbox('Noise percentage must be numeric');
                return;
            else
            end
        else
            msgbox('Please, enter the noise percentage');
            return;
        end

        Noise=randn(length(x),1)*max(Vcal)*str2double(S)/100;Noise=Noise';
        mu=0;sigma=str2double(S);nr=length(Vcal);
        Vcal=Vcal+Noise;
    end
    if N2==1
        %%
        stdd=get(handles.stdEdit,'String');
        if ~isempty(stdd)
            if ~all(ismember(stdd, '.1234567890'))
                msgbox('Standard deviation must be numeric');
                return;
            else
            end;
        else
            msgbox('Please, enter the standard deviation');
            return;
        end;

        %%
        muu=get(handles.meanEdit,'String');
        if ~isempty(muu)
            if ~all(ismember(muu, '.1234567890'))
                msgbox('Mean must be numeric');
                return;
            else
            end
        else
            msgbox('Please, enter the mean');
            return;
        end
        %%
        mu=str2double(muu);sigma=str2double(stdd);nr=length(Vcal);
        %Noise = normrnd(muu,sigma,[1, nr]);
        Noise = mu+sigma*randn([1, nr]);
        Vcal=Vcal+Noise;
    end

end


    


x=x+x0;
cla(handles.AnoAxes);
axes(handles.AnoAxes);
plot(x,Vcal,'ro','Markersize',4,'MarkerFaceColor','r'),hold on;
xlim([min(x) max(x)])
xlabel('Distance (m)');
if GR==1;
    ylabel('Gravity anomaly (mGal)');
else
    ylabel('SP anomaly (mV)');

end
set(handles.saveAnoBtn,'enable','on');
set(handles.saveGrpBtn,'enable','on');



function saveAnoBtn_Callback(hObject, eventdata, handles)
global nData x Vcal;
global GR SP filename dirname
%[filepath,name,ext] = fileparts(filename);
  [file,path] = uiputfile([ dirname '*.txt'],' ');  

filename1=[ dirname file '_Anomaly' ];

%[file,path] = uiputfile(filename1);   
    if isequal(file,0) || isequal(path,0)
    else
        file=fullfile(path,file);
        f=fopen(file,'w+');
            fprintf(f,'Gravity_or_SP     : %d %d\n',GR, SP);
            fprintf(f,'Number_of_Samples : %d\n',nData);
if GR==1
    fprintf(f,'    Distance   GR_Anomaly\n');

else
  fprintf(f,'    Distance   SP_Anomaly\n');
end
        for i=1:nData
        %fprintf('%8.2f %8.2f\n',x(i),Vcal(i)); 
        fprintf(f,'%12.2f %12.2f\n',x(i),Vcal(i)); 
        end
        fclose(f);
    end

%SAVE GRAPHICS Button Call Event
function saveGrpBtn_Callback(hObject, eventdata, handles)
    global x;
    global Vcal;
    global GR SP filename dirname
    
[filepath,name,ext] = fileparts(filename);
filename1=[ dirname name '_Anomaly' '.fig'];

[file,path] = uiputfile(filename1);   

    if isequal(file,0) || isequal(path,0)
    else
        file=fullfile(path,file);
        fig2=figure(2);
    plot(x,Vcal,'ro','Markersize',4,'MarkerFaceColor','r'),hold on;
    xlim([min(x) max(x)])
    xlabel('Distance (m)'); 
    if GR==1
      ylabel('Gravity anomaly (mGal)');   
    else
      ylabel('SP anomaly (mV)');   

    end
        set(gca,'FontSize',14);
        
        saveas(fig2,file);
        close(fig2);    
    end

%LOAD Button Call Event
function loadPrmBtn_Callback(hObject, eventdata, handles)
    global GR SP
    global q A z Theta;
    global nData dx x0
    global Select_Mod
    global c m n p filename dirname name
    x=[];
    Vcal=[];
    filename=[];name=[];
[file,path] = uigetfile([ dirname '*.txt'],' ');%  file=fullfile([ path ],file)
    filename=file;
    if isequal(file,0) || isequal(path,0)
        
    else
        file=fullfile(path,file);
        f=fopen(file);
        data1 = textscan(f,'%s %s %f %f',1);
        data2 = textscan(f,'%s %s %f',1);
        data3 = textscan(f,'%s %s %f',1);


        nData=((cell2mat(data2(3))));
        dx=cell2mat(data3(3));

            data = textscan(f,'%s %s %f',1);
            Select_Mod=cell2mat(data(3));
            data5 = textscan(f,'%s %s %f',1);
            A=cell2mat(data5(3));
            data5 = textscan(f,'%s %s %f',1);
            z=cell2mat(data5(3));
            data5 = textscan(f,'%s %s %f',1);
            Theta=cell2mat(data5(3));
            data5 = textscan(f,'%s %s %f',1);
            x0=cell2mat(data5(3));
            if cell2mat(data1(3))==1
              GR=1;SP=0;
              c=0;m=0;n=0;
              if Select_Mod==1
                p=0;
              else
                p=1;
              end
            end
            if cell2mat(data1(4))==1
              SP=1;GR=0;
              c=1;m=1;n=1;p=1;
            end
            set(handles.edit_q,'String',q);
            set(handles.edit_A,'String',A);
            set(handles.edit_z,'String',z);
            set(handles.edit_Theta,'String',Theta);
            set(handles.edit_x0,'String',x0);


   
        fclose(f);
        set(handles.edit_nData,'String',cell2mat(data2(3)));
        set(handles.edit_dx,'String',cell2mat(data3(3)));
        set(handles.savePrmBtn,'enable','on');
        set(handles.computeAnoBtn,'enable','on');
Select
    end;

%SAVE Button Call Event
function savePrmBtn_Callback(hObject, eventdata, handles)
global GR SP
global nData dx
global Select_Mod
global A z Theta x0
    global GR SP filename dirname
  [file,path] = uiputfile([ dirname '*.txt'],' ');  
%[filepath,name,ext] = fileparts(filename);
%filename1=[ dirname name ext];
%[file,path] = uiputfile(filename1);  
        if isequal(file,0) || isequal(path,0)
        else
            file=fullfile(path,file);
            f=fopen(file,'wt');
            fprintf(f,'Gravity_or_SP     : %d %d\n',GR, SP);
            fprintf(f,'Number_of_Samples : %d\n',nData);
            fprintf(f,'Interval          : %5.2f\n',dx);
            fprintf(f,'Selection_Mod     : %d\n',Select_Mod);
            fprintf(f,'Amplitude_(K)     : %7.2f \n',A);
            fprintf(f,'Depth_(z)         : %7.2f \n',z);
            fprintf(f,'Dip_Angle(Theta)  : %7.2f \n',Theta);
            fprintf(f,'Hor_distance_(x0) : %7.2f \n',x0);

            fclose(f);
        end
   

%CLOSE Button Call Event
function closeBtn_Callback(hObject, eventdata, handles)
    close;

%figure1 Close Event
function figure1_CloseRequestFcn(hObject, eventdata, handles)
    global uitableData;
    global freqs;
    global modelx;
    global modely;
    global Vs;
    global layerNum;

    Vs=[];
    modelx=[];
    modely=[];
    freqs=[];
    uitableData=[];
    layerNum=[];
    
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
global dx
dx=str2num(get(hObject,'String'));


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
% hObject    handle to edit_dx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_dx as text
%        str2double(get(hObject,'String')) returns contents of edit_dx as a double
global nData
nData=str2num(get(hObject,'String'));


% --- Executes during object creation, after setting all properties.
function edit_nData_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_dx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in Selection.
function Selection_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in Selection 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
global GR SP
global R1 R2
R1=get(handles.RB_GR,'Value');
R2=get(handles.RB_SP,'Value');
Select

function NoiseSelec_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in Selection 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
global N1 N2
N1=get(handles.RB_Per,'Value');
N2=get(handles.RB_Std,'Value');
NoiseSelect
% --- Executes during object creation, after setting all properties.
function RB_GR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RB_GR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called




% --- Executes when selected object is changed in Select_mod.
function Select_mod_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in Select_mod 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
global GR SP
global S1 S2 S3
global Select_Mod

S1=get(handles.Select_1,'Value'); 
S2=get(handles.Select_2,'Value');
S3=get(handles.Select_3,'Value');
if S1==1;Select_Mod=1;end
if S2==1;Select_Mod=2;end
if S3==1;Select_Mod=3;end
%if S4==1;Select_Mod=4;end

%%
 Select
%%
function  Select()
global GR SP
global c m n p q
global edit_cc edit_mm edit_nn edit_pp edit_qq
global S1 S2 S3
global R1 R2
global Select_Mod
global Select_1s Select_2s Select_3s  
global RB_GRR RB_SPP Theta edit_The

if R1==1
  GR=1;SP=0;
  Theta=90;
  set(edit_The,'String',Theta);

%fprintf('R1  GR=%d  SP=%d\n',GR,SP)
end
if R2==1
  GR=0;SP=1;
  %fprintf('R2  GR=%d  SP=%d\n',GR,SP)

end
%%
if S1==1;
  if  GR==1
    c=0;m=0;n=0;p=0;q=0.5;
  end
  if SP==1
    c=1;m=1;n=1;p=1;q=0.5;
  end
end
%%
if S2==1;
  if  GR==1
    c=0;m=0;n=0;p=1;q=1.0;
  end
  if SP==1
    c=1;m=1;n=1;p=1;q=1.0;
  end
end
%%
if S3==1;
  if  GR==1
    c=0;m=0;n=0;p=1;q=1.5;
  end
  if SP==1
    c=1;m=1;n=1;p=1;q=1.5;
  end
end
%%


if Select_Mod==1;set(Select_1s,'Value',1);q=0.5;end
if Select_Mod==2;set(Select_2s,'Value',1);q=1.0;end
if Select_Mod==3;set(Select_3s,'Value',1);q=1.5;end
if GR==1; set(RB_GRR,'Value',1);end
if SP==1; set(RB_SPP,'Value',1);end
 
  set(edit_cc,'String',c);
  set(edit_mm,'String',m);
  set(edit_nn,'String',n);
  set(edit_pp,'String',p);
  set(edit_qq,'String',q);

%-------
function  NoiseSelect()
  global N1 N2 stdEd meanEd noiseEd cb_value

if N1==1
    set(stdEd,'enable','off');
    set(meanEd,'enable','off');
    set(noiseEd,'enable','on');

end
if N2==1
    set(stdEd,'enable','on');
    set(meanEd,'enable','on');
    set(noiseEd,'enable','off');
end


% --- Executes on button press in noiseChk.
function noiseChk_Callback(hObject, eventdata, handles)
% hObject    handle to noiseChk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of noiseChk
global cb_value N1 N2 stdEd meanEd noiseEd
if N1==1
    set(stdEd,'enable','off');
    set(meanEd,'enable','off');
    set(noiseEd,'enable','on');

end
if N2==1
    set(stdEd,'enable','on');
    set(meanEd,'enable','on');
    set(noiseEd,'enable','off');
end

function edit_x0_Callback(hObject, eventdata, handles)
% hObject    handle to edit_x0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_x0 as text
%        str2double(get(hObject,'String')) returns contents of edit_x0 as a double
global x0
x0=str2num(get(hObject,'String'));


% --- Executes during object creation, after setting all properties.
function edit_x0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_x0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in RB_Per.
function RB_Per_Callback(hObject, eventdata, handles)
% hObject    handle to RB_Per (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RB_Per


% --- Executes on button press in RB_Std.
function RB_Std_Callback(hObject, eventdata, handles)
% hObject    handle to RB_Std (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RB_Std



function edit30_Callback(hObject, eventdata, handles)
% hObject    handle to edit30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit30 as text
%        str2double(get(hObject,'String')) returns contents of edit30 as a double


% --- Executes during object creation, after setting all properties.
function edit30_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit32_Callback(hObject, eventdata, handles)
% hObject    handle to edit32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit32 as text
%        str2double(get(hObject,'String')) returns contents of edit32 as a double


% --- Executes during object creation, after setting all properties.
function edit32_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function noiseEdit_Callback(hObject, eventdata, handles)
% hObject    handle to noiseEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of noiseEdit as text
%        str2double(get(hObject,'String')) returns contents of noiseEdit as a double


% --- Executes during object creation, after setting all properties.
function noiseEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to noiseEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function meanEdit_Callback(hObject, eventdata, handles)
% hObject    handle to meanEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of meanEdit as text
%        str2double(get(hObject,'String')) returns contents of meanEdit as a double


% --- Executes during object creation, after setting all properties.
function meanEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to meanEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function stdEdit_Callback(hObject, eventdata, handles)
% hObject    handle to stdEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stdEdit as text
%        str2double(get(hObject,'String')) returns contents of stdEdit as a double


% --- Executes during object creation, after setting all properties.
function stdEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stdEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
