function  [ql_hom_lab, ql_hom_online, ql_het_lab, ql_het_online, catie_decisions_probabilities] = ...
COMPETITION_empirical_decisions_probabilities()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

SAVED_CALCULATION_PATH = 'participants_data_analysis\COMPETITION_participants_data_analysis_saved_calculation\CALCULATION_RESULT_models_empirical_deicision_probabilities.mat';
if exist(SAVED_CALCULATION_PATH, 'file') == 2
    % If it exists, load the result variable
    load(SAVED_CALCULATION_PATH, ...
    'catie_decisions_probabilities',...
    'ql_hom_lab', 'ql_hom_online',...
    'ql_het_lab', 'ql_het_online');

else
    DATA_PATH = 'C:\Users\ojd5\ohad_projects\competition\data and analysis\competition_validate_submissions\prepare_to_upload\participants_data';

    % Define the folder names for each model
    model_names = {'model_1', 'model_2', 'model_3', 'model_4', 'model_5', 'model_6', 'model_7', 'model_8', 'model_9', 'model_10', 'model_11', 'model_12'};

    n_participants = 0;
    % Count total number of participants
    for i = 1:numel(model_names)
        % Define the path to the current model folder
        model_path = fullfile(DATA_PATH, model_names{i});

        % Find all the csv files in the current model folder
        csv_files = dir(fullfile(model_path, '*.csv'));
        n_participants = n_participants + length(csv_files);
    end

    N_TRIALS = 100;
    catie_decisions_probabilities = zeros(n_participants, N_TRIALS);
    ql_hom_lab = zeros(n_participants, N_TRIALS);
    ql_hom_online = zeros(n_participants, N_TRIALS);
    ql_het_lab = zeros(n_participants, N_TRIALS);
    ql_het_online = zeros(n_participants, N_TRIALS);

    participant_index = 1;
    % Loop over each model folder and calculate the biases for all the csv files in each folder
    for i = 1:numel(model_names)

        % Define the path to the current model folder
        model_path = fullfile(DATA_PATH, model_names{i});

        % Find all the csv files in the current model folder
        csv_files = dir(fullfile(model_path, '*.csv'));

        % Initialize the progress bar
        progress_bar = waitbar(0, sprintf('Calculating biases for model %s...', i));

        % Loop over each csv file and calculate the bias
        for j = 1:numel(csv_files)

            % Calculate each model's choice probabilities of current
            % participant
            csv_data = readtable(fullfile(model_path, csv_files(j).name));
            is_choice_in_1 = strcmp(csv_data.is_biased_choice, 'true');
            catie_decisions_probabilities(participant_index, :) = COMPETITION_CATIE_schedule_choice_probability_hetro(csv_data.biased_reward, csv_data.unbiased_reward, is_choice_in_1);
            ql_hom_lab(participant_index, :) = COMPETITION_QL_HOM_lab_schedule_choice_probabilities(csv_data.biased_reward, csv_data.unbiased_reward, is_choice_in_1);
            ql_hom_online(participant_index, :) = COMPETITION_QL_HOM_online_schedule_choice_probabilities(csv_data.biased_reward, csv_data.unbiased_reward, is_choice_in_1);
            ql_het_lab(participant_index, :) = COMPETITION_QL_HET_lab_schedule_choice_probabilities(csv_data.biased_reward, csv_data.unbiased_reward, is_choice_in_1);
            ql_het_online(participant_index, :) = COMPETITION_QL_HET_online_schedule_choice_probabilities(csv_data.biased_reward, csv_data.unbiased_reward, is_choice_in_1);

            % Update the progress bar
            waitbar(participant_index/n_participants, progress_bar, sprintf('Calculating choice probabilities for participant %d... %.0f%%', participant_index, participant_index/n_participants*100));
            participant_index = participant_index + 1;
        end

        % Close the progress bar
        close(progress_bar);
    end
save(SAVED_CALCULATION_PATH,...
    'catie_decisions_probabilities',...
    'ql_hom_lab', 'ql_hom_online',...
    'ql_het_lab', 'ql_het_online');
end
end

% 'catie_biases', schedule_id=1
% 'ql_het_online_biases', schedule_id=6
% 'ql_hom_lab_biases', schedule_id=7
% 'ql_hom_online_biases', schedule_id=9
% 'ql_het_lab_biases', schedule_id=10