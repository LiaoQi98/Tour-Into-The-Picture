function [corX, corY] = compute_outCorner(x1,y1,x2,y2,borderX,borderY)
% Compute the corner Outside the image
% 
% Input: x1: x-coordinate of the first point
%        y1: y-coordinate of the first point
%        x2: x-coordinate of the second point
%        y2: y-coordinate of the second point
%        borderX: boundary
%        borderY: boundary
%
% Output: corX: x-coordinate of the corner
%         corY: y-coordinate of the corner  
%
    % y = mx+b
    m = (y1-y2)/(x1-x2);
    b = y1-m*x1;
    
    tempX = (borderY-b)/m;
    tempY = m*borderX+b;

    if (sum(([x1 y1]-[tempX borderY]).^2) >= sum(([x1 y1]-[borderX tempY]).^2)) % a point with larger distance from vanishing point selected
        corX = tempX;
        corY = borderY;
    else    
        corX = borderX;
        corY = tempY;
    end  

end