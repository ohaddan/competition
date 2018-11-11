# This is a template for a static mechanism. All lines with a "#" prefix
# are an explanation for the template and *not* part of the submitted
# reward schedule.
# The rewards for both alternatives should be listed in square brackets
# ("[]") and separated by commas. Each entry in the list of rewards should
# be either '1' (indicating a reward) or '0' (indicating no reward).
# The first line details the reward allocation to the "target" side,
# the side in which the reward-schedule should maximize the number of choices.
# The second line describes the rewards in the "anti-target" side in which
# the number of choices should be minimized. Note that each list should include
# exactly 25 rewards ('1's) and 75 trials without a reward ('0's).
# To edit your reward schedule, change only the order of rewards in both lists
# (i.e. the "=" sign, the order of the lines and the text preceding it should not
# be modified).
# In the following example, the target alternative is assigned rewards in the
# first 25 trials (and no rewards in all consecutive  future trials) whereas the allocation
# of rewards to the anti-target alternative starts with 75 trials of no reward,
# followed by 25 trials of rewards.
bias_target = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
anti_bias = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
