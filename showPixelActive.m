function [] = showPixelActive(x, y, dataMatrix, duration)
        ev = [];
        for t = 1:duration
            z = dataMatrix(x,y,t);
            ev = [ev, z];
        end
        ln = plot(1:duration, ev);
        ln.Marker = 'o';
        xlabel('t');
        ylabel('D(150,150)');
            ylim([-1 20]);
end
