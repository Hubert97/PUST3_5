function [outputArg2] = No_Negatives(inputArg2)
%NO_NEGATIVES Summary of this function goes here
%   Detailed explanation goes here
[sizeT a]=size(inputArg2);
for i=1:sizeT
    if inputArg2(i)<0
        inputArg2(i)=0;
    end;
end;
outputArg2 =inputArg2;
end

