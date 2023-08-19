function H = computeHomography(pts1, pts2)
% Input: pts1 : 3xN matrices for N points in homogeneous coordinates. (projected image)
%        pts2 : 3xN matrices for N points in homogeneous coordinates. (original image)
% 
% Output: H is a 3x3 matrix, such that pts2=H*pts1


% Compute homography by 4-points-alogrithm
% form matrix A
A = zeros(8, 9);

for i = 1 : 4
    A(i*2-1, 1) = -pts1(1, i);
    A(i*2-1, 2) = -pts1(2, i);
    A(i*2-1, 3) = -1;
    
    A(i*2-1, 7) = pts1(1, i)*pts2(1, i);
    A(i*2-1, 8) = pts1(2, i)*pts2(1, i);
    A(i*2-1, 9) = pts2(1, i);
    
    A(i*2, 4) = -pts1(1, i);
    A(i*2, 5) = -pts1(2, i);
    A(i*2, 6) = -1;
    
    A(i*2, 7) = pts1(1, i)*pts2(2, i);
    A(i*2, 8) = pts1(2, i)*pts2(2, i);
    A(i*2, 9) = pts2(2, i);    
end


h=null(A);
H = reshape(h,3,3)'./h(end);  % h change to H 8 DoF

end



