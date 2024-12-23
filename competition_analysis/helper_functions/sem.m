function standard_error_of_the_mean = sem(v)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
standard_error_of_the_mean = std(v)./sqrt(length(v)-1);
end

