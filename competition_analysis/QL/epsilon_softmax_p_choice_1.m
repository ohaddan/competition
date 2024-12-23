function alternative_1_p = epsilon_softmax_p_choice_1(q1, q2, epsilon, beta)
% EPSILON_SOFTMAX_P_CHOICE_1 Calculates the probability of choosing the
% first alternative using the epsilon-softmax algorithm.
%
%   alternative_1_p = EPSILON_SOFTMAX_P_CHOICE_1(q1, q2, epsilon, beta) 
% returns the probability of choosing the first alternative from a set of
% two alternatives (q1 and q2) using the epsilon-softmax algorithm with
% parameter epsilon and inverse temperature beta.
%
%   Inputs:
%   q1: the value of the first alternative.
%   q2: the value of the second alternative.
%   epsilon: a scalar value between 0 and 1 representing the probability 
%       of choosing the alternative uniformly at random.
%   beta: a positive scalar value representing the inverse temperature 
%               parameter, controlling the degree of randomness in 
%               the decision-making process.
%
%   Outputs:
%   alternative_1_p: the probability of choosing the first alternative,
%       calculated using the epsilon-softmax algorithm.
%
%   The epsilon-softmax algorithm works as follows:
%   1. The exponentiated value of each alternative is calculated by multiplying its value (q1 or q2) by the inverse temperature (beta) and taking the exponential function of the result. These exponentiated values are stored in the variables exp_q1_beta and exp_q2_beta, respectively.
%   2. The probability of choosing the first alternative is calculated using the epsilon-softmax formula:
%      alternative_1_p = epsilon + (1 - 2 * epsilon) * exp_q1_beta ./ (exp_q1_beta + exp_q2_beta);
%   3. The result is returned as alternative_1_p.
%
%   Note that when epsilon=0, the epsilon-softmax algorithm reduces to the standard softmax algorithm, where the probability of choosing the first alternative is given by:
%      alternative_1_p = exp_q1_beta / (exp_q1_beta + exp_q2_beta);
%
%   Example usage:
%   q1 = 1;
%   q2 = 2;
%   epsilon = 0.1;
%   beta = 0.5;
%   alternative_1_p = epsilon_softmax_p_choice_1(q1, q2, epsilon, beta);


exp_q1_beta = exp(q1 * beta);
exp_q2_beta = exp(q2 * beta);
alternative_1_p = epsilon + (1 - 2 * epsilon) * exp_q1_beta ./ (exp_q1_beta + exp_q2_beta);

end
