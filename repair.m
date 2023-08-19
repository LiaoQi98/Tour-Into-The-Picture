function Repaired = repair(A, method, gapValue)
%   method - one of the interpolation methods defined for Matlab's builtin 
%   funtction fillmissing():
%      'previous'  - Previous non-missing entry.
%      'next'      - Next non-missing entry.
%      'nearest'   - Nearest non-missing entry.
%      'linear'    - Linear interpolation of non-missing entries.
%      'spline'    - Piecewise cubic spline interpolation.
%      'pchip'     - Shape-preserving piecewise cubic spline interpolation.

if isa(A, 'uint8')
    A = double(A);
end
Repaired = A;

[~,k] = size(gapValue);
% If all the gapValue values are the same, reduce it to 1 for better
% efficiency:
if k == 3 && gapValue(1) == gapValue(2) && gapValue(2) == gapValue(3)
    gapValue(3) = [];
    gapValue(2) = [];
    [~,k] = size(gapValue);
end
% Replacing gap values with NaNs so that A may be used with Matlab's
% fillmissing() function:
if ~isnan(gapValue)
    if k == 1
        %A(A == gapValue) = NaN;
        temp = (A == gapValue);
        temp = temp(:,:,1) .* temp(:,:,2) .* temp(:,:,3);
    else % i.e. if k == 3
        temp1 = A(:,:,1) == gapValue(1);
        temp2 = A(:,:,2) == gapValue(2);
        temp3 = A(:,:,3) == gapValue(3);
        temp = temp1 .* temp2 .* temp3;
    end
    [row, col] =  find(temp);
    linearidx = [sub2ind(size(A), row, col, ones([length(row),1])) ;
            sub2ind(size(A), row, col, ones([length(row),1])*2) ; 
            sub2ind(size(A), row, col, ones([length(row),1])*3)];
    A(linearidx) = NaN;  
end
temp1 = fillmissing(A, method, 1);
temp2 = fillmissing(A, method, 2);
A = (temp1 + temp2)/2;

[m,n,~] = size(A);
if k == 1
    for a = 1:m
        for b = 1:n
            if Repaired(a,b,:) == [gapValue gapValue gapValue]
                Repaired(a,b,:) = A(a,b,:);
            end
        end
    end
else % i.e. if k == 3
     for a = 1:m
        for b = 1:n
            if Repaired(a,b,:) == gapValue
                Repaired(a,b,:) = A(a,b,:);
            end
        end
    end
end

Repaired= uint8(Repaired);

end %fillmissingrgb