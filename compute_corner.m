function [corX,corY] = compute_corner(x1,y1,x2,y2,edgeX,edgeY)
% Compute the corner of the boundary of image  
% 
% Input: x1: x-coordinate of the first point
%        y1: y-coordinate of the first point
%        x2: x-coordinate of the second point
%        y2: y-coordinate of the second point
%        edgeX: boundary
%        edgeY: boundary
%
% Output: corX: x-coordinate of the corner
%         corY: y-coordinate of the corner        
    % y = mx+b
    m = (y1-y2)/(x1-x2);
    b = y1-m*x1;
    
    tempX = (edgeY-b)/m;
    tempY = m*edgeX+b;
    if (sum(([x1 y1]-[tempX edgeY]).^2) <= sum(([x1 y1]-[edgeX tempY]).^2)) % a point with smaller distance from vanishing point selected
        corX = tempX;
        corY = edgeY;
    else    
        corX = edgeX;
        corY = tempY;
    end

    
end
