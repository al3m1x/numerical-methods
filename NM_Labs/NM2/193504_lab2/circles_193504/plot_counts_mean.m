function plot_counts_mean(counts_mean)
figure;
    plot(counts_mean);
    
    title(['Mean counts']);
    xlabel('Circle number');
    ylabel('Mean count');
print -dpng zadanie5.png 
end