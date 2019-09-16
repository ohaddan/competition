# This file provides an explanation and example usage of a dynamic allocation
# file for the bias induction competition. For more details on the competition,
#  see [here](http://decision-making-lab.com/competition/index.html)

###############################################################################
# What is a dynamic allocation model?
###############################################################################
# A dynamic allocation model is used to determine the rewards in a single trial
#  of an experiment run as part of the bias induction competition. This output
#  should indicate the allocation of rewards for the two alternatives used in
#  the experiment in a specific trial. The rewards available for allocation are
#  binary (either 1 or 0) and are constrained such that during the 100 trials
#  of the experiment, each of the alternatives should be allocated exactly 25
#  rewards (i.e. 1's, and 75 should be allocated with 0's). The input of the
#  dynamic allocation model is current experiment's history, namely previous
#  allocations and their respective choices.
#
# The goal of the competition, and the dynamic allocation model, is to design
# an allocation mechanism that would maximize the choices in one specific
# alternative, termed the "target alternative". In the experiment, the target
# alternative will be placed randomly either on the left or the right part of
# the participant's screen. However, in the output of the allocation model, the
#  target alternative should be always placed first.

###############################################################################
# How should a dynamic allocation model file be used
###############################################################################
# In the course of an experiment, your dynamic allocation model would be called
#  repeatedly, once for every trial, and the allocation provided by the
#  will be revealed to the participant, according to her choice.
#
# A. Receiving input: your model will be called with two command-line arguments
#  that you may parse
# e.g. with [sys.argv](https://docs.python.org/3.7/library/sys.html#sys.argv)).
#     1. The first input is a list of previous allocations to the target
#      alternative. Each entry in the list is either 1, indicating that in that
#      index a reward was allocated, or 0, indicating that it was not. For
#      example, the list [1, 0, 0, 0] received as the first input for your
#      model indicates that the experiment is currently at its 5'th trial,
#      that on the first trial a reward was allocated to the target alternative
#      and that no rewards were allocated in trial 2, 3, and 4.
#     2. The second input is in the same format as the first, but indicating
#      previous rewards to the second ("anti-target") alternative. Hence, for
#      example, the list [0, 1, 1] as the second input to your model indicates
#      that it is currently the 4'th trial, that on the first trial rewards
#      were not allocated to the anti-target alternative and that on the second
#      and third trial rewards were allocated to that alternative.
#     3. The third input is a list of previous choices, where 1's indicate a
#      choice in the target alternative and 0's indicate choice in the
#      anti-target alternative. For example, the list [1, 1, 1, 0, 0, 0]
#      received as the third input indicates that it is currently the 7'th
#      trial, that on the first three trials the target side was chosen by the
#      user and that on the last three trials it was not.
# B. Providing output - Your model should indicate the allocation of rewards
# by printing (to the standard sys.stdout, e.g. using print) a single string in
#  the format of "(T, N)", where both T and N are either the character 1 or 0,
#  T represents the allocation to the target side and N the allocation the
#  non-target side.
# Hence, your model output should be one of the following four strings
# "(0, 0)",  "(0, 1)",  "(1, 0)",  "(1, 1)". To prevent formatting issues,
# you may use the "output" function provided in this file.

###############################################################################
# Code start
###############################################################################
import sys
import ast
###############################################################################
# Template - Insert your code here
###############################################################################
TOTAL_REWARDS = 25
NUMBER_OF_TRIALS = 100
REWARD = 1
NO_REWARD = 0


def allocate(target_allocations, anti_target_allocations, is_target_choices):
    """
    :param target_allocations: A binary list, where True values at index i
            indicate a reward was allocated to the target side on trial i.
    :param anti_target_allocations: A binary list, where True values at index i
            indicate a reward was allocated to the anti-target side on trial i.
    :param is_target_choices: A binary list, where True values at index i
            indicate the target_side was chosen on that index.
    :return: A two-element tuple where the first binary element indicate
                whether a reward should be allocated to the target side,
                and the second whether a reward should be allocated to the
                anti-target side.
    """
    trial = len(target_allocations)
    # In first two trials put rewards in the target side only
    if trial < 2:
        return REWARD, NO_REWARD

    target_alternative, anti_target_alternative = None, None
    # If previous choice was of the target side
    if is_target_choices[-1]:
        # If the choice yielded a reward
        if target_allocations[-1] == REWARD:
            # A WSLS agent will choose this side again - so assign a reward to
            # the target side again and also a reward to the anti-target side,
            # since the agent will not choose it currently so it's a way to
            # "discard" rewards on the anti-target side on unchosen trials
            target_alternative, anti_target_alternative = REWARD, REWARD
        else:
            # The agent chose the target side but did not receive a reward, so
            # the agent will switch - put no rewards on the anti-target side
            # (so the agent won't think it is good) and no reward on the target
            # side (not to "waste" it)
            target_alternative, anti_target_alternative = NO_REWARD, NO_REWARD
    # Previous choice was of the anti-target side
    else:
        # If the choice yielded a reward
        if anti_target_allocations[-1] == REWARD:
            # The agent is likely to choose the anti-target again, so don't put
            # rewards there to discourage such choices. Also, don't put rewards
            # on the target side so as not to waste them.
            target_alternative, anti_target_alternative = NO_REWARD, NO_REWARD
        # The choice did not yield a reward
        else:
            # The agent will switch to the target side, so put a reward there
            # to encourage such choices. Also, put a reward on the anti-target
            # to "waste" it.
            target_alternative, anti_target_alternative = REWARD, REWARD
    # We assume that in the first 15 trials, the user is somewhat
    # likely to sample the anti-target side so we start assigning
    # rewards to that side only after the 15th trial
    if trial < 15:
        anti_target_alternative = NO_REWARD

    return constrain(target_allocations, target_alternative),\
           constrain(anti_target_allocations, anti_target_alternative)


