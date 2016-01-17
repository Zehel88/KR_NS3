function varargout = lab3_main(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @lab3_main_OpeningFcn, ...
                   'gui_OutputFcn',  @lab3_main_OutputFcn, ...
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

function lab3_main_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);

function varargout = lab3_main_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;



function uipushtool1_ClickedCallback(hObject, eventdata, handles)
open('lab3_model') 



function pushbutton1_Callback(hObject, eventdata, handles)

F=newfis('lab3_fis');

ki=0.388;
kp=0.323;
C=1;

di=[-1/ki 1/ki];
dp=[-1/kp 1/kp];

q1=di(1):(abs(di(1))+abs(di(2)))/6:di(2);
q2=dp(1):(abs(dp(1))+abs(dp(2)))/6:dp(2);
q3=0:(0+C)/6:C;

F=addvar(F,'input','x1',di);
F=addvar(F,'input','x2',dp);

F=addvar(F,'output','u',[0 C]);

for i=1:7
    switch i
        case 1
            name='nb';
        case 2
            name='nm';
        case 3
            name='ns';
        case 4
            name='z';
        case 5
            name='ps';
        case 6 
            name='pm';
        case 7
            name='pb';
    end
F=addmf(F,'input',1,name,'gaussmf',[0.5 q1(i)]);
F=addmf(F,'input',2,name,'gaussmf',[0.5 q2(i)]);

F=addmf(F,'output',1,name,'gaussmf',[0.2 q3(i)]);
end


rulelist=[1 1 1 1 1;
          1 2 1 1 1;
          1 3 1 1 1;
          1 4 1 1 1;
          1 5 2 1 1;
          1 6 3 1 1;
          1 7 4 1 1;
          2 1 1 1 1;
          2 2 1 1 1;
          2 3 1 1 1;
          2 4 2 1 1;
          2 5 3 1 1;
          2 6 4 1 1;
          2 7 5 1 1;
          3 1 1 1 1;
          3 2 1 1 1;
          3 3 2 1 1;
          3 4 3 1 1;
          3 5 4 1 1;
          3 6 5 1 1;
          3 7 6 1 1;
          4 1 1 1 1;
          4 2 2 1 1;
          4 3 3 1 1;
          4 4 4 1 1;
          4 5 5 1 1;
          4 6 6 1 1;
          4 7 7 1 1;
          5 1 2 1 1;
          5 2 3 1 1;
          5 3 4 1 1;
          5 4 5 1 1;
          5 5 6 1 1;
          5 6 7 1 1;
          5 7 7 1 1;
          6 1 3 1 1;
          6 2 4 1 1;
          6 3 5 1 1;
          6 4 6 1 1;
          6 5 7 1 1;
          6 6 7 1 1;
          6 7 7 1 1;
          7 1 4 1 1;
          7 2 5 1 1;
          7 3 6 1 1;
          7 4 7 1 1;
          7 5 7 1 1;
          7 6 7 1 1;
          7 7 7 1 1];

      F=addrule(F,rulelist);


      
writefis(F,'lab3_fis')

load_system('lab3_model')
set_param('lab3_model/fuzzy/FLC','FIS','''lab3_fis.fis''')

sim('lab3_model')

load('fr_m_an.mat');
load('fr_m_fuz.mat');

axes(handles.axes1)
plot(fr_m_an(1,:),fr_m_an(2,:))
title('ПФ с аналоговым регулятором')
grid on
axes(handles.axes2)
plot(fr_m_fuz(1,:),fr_m_fuz(2,:))
title('ПФ с нечётким регулятором')
grid on



function plotmbtn_ClickedCallback(hObject, eventdata, handles)
F=readfis('lab3_fis')
figure(1)
set(figure(1),'position',[300 300 700 500])
subplot(2,2,1)
plotmf(F,'input',1)
subplot(2,2,2)
plotmf(F,'input',2)
subplot(2,2,3)
plotmf(F,'output',1)
subplot(2,2,4)
gensurf(F)
