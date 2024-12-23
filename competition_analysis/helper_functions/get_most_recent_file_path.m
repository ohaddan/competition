function most_recent_file_path = get_most_recent_file_path(SAVED_COMPUTATION_PATH, file_name_prefix)
% GET_MOST_RECENT_FILE_PATH Returns the path to the most recent file in a folder.
%   GET_MOST_RECENT_FILE_PATH(SAVED_COMPUTATION_PATH, FILE_NAME_PREFIX) returns
%   the path to the most recent file in the directory specified by
%   SAVED_COMPUTATION_PATH that matches the prefix specified by
%   FILE_NAME_PREFIX. If no files match the prefix, returns NaN.
%
%   Example:
%       most_recent_file_path = get_most_recent_file_path('/path/to/folder/', 'computation');
%
%   Inputs:
%       - SAVED_COMPUTATION_PATH: The full path to the folder where files are stored. 
%         The path should end with a file separator (e.g., '/', '\').
%       - FILE_NAME_PREFIX: The prefix of the filename to match.
%
%   Outputs:
%       - MOST_RECENT_FILE_PATH: The full path to the most recent file, including the filename.
%         Returns NaN if no files match the prefix.


% get a list of saved computation files in the folder
file_list = dir(fullfile(SAVED_COMPUTATION_PATH, [file_name_prefix '*']));

% if there are files in the folder
if ~isempty(file_list)
    % sort the file list by date
    [~, sorted_indices] = sort([file_list.datenum], 'descend');
    sorted_file_list = file_list(sorted_indices);
    
    % load the most recent file
    most_recent_file = sorted_file_list(1).name;
    most_recent_file_path = fullfile(SAVED_COMPUTATION_PATH, most_recent_file);
else
    most_recent_file_path = NaN;
end
