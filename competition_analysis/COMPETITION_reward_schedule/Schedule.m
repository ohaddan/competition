classdef Schedule
    properties
        schedule_id         % Schedule name
        name                % Schedule name
        biases              % List of empirical biases measured from participants
        reward_schedule_1   % Rewards for alternative 1
        reward_schedule_2   % Rewards for alternative 2
        n_participants      % Length of biases
        color               % color for plotting
    end
    
    methods
        % Constructor
        function obj = Schedule(schedule_id, name, biases, reward_schedule_1, reward_schedule_2, color)
            if nargin == 0
                obj.schedule_id = NaN;
                obj.name = '';
                obj.biases = [];
                obj.reward_schedule_1 = [];
                obj.reward_schedule_2 = [];
                obj.color = NaN;
            else
                obj.schedule_id = schedule_id;
                obj.name = name;
                obj.biases = biases;
                obj.reward_schedule_1 = reward_schedule_1;
                obj.reward_schedule_2 = reward_schedule_2;
                obj.n_participants = length(biases);
                obj.color = color;
            end
        end
    end
end
