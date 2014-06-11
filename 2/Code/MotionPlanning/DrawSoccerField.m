function HFigure = DrawSoccerField(XYGoal, XYObstacles, ...
                                   RadiusObstacles, FieldSize)

% This function draws a soccer field
%
% Inputs:
%   XYGoal: A 1x2 vector that represents the X, Y coordinates of the goal 
%   XYObstacles: A mx2 matrix that represents the X, Y coordinates of the
%                obstacles. Where m is the number of obstacles.
%   RadiusObstacles: An mx1 vector that represents the radius of the 
%                    obstacles.
%   FieldSize: A 1x2 vector that contains the field width and height. 
%
% Outputs:
%   HFigure: A handle to the output figure

% Create a new figure
HFigure = figure('Name', 'Soccer Field');

% Hold the graph in the current figure to start drawing
hold on;

% Set the field size
axis([1 FieldSize(1) 1 FieldSize(2)]);

% Draw the obstacles
for o = 1:size(XYObstacles, 1)
    plot(XYObstacles(o, 1), XYObstacles(o, 2), 'o', ...
        'MarkerEdgeColor', 'r', 'MarkerFaceColor', 'r', ...
        'MarkerSize', RadiusObstacles(o));
end

% Draw the goal
line(XYGoal(1) + [-10, 10], XYGoal(2) + [0 0], ...
     'Color', 'k', 'LineWidth', 20);

% Turn the hold off
hold off;