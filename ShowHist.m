function [] = ShowHist(vector)
    edges = 10.^linspace(-2, 0.5, 80);
    histogram(vector, edges);
    set(gca, 'XScale', 'log');
    set(gca, 'YScale', 'log');
end