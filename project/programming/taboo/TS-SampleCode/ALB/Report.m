clear 
clc
tabu_length=[5 10 15 25 50];
average_random=[1.90 1.95 0.832 1.07 2.09];
average_ordered=[2.33 1.91 1.91 0.707 1.91];
plot(tabu_length,average_ordered,'color','blue')
set(gcf,'color','w');
hold on
plot(tabu_length,average_random,'color','red')
legend('Ordered Initial Sequence','Random Initial Sequence')
xlabel('Tabu Length')
ylabel('Average SI')
grid on
set(gca,'XTick',[5 10 15 25 50])

