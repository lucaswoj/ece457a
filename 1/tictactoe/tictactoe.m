% We are replacing the log in function decision(handles)

function varargout = tictactoe(varargin)
% TICTACTOE M-file for tictactoe.fig
%      TICTACTOE, by itself, creates a new TICTACTOE or raises the existing
%      singleton*.
%
%      H = TICTACTOE returns the handle to a new TICTACTOE or the handle to
%      the existing singleton*.
%
%      TICTACTOE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TICTACTOE.M with the given input arguments.
%
%      TICTACTOE('Property','Value',...) creates a new TICTACTOE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before tictactoe_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to tictactoe_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help tictactoe

% Last Modified by GUIDE v2.5 09-May-2012 23:16:49

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @tictactoe_OpeningFcn, ...
                   'gui_OutputFcn',  @tictactoe_OutputFcn, ...
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


% --- Executes just before tictactoe is made visible.
function tictactoe_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to tictactoe (see VARARGIN)

% Choose default command line output for tictactoe
    handles.output = hObject;
    set(hObject, 'Name', 'Tic Tac Toe');

% Update handles structure
    guidata(hObject, handles);

% UIWAIT makes tictactoe wait for user response (see UIRESUME)
% uiwait(handles.MTTT);

% end function

% --- Outputs from this function are returned to the command line.
function varargout = tictactoe_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
    varargout{1} = handles.output;
% end function

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    availableSquares=getappdata(gcbf,'availableSquares');
    if isempty(availableSquares(availableSquares==1))
        set(handles.dispturn,'String','dont cheat');
    else
        picksquare(handles,1);
    end
% end function

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
availableSquares=getappdata(gcbf,'availableSquares');
if isempty(availableSquares(availableSquares==2))
    set(handles.dispturn,'String','dont cheat');
else
    picksquare(handles,2);
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
availableSquares=getappdata(gcbf,'availableSquares');
if isempty(availableSquares(availableSquares==3))
    set(handles.dispturn,'String','dont cheat');
else
    picksquare(handles,3);
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
availableSquares=getappdata(gcbf,'availableSquares');
if isempty(availableSquares(availableSquares==4))
    set(handles.dispturn,'String','dont cheat');
else
    picksquare(handles,4);
end


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
availableSquares=getappdata(gcbf,'availableSquares');
if isempty(availableSquares(availableSquares==5))
    set(handles.dispturn,'String','dont cheat');
else
    picksquare(handles,5);
end


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    availableSquares=getappdata(gcbf,'availableSquares');
    if isempty(availableSquares(availableSquares==6))
        set(handles.dispturn,'String','dont cheat');
    else
        picksquare(handles,6);
    end
% end function


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    availableSquares=getappdata(gcbf,'availableSquares');
    if isempty(availableSquares(availableSquares==7))
        set(handles.dispturn,'String','dont cheat');
    else
        picksquare(handles,7);
    end
% end function


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    availableSquares=getappdata(gcbf,'availableSquares');
    if isempty(availableSquares(availableSquares==8))
        set(handles.dispturn,'String','dont cheat');
    else
        picksquare(handles,8);
    end
% end function


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    availableSquares=getappdata(gcbf,'availableSquares');
    if isempty(availableSquares(availableSquares==9))
        set(handles.dispturn,'String','dont cheat');
    else
        picksquare(handles,9);
    end
% end function

function picksquare(handles,num)
    turn=getappdata(gcbf,'turn');
    availableSquares=getappdata(gcbf,'availableSquares');

    % this removes [num] from availableSquares, obviously
    availableSquares(availableSquares==num)=[];
    setappdata(gcbf,'availableSquares',availableSquares);
    board=getappdata(gcbf,'board');
    board(num)=turn;

    if turn==1
        set(eval(['handles.pushbutton' int2str(num)]),'String','X');
        turn=-1;
        set(handles.dispturn,'String','O Turn');
    elseif turn==-1
        set(eval(['handles.pushbutton' int2str(num)]),'String','O');
        turn=1;
        set(handles.dispturn,'String','X Turn');
    end
    setappdata(gcbf,'turn',turn);
    setappdata(gcbf,'board',board);
    [win]=checkboard(board);

    if win~=0
        % somebody won the game!
        for i=1:9
            % disable the click button for all butons
            set(eval(['handles.pushbutton' int2str(i)]),'Enable','off');
        end
    	if win==1
           set(handles.dispturn,'String','X WINS!');
        elseif win==-1
           set(handles.dispturn,'String','O WINS!');
        end
    end

    if win==0
        % nobody has won
        if isempty(availableSquares)
           % but there are no more squares -- tie!
           for i=1:9
               set(eval(['handles.pushbutton' int2str(i)]),'Enable','off');
           end
           set(handles.dispturn,'String','Tie Game');
           return
        end

        % ai is player 1
        if turn==1
            decision(handles);
        end
    end
