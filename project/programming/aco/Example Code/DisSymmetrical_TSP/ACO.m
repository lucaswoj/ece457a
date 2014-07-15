function ACO(inputfile)
%% Example: ACO('ulysses22.tsp')
disp('AS is reading input nodes file...');
[Dimension,NodeCoord,NodeWeight,Name]=FileInput(inputfile);
disp([num2str(Dimension),' nodes in',Name,' has been read in']);
disp(['AS start at ',datestr(now)]);
%%%%%%%%%%%%% the key parameters of Ant System %%%%%%%%%
MaxITime=1e3;
AntNum=Dimension;
alpha=1;
beta=5;
rho=0.65;
%%%%%%%%%%%%% the key parameters of Ant System %%%%%%%%%
fprintf('Showing Iterative Best Solution:\n');
[GBTour,GBLength,Option,IBRecord] = ...
AS(NodeCoord,NodeWeight,AntNum,MaxITime,alpha,beta,rho);    
disp(['AS stop at ',datestr(now)]);
disp('Drawing the iterative course''s curve');
figure(1);
subplot(2,1,1)
plot(1:length(IBRecord(1,:)),IBRecord(1,:));
xlabel('Iterative Time');
ylabel('Iterative Best Cost');
title(['Iterative Course: ','GMinL=',num2str(GBLength),', FRIT=',num2str(Option.OptITime)]);
subplot(2,1,2)
plot(1:length(IBRecord(2,:)),IBRecord(2,:));
xlabel('Iterative Time');
ylabel('Average Node Branching');
figure(2);
DrawCity(NodeCoord,GBTour);
title([num2str(Dimension),' Nodes Tour Path of ',Name]);

function [Dimension,NodeCoord,NodeWeight,Name]=FileInput(infile)
if ischar(infile)
    fid=fopen(infile,'r');
else
    disp('input file no exist');
    return;
end
if fid<0
    disp('error while open file');
    return;
end
NodeWeight = [];
while feof(fid)==0
    temps=fgetl(fid);
    if strcmp(temps,'')
        continue;
    elseif strncmpi('NAME',temps,4)
        k=findstr(temps,':');
        Name=temps(k+1:length(temps));
    elseif strncmpi('DIMENSION',temps,9)
        k=findstr(temps,':');
        d=temps(k+1:length(temps));
        Dimension=str2double(d); %str2num
    elseif strncmpi('EDGE_WEIGHT_SECTION',temps,19)
        formatstr = [];
        for i=1:Dimension
            formatstr = [formatstr,'%g '];
        end
        NodeWeight=fscanf(fid,formatstr,[Dimension,Dimension]);
        NodeWeight=NodeWeight';
    elseif strncmpi('NODE_COORD_SECTION',temps,18) || strncmpi('DISPLAY_DATA_SECTION',temps,20)
        NodeCoord=fscanf(fid,'%g %g %g',[3 Dimension]);
        NodeCoord=NodeCoord';
    end
end
fclose(fid);

function plothandle=DrawCity(CityList,Tours)
xd=[];yd=[];
nc=length(Tours);
plothandle=plot(CityList(:,2:3),'.');
set(plothandle,'MarkerSize',16);
for i=1:nc
    xd(i)=CityList(Tours(i),2);
    yd(i)=CityList(Tours(i),3);
end
set(plothandle,'XData',xd,'YData',yd);
line(xd,yd);

function [GBTour,GBLength,Option,IBRecord]=AS(CityMatrix,WeightMatrix,AntNum,MaxITime,alpha,beta,rho)
%% (Ant System) date:070427 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Reference£º
% Dorigo M, Maniezzo Vittorio, Colorni Alberto. 
%   The Ant System: Optimization by a colony of cooperating agents [J]. 
%   IEEE Transactions on Systems, Man, and Cybernetics--Part B,1996, 26(1)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global ASOption Problem AntSystem
ASOption = InitParameter(CityMatrix,AntNum,alpha,beta,rho,MaxITime);
Problem = InitProblem(CityMatrix,WeightMatrix);
AntSystem = InitAntSystem();
ITime = 0;
IBRecord = [];
if ASOption.DispInterval ~= 0
    close all
    set(gcf,'Doublebuffer','on');
    hline=plot(1,1,'-o');
