function [dscp0, dscp22, dscp46] = getlabel(N)
    dscp0 = N*0.5;
    dscp22Count = N*0.25;
    dscp22 = dscp0+dscp22Count;
    dscp46 = N;
end

% call like this ->[dscp0, dscp22, dscp46] = getlabel(N)