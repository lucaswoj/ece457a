%--------------------Main Program--------------------%
clear;
clc;
tic;
global data B Pd
data=[0.007 7 240 100 500 
    0.0095 10 200 50 200 
    0.009 8.5 220 80 300 
    0.009 11 200 50 150 
    0.008 10.5 220 50 200 
    0.0075 12 120 50 120];
% Loss coefficients it should be square matrix of
% size nXn where n is the no of plants
B=1e-4*[0.14 0.17 0.15 0.19 0.26 0.22 
    0.17 0.6 0.13 0.16 0.15 0.2 
    0.15 0.13 0.65 0.17 0.24 0.19 
    0.19 0.16 0.17 0.71 0.3 0.25 
    0.26 0.15 0.24 0.3 0.69 0.32 
    0.22 0.2 0.19 0.25 0.32 0.85];
% Demand (MW)
Pd=700;
% setting the genetic algorithm parameters.
options = gaoptimset;
options = gaoptimset('PopulationSize',50,'Generations',500,'TimeLimit',200,'StallTimeLimit', 100,'PlotFcns',@gaplotbestf,@gaplotbestindiv);
[x ff]=ga(@eldga,5,options);
[F P1 Pl]=eldga(x)
tic;

