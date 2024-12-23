function [ pExp ] = getExploreProb( epsilon, currentSurp, meanSurp )
%Sets probability of exploration
%   Detailed explanation goes here

pExp = epsilon* (1+ currentSurp + meanSurp) /3;

end

