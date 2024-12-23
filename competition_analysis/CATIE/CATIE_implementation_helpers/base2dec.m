function [ decim ] = base2dec( base, vector )
%Convert vector of any base to decimal number
%   Detailed explanation goes here

ndigs = length(vector);
decim = 0;
for dig = ndigs:-1:1
    decim = decim + (base^(dig-1))*double(vector(dig));
end

end

