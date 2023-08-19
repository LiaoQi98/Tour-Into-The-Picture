function [irx, iry] = gui_4points(im)
% get the upper left and lower right corner of the inner rectangle
% get two point by click
imshow(im);

while 1
  
  % get the points
  [rxnew,rynew,button] = ginput(2);

  % if pressed ENTER, quit the loop
  if (isempty(button))
    break;
  end

  rx = rxnew; ry=rynew;

  % draw the rectangle
  imshow(im);
  hold on;
  % round:get integer
  irx = round([rx(1) rx(2) rx(2) rx(1) rx(1)]);
  iry =  round([ry(1) ry(1) ry(2) ry(2) ry(1)]);
  % draw the rectangle
  plot(irx,iry,'Color','r','LineStyle','-'); 
  hold off;
  drawnow;   
end
close all;
end
