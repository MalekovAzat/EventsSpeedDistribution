function [filterValue] = filterValue(val)
    if val ~= 0 
        filterValue = 1/val;
    else
        filterValue = 0;
    end
end