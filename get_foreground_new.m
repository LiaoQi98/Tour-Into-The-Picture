function [foreground,im2] = get_foreground_new(im)
% this function helps the user to get the foreground
[X,Y,D]=size(im);
figure('Name','please cut off the foreground','NumberTitle','off');
%imshow(im);
k=1;
p=[];
flag = 1;
% begin to choosing the point
x = X/2;
y = Y/2;
if flag ==1
    p(k,1:2)=round([x,y]); % change the position
end
p(k+1,1:2) = round([x,y]);

mask=zeros(X,Y);
for i=1:k
    if i<k
        mask=get_mask(mask,p(i,:),p(i+1,:)); % Connect all points in sequence
    else
        mask=get_mask(mask,p(i,:),p(1,:)); % End is connected to the starting point
    end
end

% filling
mask=imfill(mask,'hole');
mask2=-1*(mask-1);

% check the im
if D>1
   mask=cat(3,mask,mask,mask); 
end

% get the object
foreground = uint8(255.*mask.*im);
% try to fill the im
im2=im2uint8(im)-foreground;
im2= repair(im2, 'nearest', 0);
foreground = foreground+uint8(255.*mask2);
close;

end