end
while 1
    InitStartPoint();
    for step = 2:ASOption.n
        for ant = 1:ASOption.m
            P = CaculateShiftProb(step,ant);
            nextnode = Roulette(P,1);
            RefreshTabu(step,ant,nextnode);
        end
    end
    CloseTours();
    ITime = ITime + 1;
    CaculateToursLength();
    GlobleRefreshPheromone();
    ANB = CaculateANB();
    [GBTour,GBLength,IBRecord(:,ITime)] = GetResults(ITime,ANB);
    ShowIterativeCourse(GBTour,ITime,hline);
%     ShowIterativeCourse(IBRecord(3:end,ITime),ITime,hline);
    if Terminate(ITime,ANB)
        break;
    end
end
Option = ASOption;
%% --------------------------------------------------------------
function ASOption = InitParameter(Nodes,AntNum,alpha,beta,rho,MaxITime)
ASOption.n = length(Nodes(:,1));
ASOption.m = AntNum;
ASOption.alpha = alpha;
ASOption.beta = beta;
ASOption.rho = rho;
ASOption.MaxITime = MaxITime;
ASOption.OptITime = 1;
ASOption.Q = 10;
ASOption.C = 100;
ASOption.lambda = 0.15;
ASOption.ANBmin = 2; 
ASOption.GBLength = inf;
ASOption.GBTour = zeros(length(Nodes(:,1))+1,1);
ASOption.DispInterval = 10;
rand('state',sum(100*clock));
%% --------------------------------------------------------------
function Problem = InitProblem(Nodes,WeightMatrix)
global ASOption
n = length(Nodes(:,1));
MatrixTau = (ones(n,n)-eye(n,n))*ASOption.C;
Distances = WeightMatrix;
SymmetryFlag = false;
if isempty(WeightMatrix)
    Distances = CalculateDistance(Nodes);
    SymmetryFlag = true;
end
Problem = struct('nodes',Nodes,'dis',Distances,'tau',MatrixTau,'symmetry',SymmetryFlag);
%% --------------------------------------------------------------
function AntSystem = InitAntSystem()
global ASOption
AntTours = zeros(ASOption.m,ASOption.n+1); 
ToursLength = zeros(ASOption.m,1);
AntSystem = struct('tours',AntTours,'lengths',ToursLength);
%% --------------------------------------------------------------
function InitStartPoint()
global AntSystem ASOption
AntSystem.tours = zeros(ASOption.m,ASOption.n+1); 
rand('state',sum(100*clock));
AntSystem.tours(:,1) = randint(ASOption.m,1,[1,ASOption.n]);
AntSystem.lengths = zeros(ASOption.m,1);
%% --------------------------------------------------------------
function Probs = CaculateShiftProb(step_i, ant_k)
global AntSystem ASOption Problem
CurrentNode = AntSystem.tours(ant_k, step_i-1);
VisitedNodes = AntSystem.tours(ant_k, 1:step_i-1);
tau_i = Problem.tau(CurrentNode,:);
tau_i(1,VisitedNodes) = 0;
dis_i = Problem.dis(CurrentNode,:);
dis_i(1,CurrentNode) = 1;
Probs = (tau_i.^ASOption.alpha).*((1./dis_i).^ASOption.beta);
if sum(Probs) ~= 0
    Probs = Probs/sum(Probs);
else 
    NoVisitedNodes = setdiff(1:ASOption.n,VisitedNodes);
    Probs(1,NoVisitedNodes) = 1/length(NoVisitedNodes);
end
%% --------------------------------------------------------------
function Select = Roulette(P,num)
m = length(P);
flag = (1-sum(P)<=1e-5);
Select = zeros(1,num);
rand('state',sum(100*clock));
r = rand(1,num);
for i=1:num
    sumP = 0;
    j = ceil(m*rand); 
    while (sumP<r(i)) && flag
        sumP = sumP + P(mod(j-1,m)+1);
        j = j+1;
    end
    Select(i) = mod(j-2,m)+1;