%end function

function [win]=checkboard(b)
    win=0;
    % foreach (i in [-1, 1])
    for i=[-1 1]
        if b(1)==i && b(2)==i && b(3)==i
            win=i;
        elseif b(4)==i && b(5)==i && b(6)==i
            win=i;
        elseif b(7)==i && b(8)==i && b(9)==i
            win=i;
        elseif b(1)==i && b(4)==i && b(7)==i
            win=i;
        elseif b(2)==i && b(5)==i && b(8)==i
            win=i;
        elseif b(3)==i && b(6)==i && b(9)==i
            win=i;
        elseif b(1)==i && b(5)==i && b(9)==i
            win=i;
        elseif b(3)==i && b(5)==i && b(7)==i
            win=i;
        end
    end
% end function

% --- Executes on button press in newgame.
function newgame_Callback(hObject, eventdata, handles)
% hObject    handle to newgame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    for i=1:9
        set(eval(['handles.pushbutton' int2str(i)]),'Enable','on');
        set(eval(['handles.pushbutton' int2str(i)]),'String','');
    end

    % turn is either -1 or 1 now
    turn=-1 + 2 * (ceil(rand*2) - 1);
    if turn==1
        set(handles.dispturn,'String','X Turn');
    elseif turn==-1
        set(handles.dispturn,'String','O Turn');
    end
    setappdata(gcbf,'turn',turn);
    board=zeros(1,9);
    setappdata(gcbf,'board',board);
    availableSquares=[1:9];
    setappdata(gcbf,'availableSquares',availableSquares);
    if turn==1
        decision(handles);
    end
% end function

% REPLACE THIS RULE-BASED DECISION CODE WITH MIN-MAX STRATEGY
function decision(handles)
    availableSquares=getappdata(gcbf,'availableSquares');
    board=getappdata(gcbf,'board');
    num=0;
    pause(0.5);

    % winning lines
    lines = [
                1 2 3; 
                4 5 6; 
                7 8 9; 
                1 4 7; 
                2 5 8; 
                3 6 9; 
                1 5 9; 
                3 5 7
            ];

    % search for moves that will let us win
    % if no results, search for moves that will
    % block player from winning
    for turn = [1, -1]
        for line = lines'
            % see if we have 2 in any line -- choose the third if so
            if board(line(1)) == turn && board(line(2)) == turn && board(line(3)) == 0
                num = line(3)
                break
            elseif board(line(1)) == turn && board(line(2)) == 0 && board(line(3)) == turn
                num = line(2)
                break
            elseif board(line(1)) == 0 && board(line(2)) == turn && board(line(3)) == turn
                num = line(1)
                break
            end
        end

        if num ~= 0
            break
        end
    end

    if num == 0
        % yolo at random if you don't have a move
        num=availableSquares(ceil(rand*(length(availableSquares)))); %pick any sq if everything fails
    end

    picksquare(handles,num);
% end function


% Finds the best board for player with turn = 1
% With turn = -1, it will get THE WORST BOARD
function bestBoard = getBestBoard(board, turn, ab)
    bestBoard = board;
    bestScore = -Inf;

    if checkboard(board) ~= 0
        % there is a winrar -- nothing to do
        return;
    end

    for i = 1:9
        if board(i) ~= 0
            % Only permute squares that are empty
            continue;
        end
        
        evolution = board;
        evolution(i) = turn;

        % modify ab?
        score = scoreBoard(getBestBoard(evolution, -turn, ab)) * turn;

        if score > bestScore
            bestScore = score;
            bestBoard = evolution;
        end
    end



% --- Executes during object creation, after setting all properties.
function MTTT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MTTT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
