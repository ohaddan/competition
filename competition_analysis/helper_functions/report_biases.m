function report_biases(biases, schedule_name)
%REPORT_BIASES Summary of this function goes here
%   Detailed explanation goes here
mean_biases = mean(biases);
sem_biases = std(biases) / sqrt(length(biases)-1);
fprintf(['For ' schedule_name ', The mean of the biases is %.1f with a'...
    ' standard error of the mean of %.1f, tested on %d participants.\n'], ...
    mean_biases, sem_biases, length(biases));
end