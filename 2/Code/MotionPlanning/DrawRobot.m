function DrawRobot(HFigure, XYRobot)

% This function draws a robot field
% Inputs:
%   HFigure: A handle to the figure used for drawing
%   XYRobot:A 1x2 vector that represents the X, Y coordinates of the
%           robot.

% Set the current figure to the given figure 
set(0,'CurrentFigure', HFigure);
% Hold the graph in the current figure to start drawing
hold on;

% Draw the robot
plot(XYRobot(1), XYRobot(2), 'o', 'MarkerEdgeColor', 'b', ... 
      'MarkerFaceColor', 'b', 'MarkerSize', 10);
  
% Update the figure 
drawnow;

% Turn the hold off
hold off;