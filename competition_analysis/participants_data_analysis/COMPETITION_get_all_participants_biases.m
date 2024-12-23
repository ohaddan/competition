function [model_biases, model_n_invalid] = COMPETITION_get_all_participants_biases(SAVED_CALCULATION_PATH, min_valid_bias, max_valid_bias)
if exist(SAVED_CALCULATION_PATH, 'file') == 2
    % If it exists, load the result variable
    load(SAVED_CALCULATION_PATH, 'model_biases', 'model_n_invalid');
else
    if nargin==1
        min_valid_bias = 5;
        max_valid_bias = 95;
    end
    CONSTANS = COMPETITION_constants();
    DATA_PATH = CONSTANS.PATH.DATA_STATIC;

    % Define the folder names for each model
    schedule_names = {'schedule_0', 'schedule_1', 'schedule_2', 'schedule_3', 'schedule_4', 'schedule_5', 'schedule_6', 'schedule_7', 'schedule_8', 'schedule_9', 'schedule_10', 'schedule_11'};

    % Initialize a cell array to hold the biases for each model
    biases = cell(size(schedule_names));
    n_invalid = zeros(size(schedule_names));

    % Loop over each model folder and calculate the biases for all the csv files in each folder
    for i = 1:numel(schedule_names)

        % Define the path to the current model folder
        model_path = fullfile(DATA_PATH, schedule_names{i});

        % Find all the csv files in the current model folder
        csv_files = dir(fullfile(model_path, '*.csv'));

        % Initialize the progress bar
        progress_bar = waitbar(0, sprintf('Calculating biases for model %s...', i));

        % Loop over each csv file and calculate the bias
        for j = 1:numel(csv_files)

            % Read in the csv file
            data = readtable(fullfile(model_path, csv_files(j).name));

            if size(data, 1) ~= 100  && sum(data.reward_alternative_1)==25 && sum(data.reward_alternative_2)==25
                continue
            end

            % Count the number of rows with "true" in the "is_biased_choice" column
            bias = sum(strcmp(data.is_choice_alternative_1, 'true'));

            if min_valid_bias<=bias && bias<=max_valid_bias
                % Add the bias to the biases list
                biases{i}(end+1) = bias;
            else
                n_invalid(i) = n_invalid(i) + 1;
            end
            % Update the progress bar
            waitbar(j/numel(csv_files), progress_bar, sprintf('Calculating biases for model %d... %.0f%%', i, j/numel(csv_files)*100));
        end

        % Close the progress bar
        close(progress_bar);
    end

    model_biases = dictionary(schedule_names, biases);
    model_n_invalid = dictionary(schedule_names, n_invalid);
    save(SAVED_CALCULATION_PATH, 'model_biases', 'model_n_invalid');
end
end