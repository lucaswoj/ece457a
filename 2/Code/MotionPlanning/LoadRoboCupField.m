function [XYGoal, XYObstacles, RadiusObstacles, FieldSize] = ...
         LoadRoboCupField()

% This function loads the data of the RoboCup soccer field.
%
% Inputs:
%
% Outputs:
%   XYGoal: A 1x2 vector that represents the X, Y coordinates of the goal 
%   XYObstacles: A mx2 matrix that represents the X, Y coordinates of the
%                obstacles. Where m is the number of obstacles.
%   RadiusObstacles: An mx1 vector that represents the radius of the 
%                    obstacles.
%   FieldSize: A 1x2 vector that contains the field width and height. 

% Set the field size
FieldSize = [152 274];

% Set the goal position
XYGoal = [76 274];

% Set the the obstacle positions
XYObstacles = [22, 103;    37, 70;     43, 207;    51, 127;    63, 200;    
    73, 165;   76, 219;   82, 102;    102, 50;    114, 150;   120, 63;    
    140, 200];

% Set the radius of the obstacles
RadiusObstacles = [10; 20; 15; 10; 30; 17; 12; 25; 10; 13; 25; 15];




