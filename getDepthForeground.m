function depth_fore = getDepthForeground(point_BottomBoundary_fore,point_bottom_corner,H_Bottom)
% Compute the depth of foreground
% 
% Input: point_upperBoundary_fore : the bottom boundary of foreground (original image)
%        point_bottom_corner : the upper left corner of bottom face (original image) 
%        H_Bottom : homography of the bottom face
%
% Output: depth_fore: the depth of foreground
    point_upperBoundary_fore_new = H_Bottom*point_BottomBoundary_fore;
    point_bottom_corner_new = H_Bottom*point_bottom_corner;
    
    point_upperBoundary_fore_new=point_upperBoundary_fore_new(:,:)/point_upperBoundary_fore_new(3,1);
    point_bottom_corner_new=point_bottom_corner_new(:,:)/point_bottom_corner_new(3,1);
    
    point_new = point_upperBoundary_fore_new-point_bottom_corner_new;
    depth_fore = point_new(2,1);
end