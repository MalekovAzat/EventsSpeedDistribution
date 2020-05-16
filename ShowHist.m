function [] = ShowHist(vector)
    edges = 10.^linspace(-3, 7, 80);
    histogram(vector, edges);
    set(gca, 'XScale', 'log');
    set(gca, 'YScale', 'log');
end