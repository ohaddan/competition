# This file provides an explanation and example usage of a dynamic allocation
# file for the bchoice engineering competition. For more details on the competition,
# see [here](http://decision-making-lab.com/competition/index.html)

###############################################################################
# What is dynamic allocation?
###############################################################################
#  A dynamic allocation model is used to determine the rewards in a single trial
#  for a single subject, participating in the experiment of The Choice
#  Engineering Competition. The allocation mechanism should indicate whether or
#  not to allocate a reward for both of the experiment’s two alternatives.
#  The rewards available for allocation are binary (either 1 or 0) and are
#  constrained such that during the 100 trials of the experiment, each of the
#  alternatives should be associated with exactly 25 rewards (i.e. 1's, and
#  75 should be associated with 0's). The input to the dynamic allocation mechanism
#  is current experiment's history, namely previous reward allocations and
#  previous choices, and its output is allocation of rewards for the next trial.
#
# The goal of the competition and the dynamic allocation model is to
#  generate an allocation mechanism that would maximize the choices of humans
#  in one specific alternative, termed the "target alternative". In the
#  competition’s experiment, the target alternative will be placed randomly
#  either on the left or the right part of the participant's screen. However,
#  in the output of the allocation mechanism, the target alternative should be
#  always placed first (see below).

###############################################################################
# How should a dynamic allocation file be used
###############################################################################
# In the course of an experiment, your dynamic allocation model would be called
#  repeatedly, once for every trial, and the allocation indicated by your
#  algorithm will be revealed to the participant. Note that the paradigm used
#  in the competition is that of “partial feedback”, by which only the reward
#  associated with the chosen alternative is revealed (the reward associated
#  with the unchosen alternative is not). Hence, only one of the rewards output
#  by the dynamic allocation mechanism is actually revealed to the subject,
#  according to her choice.
#
# A. Receiving input: your function will be called with three command-line
#  arguments that you may parse
# e.g. with [sys.argv](https://docs.python.org/3.7/library/sys.html#sys.argv)).
#     1. The first input is a list of previous allocations to the target
#      alternative. Each entry in the list is either 1, indicating that in that
#      index a reward was allocated, or 0, indicating that it was not. For
#      example, the list [1, 0, 0, 0] received as the first input for your
#      program indicates that the experiment is currently at its 5'th trial,
#      that on the first trial a reward was allocated to the target alternative
#      and that no rewards were allocated in trials 2, 3, and 4.
#     2. The second input is in the same format as the first, but it indicates
#      previous rewards to the second ("anti-target") alternative. Hence, for
#      example, the list [0, 1, 1] as the second input to your program
#      indicates that the game is currently at its 4'th trial, that on the
#      first trial a reward was not allocated to the anti-target alternative
#      and that on the second and third trial rewards were allocated to that
#      alternative.
#     3. The third input is a list of previous choices, where 1's indicate a
#      choice in the target alternative and 0's indicate choice in the
#      anti-target alternative. For example, the list [1, 1, 1, 0, 0, 0]
#      received as the third input indicates that the experiment is currently
#      at its 7'th trial, that on the first three trials the target side was
#      chosen by the subject and that on the last three trials it was not.
# B. Providing output - Your function should indicate the allocation of rewards
#  by printing (to the standard sys.stdout, e.g. using
#  [print]( https://docs.python.org/3/library/functions.html#print)) a single
#  string in the format of "(T, N)", where both T and N are either the
#  character 1 or 0, T represents the allocation to the target side and N the
#  allocation the non-target side.
#  Hence, your model output should be one of the following four strings
#  "(0, 0)",  "(0, 1)",  "(1, 0)",  "(1, 1)". To prevent formatting issues,
#  you may use the "output" function provided in this file.

###############################################################################
# Code start
###############################################################################
import sys
import ast
TOTAL_REWARDS = 25
NUMBER_OF_TRIALS = 100
REWARD = 1
NO_REWARD = 0

###############################################################################
# Template - Insert your code here
###############################################################################


def allocate(target_allocations, anti_target_allocations, is_target_choices):
    """
    :param target_allocations: A binary list, where True values at index i
            indicate a reward was allocated to the target side on trial i.
    :param anti_target_allocations: A binary list, where True values at index i
            indicate a reward was allocated to the anti-target side on trial i.
    :param is_target_choices: A binary list, where True values at index i
            indicate the target_side was chosen on that index.
            The allocation method
    :return: A two-element tuple where the first binary element indicates
                whether a reward should be allocated to the target side,
                and the second whether a reward should be allocated to the
                anti-target side. To refrain from formatting issues, use the
                output function (see below in this file)
    """
    pass


def constrain(previous_allocation, current_allocation):
    """
    Constrain the current allocation based on previous allocations, such that
     both (1) no more than 25 rewards are allocated and (2) assuring that all
     25 rewards are indeed allocated.
    :param previous_allocation:
    :param current_allocation:
    :return: A constrained allocation
    """
    pass


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
