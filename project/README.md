# Group 27: Complex Task Allocation

## Team Members

 - Lucas Wojciechowski, 20367700
 - Ariel Weingarten,    20366892
 - Alexander Maguire,   20396195
 - Dane Carr,           20384873
 - Austin Dobrik,       20389987


## Topic

In mobile surveillance systems, complex task allocation addresses how to
optimally assign a set of surveillance tasks to a set of mobile sensing agents
to maximize overall expected performance, taking into account the priorities of
the tasks and the skill ratings of the mobile sensors. Ref. Alaa Khamis, Ahmed
Elmogy and Fakhreddine Karray, "Complex Task Allocation in Mobile Surveillance
Systems," Journal of Intelligent and Robotic Systems, Springer], [Mohamed
Badreldin, Ahmed Hussein and Alaa Khamis, "A Comparative Study between
Optimization and Market-based Approaches to Multi-robot Task Allocation,"
Advances in Artificial Intelligence Journal, 2013.] and [Alaa Khamis,
Cooperative Multirobot Systems, Plenary Talk at IAC2014].


## Project Layout

Our report exists in this folder, with code in the `code` folder. The code is
laid out by metaheuristic, each folder contains a file called `solve.m` which
implements the metaheuristic. Code shared by the algorithms is stored
centralized in the `code` directory.

We ran our code through docker via the `make` command. Algorithms may be run on
differing datasets by (for example):

    $ make acoLarge.csv
    $ make tsMedium.csv

etc.


