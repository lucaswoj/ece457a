% boundaries
bounds = [-10 10];
% pop size
n = 10;
% number of iterations
numits = 100;
% numer of mutations per it
nummut = 1;
f = @multipeak;
% ezplot(f,[-10 10])
% pause
blength = bounds(2)-bounds(1);
% initial population
pop = rand(1,n)*blength + bounds(1);
for it=1:numits
% fitness eval
for i=1:n, 
    fpop(i) = feval(f, pop(i));
end
maxf(it) = max(fpop);
meanf(it) = mean(fpop);
% subtract lowest fitness in order to normalize
m=min(fpop);
fpop=fpop-m;
cpop(1) = fpop(1);
for i=2:n, cpop(i) = cpop(i-1) + fpop(i); end
% SELECTION
total_fitness = cpop(n);
% use roulette selection (-> need pos. fitness!)
for i=1:n
p=rand*total_fitness;
% now find first index
j=find(cpop-p>0);
if isempty(j)
j=n;
else
j=j(1);
end
parent(i)=pop(j);
end
% pop, fpop, parent, pause
% REPRODUCTION
% parents 2i-1 and 2i make two new children
% 2i-1 and 2i crossover
% use arithmetic crossover
for i=1:2:n
r=rand;
pop(i) = r*parent(i) + (1-r)*parent(i+1);
pop(i+1) = (1-r)*parent(i) + r*parent(i+1);
end
% mutation
% use uniform mutation
for i=1:nummut
pop(ceil(rand*n)) = bounds(1) + rand*blength;
end
end
pop
for i=1:n, fpop(i) = feval(f, pop(i)); end
fpop
close all
% Plotting the given function
ezplot(@multipeak,[-10 10])
hold on
[y,xind]=max(fpop);
set(gcf,'color','w');
plot(pop(xind),y,'ro')
figure, plot(maxf), hold on, plot(meanf,'g');
set(gcf,'color','w');
xlabel('Variable x');
ylabel('Max and Mean of the function');

