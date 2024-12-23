function schedule_table = COMPETITION_all_schedules_biases(all_schedules)
    num_schedules = length(all_schedules.keys);
    schedule_id = (0:num_schedules-1)';
    n_biases = zeros(num_schedules, 1);
    mean_biases = zeros(num_schedules, 1);
    sem_biases = zeros(num_schedules, 1);
    mean_biases_rounded = zeros(num_schedules, 1);
    sem_biases_rounded = zeros(num_schedules, 1);

    for ii = 1:num_schedules
        current_schedule_id = schedule_id(ii);
        current_biases = all_schedules(current_schedule_id).biases;
        n_biases(ii) = length(current_biases);
        mean_biases(ii) = mean(current_biases);
        sem_biases(ii) = sem(current_biases);

        mean_biases_rounded(ii) =  round(mean_biases(ii), 1);
        sem_biases_rounded(ii) = round(sem_biases(ii), 1);
    end

    schedule_table = table(schedule_id, n_biases, mean_biases_rounded, sem_biases_rounded);
    schedule_table.Properties.VariableNames = {'schedule_id', 'n_biases', 'mean_biases', 'std_biases'};
    
    disp(schedule_table);
    disp(['Total number of valid participants (n): ' num2str(sum(n_biases))]);

end
