function COMPETITION_plot_schedule(r1, r2)
%% Example use: plot_sequence(1:25, 76:100)
target_rewards = find(r1);
anti_targe_rewards = find(r2);
plot_rewards(target_rewards, anti_targe_rewards)

    function plot_rewards(target_rewards, anti_targe_rewards)
        %% Example use: plot_sequence(1:25, 76:100)

        function plot_reward(x, y)
            %         plot(x, y, 'o', 'MarkerSize', 15, 'LineWidth', 4, 'Color', 'k');
            plot(x, y, 'o', 'MarkerSize', 4, 'MarkerFaceColor', [0.75 0.04 0.1]	, 'Color', 'None');
        end

        function plot_non_reward(x,y)
            plot(x, y, 'o', 'MarkerSize', 6, 'LineWidth', 1, 'Color', 'k');
        end

        hold on

        % For legend
        plot_non_reward(101,1);
        plot_reward(101,1);

        % Plot all trials
        N_TRIALS = 100;
        trials = 1:N_TRIALS;
        plot_non_reward(trials , 1*ones(1, N_TRIALS));
        plot_non_reward(trials , 2*ones(1, N_TRIALS));

        % Plot rewards
        plot_reward(anti_targe_rewards, 1*ones(1, 25))
        plot_reward(target_rewards, 2*ones(1, 25))

        % Beutify
        ylim([0 3]);
        xlim([0 100]);
        set(gca, 'YTick', [0 3], 'YTickLabel', {'Alternative 2', 'Alternative 1'},...
            'xtick', 0:20:100,...
            'FontSize', 10, 'XGrid', 'on');
        xlabel('Trial', 'FontSize', 20, 'FontWeight','bold');
        set(gca, 'FontSize', 16)
    end


end