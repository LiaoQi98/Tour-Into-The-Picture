function [cpOutx, cpOuty, vp_x,vp_y,cpx,cpy] = gui_vanishing_point(I,irx,iry)
imshow(I);
[max_y, max_x, c] = size(I);
hold on;
plot(irx,iry,'Color','b','LineStyle','-'); 
hold off; 
while(1)
    [vx, vy, button] = ginput(1);
    
    if (isempty(button))
      break;
    end
    vp_x = round(vx(1)); vp_y=round(vy(1));

    
    [cpx(1), cpy(1)] = compute_corner(vp_x, vp_y, irx(1), iry(1), 1, 1); 
    [cpx(2), cpy(2)] = compute_corner(vp_x, vp_y, irx(2), iry(2), max_x, 1); 
    [cpx(3), cpy(3)] = compute_corner(vp_x, vp_y, irx(3), iry(3), max_x, max_y); 
    [cpx(4), cpy(4)] = compute_corner(vp_x, vp_y, irx(4), iry(4), 1, max_y); 
    cpx = round(cpx);
    cpy = round(cpy);

    % get the point on edge of image
    cpOutx = [0 0 0 0];
    cpOuty = [0 0 0 0];
    [cpOutx(1), cpOuty(1)] = compute_outCorner(vp_x, vp_y, irx(1), iry(1), 1, 1); 
    [cpOutx(2), cpOuty(2)] = compute_outCorner(vp_x, vp_y, irx(2), iry(2), max_x, 1); 
    [cpOutx(3), cpOuty(3)] = compute_outCorner(vp_x, vp_y, irx(3), iry(3), max_x, max_y); 
    [cpOutx(4), cpOuty(4)] = compute_outCorner(vp_x, vp_y, irx(4), iry(4), 1, max_y); 
    cpOutx = round(cpOutx);
    cpOuty = round(cpOuty);

    imshow(I);
    hold on;
    plot(irx,iry,'b'); 
    plot([vp_x cpx(1)],[vp_y cpy(1)],'r');
    plot([vp_x cpx(2)],[vp_y cpy(2)],'r');
    plot([vp_x cpx(3)],[vp_y cpy(3)],'r');
    plot([vp_x cpx(4)],[vp_y cpy(4)],'r');
    hold off;
end 
close all;
end