def constrain(previous_allocation, current_allocation):
    """
    Constrain the current allocation based on previous allocations, such that
     both (1) no more than 25 rewards are allocated and (2) assuring that all
     25 rewards are indeed allocated.
    :param previous_allocation:
    :param current_allocation:
    :return: A constrained allocation
    """
    allocated_rewards = sum(previous_allocation)

    # If all rewards were already allocated, no more rewards may be allocated
    if allocated_rewards>=TOTAL_REWARDS:
        return 0

    # If there are as many trials left as rewards left, in all remaining trials
    # rewards should be allocated
    current_trial_number = len(previous_allocation)
    remaining_trials = NUMBER_OF_TRIALS - current_trial_number
    if remaining_trials == (TOTAL_REWARDS-allocated_rewards):
        return 1

    # No constrain should be imposed
    return current_allocation


###############################################################################
# Template Infrastructure - Do not change
###############################################################################
REWARDS_BOTH_ALTERNATIVES = '1, 1'
REWARD_TARGET_ONLY = '1, 0'
REWARD_ANTI_TARGET_ONLY = '0, 1'
NO_REWARDS_BOTH_ALTERNATIVES = '0, 0'


def parse_input():
    """
    Get the command-line parameters with which this script is initiated (as
    explained in the script's intro, see "How should a dynamic allocation model
    file be used")
    :return: A tuple with previous
        (rewards allocation to target alternative: {1=reward, 0=no reward},
        rewards allocation to anti-target alternative: {1=reward, 0=no reward},
        choices: {1=choice in target alternative, 0=choice in anti-target})
    """
    if sys.argv[1]=="[]": #This is first trial, don't try parsing:
        return [], [], []
    else:
        target_allocations = parse_lst(sys.argv[1])
        anti_target_allocations = parse_lst(sys.argv[2])
        is_target_choices = parse_lst(sys.argv[3])
        return target_allocations, anti_target_allocations, is_target_choices


def output(target, anti_target):
    """
    Output the allocation of rewards for next trial by printing them to
     standard output.
     NOTE: It is the reward allocator (i.e. your) responsibility to enforce the
            constraint of exactly 25 allocations per alternatives (it will
            otherwise be bluntly enforced and may alter your allocations).
    :param target: A boolean indicator of reward to the alternative in which
                    *maximal* choice should be induced.
                    True indicate an allocation of reward in next trial and
                    false indicate no reward allocation.
    :param anti_target: A boolean indicator of reward to the alternative in
                    which *minimal* choice should be induced.
                    True indicate an allocation of reward in next trial and
                    false indicate no reward allocation.

    :return: None
    """
    if target and anti_target:
        print(REWARDS_BOTH_ALTERNATIVES)
    elif target and not anti_target:
        print(REWARD_TARGET_ONLY)
    elif not target and anti_target:
        print(REWARD_ANTI_TARGET_ONLY)
    elif not target and not anti_target:
        print(NO_REWARDS_BOTH_ALTERNATIVES)

###############################################################################
# Debug
# if you want it to output to
# http://decision-making-lab.com/visual_experiment/cmptn_remote/scripts/display_params.php
# disable any other prints (specifically the one from "output")
###############################################################################
counter = 0
text_agg = ''
def debug(txt="hi"):
    global counter
    global text_agg
    counter = counter + 1
    text_agg = text_agg + " ### " + str(counter) + ":" + str(txt)
    print(text_agg)

def parse_lst(lst):
    as_python_lst = lst.strip('[').strip(']').split(',')
    as_python_elements = [ast.literal_eval(el) for el in as_python_lst]
    return as_python_elements

###############################################################################
# Run
###############################################################################

if __name__ == '__main__':
    input = parse_input()
    allocation = allocate(*input)
    output(*allocation)
