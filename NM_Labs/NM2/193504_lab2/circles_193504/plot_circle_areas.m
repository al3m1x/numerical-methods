function plot_circle_areas(circle_areas, index_number)
figure;
    plot(circle_areas);
    
    title(['Circle areas - ', num2str(index_number)]);
    xlabel('Circle number');
    ylabel('Circle area');
    
    print -dpng zadanie3.png;
end