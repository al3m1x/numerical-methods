function plot_circles(a, circles, index_number)
    figure;
    hold on;
    for i = 1:size(circles, 1)
        plot_circle(circles(i, 3), circles(i, 1), circles(i, 2));
    end
    hold off;
    title(['Circles - ', num2str(index_number)]);
    xlabel('x');
    ylabel('y');
    axis equal;
    axis([0 a 0 a]);

    print -dpng zadanie1.png 
end