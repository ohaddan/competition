function COMPETITION_verify_reward_allocation_for_schedule(schedule_id, reward_alternative_1, reward_alternative_2)
CONSTANTS = COMPETITION_constants();
folder_path = fullfile(CONSTANTS.PATH.DATA_STATIC, ['schedule_', num2str(schedule_id)]);

% Get a list of all CSV files in the folder
file_list = dir(fullfile(folder_path, '*.csv'));

% Iterate over each file in the folder
for i = 1:numel(file_list)
    file_path = fullfile(folder_path, file_list(i).name);

    % Read the CSV file
    data = readtable(file_path);

    % Compare the columns with the input vectors
    if ~all(data.reward_alternative_1==reward_alternative_1) || ~all(data.reward_alternative_2==reward_alternative_2)
        disp(['Incorrect data in file: ', file_list(i).name]);
    end
end

% Check if all files are verified
if i == numel(file_list)
    disp(['All files in "', folder_path, '" are verified.']);
end
end