end
%% --------------------------------------------------------------
function RefreshTabu(step_i,ant_k,nextnode)
global AntSystem
AntSystem.tours(ant_k,step_i) = nextnode;
%% --------------------------------------------------------------
function CloseTours()
global AntSystem ASOption
AntSystem.tours(:,ASOption.n+1) = AntSystem.tours(:,1);
%% --------------------------------------------------------------
function CaculateToursLength()
global AntSystem ASOption Problem
Lengths = zeros(ASOption.m,1);
for k=1:ASOption.m
    for i=1:ASOption.n
        Lengths(k)=Lengths(k)+...
        Problem.dis(AntSystem.tours(k,i),AntSystem.tours(k,i+1));
    end
end
AntSystem.lengths = Lengths;
%% --------------------------------------------------------------
function [GBTour,GBLength,Record] = GetResults(ITime,ANB)
global AntSystem ASOption
[IBLength,AntIndex] = min(AntSystem.lengths);
IBTour = AntSystem.tours(AntIndex,:);
if IBLength<=ASOption.GBLength 
	ASOption.GBLength = IBLength;
	ASOption.GBTour = IBTour;
	ASOption.OptITime = ITime;
end
GBTour = ASOption.GBTour';
GBLength = ASOption.GBLength;
Record = [IBLength,ANB,IBTour]';
%% --------------------------------------------------------------
function GlobleRefreshPheromone()
global AntSystem ASOption Problem
AT = AntSystem.tours;
TL = AntSystem.lengths;
sumdtau=zeros(ASOption.n,ASOption.n);   
for k=1:ASOption.m
    for i=1:ASOption.n 
        sumdtau(AT(k,i),AT(k,i+1))=sumdtau(AT(k,i),AT(k,i+1))+ASOption.Q/TL(k);
        if Problem.symmetry
            sumdtau(AT(k,i+1),AT(k,i))=sumdtau(AT(k,i),AT(k,i+1)); 
        end
    end
end
Problem.tau=Problem.tau*(1-ASOption.rho)+sumdtau;
%% --------------------------------------------------------------
function flag = Terminate(ITime,ANB)
global ASOption
flag = false;
if ANB<=ASOption.ANBmin || ITime>=ASOption.MaxITime
    flag = true;
end
%% --------------------------------------------------------------
function ANB = CaculateANB()
global ASOption Problem
mintau = min(Problem.tau+ASOption.C*eye(ASOption.n,ASOption.n));
sigma = max(Problem.tau) - mintau;
dis = Problem.tau - repmat(sigma*ASOption.lambda+mintau,ASOption.n,1);
NB = sum(dis>=0,1);
ANB = sum(NB)/ASOption.n;
%% --------------------------------------------------------------
function Distances = CalculateDistance(Nodes)
global ASOption 
Nodes(:,1)=[]; 
Distances=zeros(ASOption.n,ASOption.n);
for i=2:ASOption.n
    for j=1:i
        if(i==j)    
            continue;
        else
            dij=Nodes(i,:)-Nodes(j,:);
            Distances(i,j)=sqrt(dij(1)^2+dij(2)^2);
            Distances(j,i)=Distances(i,j);  
        end
    end
end
%% --------------------------------------------------------------
function ShowIterativeCourse(IBTour,ITime,hmovie)
global Problem ASOption
num = length(IBTour);
if mod(ITime,ASOption.DispInterval)==0
    title(get(hmovie,'Parent'),['ITime = ',num2str(ITime)]);
    NodeCoord = Problem.nodes;
    xd=[];yd=[];
    for i=1:num
        xd(i)=NodeCoord(IBTour(i),2);
        yd(i)=NodeCoord(IBTour(i),3);
    end
    set(hmovie,'XData',xd,'YData',yd);
    pause(0.01);
end