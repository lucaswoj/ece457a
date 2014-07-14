% Particle Swarm Optimization (by X-S Yang, Cambridge University)
% Usage: FunctionOpt(number_of.particles,Num_iterations)
% eg: best=FunctionOpt(20,15);
% where best=[xbest ybest zbest] %an n by 3 matrix
function [best]=FunctionOpt(n,Num_iterations)
% n=number of particles; Num_iterations=number of iterations
if nargin<2, Num_iterations=3; end
if nargin<1, n=20; end

% Michaelwicz Function f*=-1.801 at [2.20319,1.57049]
fstr='-sin(x)*(sin(x^2/pi))^20-sin(y)*(sin(2*y^2/pi))^20';

% Converting to an inline function and vectorization
f=vectorize(inline(fstr));

% range= [xmin xmax ymin ymax] ;
range=[0 4 0 4];
%-----------------------------------------------------------
% Setting the parameters: c_1: Attaraction to personal best (cognitive
% parameter), c_2: Attraction to global best (social parameter)
c_1=0.2; c_2=0.5;
%-----------------------------------------------------------
% Grid values of the objective for visualization only
Ndiv=100;
dx=(range(2)-range(1))/Ndiv;dy=(range(4)-range(3))/Ndiv;
xgrid=range(1):dx:range(2); ygrid=range(3):dy:range(4);
[x,y]=meshgrid(xgrid,ygrid);
z=f(x,y);
% Display the shape of the function to be optimized
set(gcf,'color','w');
figure(1); surfc(x,y,z);
hold on;
%-----------------------------------------------------------
best=zeros(Num_iterations,3); % initialize history

%----------Start Particle Swarm Optimization----------------
% generating the initial locations of n particles
[xn,yn]=init_pso(n,range);

% Display the particle paths and contour of the function
figure(2);

% Start iterations
for i=1:Num_iterations,
% Show the contour of the function
contour(x,y,z,15); hold on;

% Find the current best location (xo,yo)
zn=f(xn,yn);
zn_min=min(zn);
xo=min(xn(zn==zn_min));
yo=min(yn(zn==zn_min));
zo=min(zn(zn==zn_min));

% Trace the paths of all roaming particles
% Display these roaming particles
set(gcf,'color','w');
plot(xn,yn,'.',xo,yo,'*'); axis(range);

% Move all the particles to new locations
[xn,yn]=pso_move(xn,yn,xo,yo,c_1,c_2,range);
drawnow;

% Use "hold on" to display paths of particles
hold off;

% History
best(i,1)=xo; best(i,2)=yo; best(i,3)=zo;

end %%%%%% end of iterations

% All subfunctions are listed here
% Intial locations of n particles
function [xn,yn]=init_pso(n,range)

xrange=range(2)-range(1); yrange=range(4)-range(3);
xn=rand(1,n)*xrange+range(1);
yn=rand(1,n)*yrange+range(3);

% Move all the particles toward (xo.yo)
function [xn,yn]=pso_move(xn,yn,xo,yo,a,b,range)
nn=size(yn,2); % a=c_1, b=c_2
xn=xn.*(1-b)+xo.*b+a.*(rand(1,nn)-0.5);
yn=yn.*(1-b)+yo.*b+a.*(rand(1,nn)-0.5);
[xn,yn]=findrange(xn,yn,range);

% Make sure the particles are within the range
function [xn,yn]=findrange(xn,yn,range)
nn=length(yn);
for i=1:nn,
if xn(i)<=range(1), xn(i)=range(1); end
if xn(i)>=range(2), xn(i)=range(2); end
if yn(i)<=range(3), yn(i)=range(3); end
if yn(i)>=range(4), yn(i)=range(4); end
end