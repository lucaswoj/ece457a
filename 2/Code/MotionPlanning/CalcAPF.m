function APF = CalcAPF(XYRobot, XYGoal, XYObstacles, ...
                       RadiusObstacles, FieldSize)

% This function calculates the artificial potential field (APF) at a given
% location in the soccer field
%
% Inputs:
%   XYRobot:A 1x2 vector that represents the X, Y coordinates of the
%           robot.
%   XYGoal: A 1x2 vector that represents the X, Y coordinates of the goal 
%   XYObstacles: A mx2 matrix that represents the X, Y coordinates of the
%                obstacles. Where m is the number of obstacles.
%   RadiusObstacles: An mx1 vector that represents the radius of the 
%                    obstacles.
%   FieldSize: A 1x2 vector that contains the field width and height.
%
% Outputs:
%   APF: The value of the field at XYRobot. Inf if the XYRobot 
%        is outside the field 

% Get the number of obstacles
NumObsts = size(XYObstacles, 1);

% Set the APF parameters
Ka = 1e-2;
Kr = 1e-8;
n = 2;

% Set the limited distance of the potential field influence as a function 
% of the obstacle radius
p = 3 * RadiusObstacles;

% Calculate the distance to the goal and the obstacle
DistGoal = sqrt(sum((XYRobot - XYGoal).^2, 2));
DistObst = sqrt(sum((repmat(XYRobot, NumObsts, 1) - XYObstacles).^2, 2));

% Return Inf if at the location of an obstacle or outside the field
if any(DistObst < RadiusObstacles) || ...
   any(XYRobot < 0) || any(XYRobot > FieldSize)
    APF = Inf;
    return;
end

% Calculate the attractive and repulsive fields
Ua = 0.5 .* Ka .* DistGoal.^2;
Ur = 0.5 .* Kr .* (1./DistObst - 1./p).^2 ...
    .* repmat(DistGoal, NumObsts, 1).^n .* (DistObst < p);

% Calculate the total artificial potential field
APF = Ua + sum(Ur);
