function folder_biases = COMPETITION_dynamic_biases(min_valid_bias, max_valid_bias)

if nargin==0
    min_valid_bias = 5;
    max_valid_bias = 95;
end

% Set the path to the dynamic data folder
CONSTANS = COMPETITION_constants();
dynamic_data_path = CONSTANS.PATH.DATA_DYNAMIC;

% Get a list of all folders in the dynamic data path
folder_list = dir(dynamic_data_path);
folder_list = folder_list([folder_list.isdir]);
folder_list = folder_list(~ismember({folder_list.name}, {'.', '..'}));

% Initialize a data structure to hold biases for each folder
folder_biases = struct('folder_name', {}, 'biases', {});

total_invalid_bias = 0;
total_n = 0;
% Iterate over each folder
for i = 1:numel(folder_list)
    folder_name = folder_list(i).name;
    folder_path = fullfile(dynamic_data_path, folder_name);

    % Get a list of all CSV files in the current folder
    file_list = dir(fullfile(folder_path, '*.csv'));

    % Initialize variables to store biases and valid file count
    biases = [];
    invalid_bias = 0;
    n_schedule = 0;

    % Iterate over each CSV file
    for j = 1:numel(file_list)
        file_path = fullfile(folder_path, file_list(j).name);

        % Read the CSV file into a table
        data = readtable(file_path);

        % Check if the table has 100 rows (excluding header)
        if size(data, 1) == 100 && sum(data.reward_alternative_1)==25 && sum(data.reward_alternative_2)==25
            % Calculate the bias as the average number of 'true' values in the 'is_biased_choice' column
            bias = sum(strcmp(data.is_choice_alternative_1, 'true'));
            n_schedule = n_schedule + 1;
            if min_valid_bias<=bias && bias<=max_valid_bias
                % Add the bias to the biases list
                biases = [biases, bias];                
            else
                invalid_bias = invalid_bias + 1;
            end
        end
    end

    % Store the folder name and biases in the data structure
    folder_biases(i).folder_name = folder_name;
    folder_biases(i).biases = biases;

    % Print the valid file count for the current folder
    fprintf('%s, n = %d, mean bias=%.1f (+- %.1f) (invalid biases: %d)\n', folder_name, length(biases), mean(biases), sem(biases), invalid_bias);
    total_invalid_bias = total_invalid_bias + invalid_bias;
    total_n = total_n + n_schedule;
end
fprintf('Valid schedules n = %d\n', total_n - total_invalid_bias);
fprintf('Total invalid_bias = %d /%d (%.1f%%)\n', total_invalid_bias, total_n, 100*total_invalid_bias/total_n);
end