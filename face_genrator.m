function face_genrator(I,vp_x,vp_y,irx,iry,foreground,foreground_image,cpOutx,cpOuty,cpx,cpy)
[max_y, max_x, c] = size(I);
I = foreground_image;
%% draw the big image and big foreground
lmargin = 1-min(cpOutx);        % distence of edge point from leftside of original image
rmargin = max(cpOutx) - max_x;  % distence of right edge point from rightside of original image
tmargin = 1-min(cpOutx);        % distence of edge point from topside of original image
bmargin = max(cpOuty) - max_y;  % distence of edge point from bottomside of original image

% expanden the image based on the perivous outer rectangle
big_im = zeros([max_y+tmargin+bmargin max_x+lmargin+rmargin c]);      % new size of big image
big_im(tmargin+1:end-bmargin,lmargin+1:end-rmargin,:) = im2double(I); % original image in new big image
%figure(20);imshow(big_im); % display the expanded image

% get the big image from perivous outer rechteck
big_foreground = ones(size(big_im ));
big_foreground(tmargin+1:end-bmargin,lmargin+1:end-rmargin,:) = im2double(foreground);
%figure(21);imshow(big_foreground); % display the expended foreground

% Draw the Vanishing Point and the 4 faces on the image
%figure(20);
%hold on;
%plot(vp_x+lmargin,vp_y+tmargin,'w*');
%plot([irx+lmargin irx(1)+lmargin],[iry+tmargin iry(1)+tmargin],'b'); % inner rechteck

%plot([vp_x cpx(1)]+lmargin,[vp_y cpy(1)]+tmargin,'r');
%plot([vp_x cpx(2)]+lmargin,[vp_y cpy(2)]+tmargin,'r');
%plot([vp_x cpx(3)]+lmargin,[vp_y cpy(3)]+tmargin,'r');
%plot([vp_x cpx(4)]+lmargin,[vp_y cpy(4)]+tmargin,'r');

%plot([vp_x cpOutx(1)]+lmargin,[vp_y cpOuty(1)]+tmargin,'g');
%plot([vp_x cpOutx(2)]+lmargin,[vp_y cpOuty(2)]+tmargin,'g');
%plot([vp_x cpOutx(3)]+lmargin,[vp_y cpOuty(3)]+tmargin,'g');
%plot([vp_x cpOutx(4)]+lmargin,[vp_y cpOuty(4)]+tmargin,'g');

%hold off;

%% crop each face of the box

% Middle face
mask = poly2mask([irx(1) irx(2) irx(3) irx(4)]+lmargin, [iry(1) iry(2) iry(3) iry(4)]+tmargin, size(big_im, 1), size(big_im, 2));
imMiddle = big_im.*mask;

%figure(2), imshow(imMiddle);

% Left face
mask = poly2mask([cpOutx(1) irx(1) irx(4) cpOutx(4)]+lmargin, [cpOuty(1) iry(1) iry(4) cpOuty(4)]+tmargin, size(big_im, 1), size(big_im, 2));
imLeft = big_im.*mask;

%figure(3), imshow(imLeft);


% Right face
mask = poly2mask([irx(2) cpOutx(2) cpOutx(3) irx(3)]+lmargin, [iry(2) cpOuty(2) cpOuty(3) iry(3)]+tmargin, size(big_im, 1), size(big_im, 2));
imRight = big_im.*mask;

%figure(4), imshow(imRight);


% Up face
mask = poly2mask([cpOutx(1) cpOutx(2) irx(2) irx(1)]+lmargin, [cpOuty(1) cpOuty(2) iry(2) iry(1)]+tmargin, size(big_im, 1), size(big_im, 2));
imUp = big_im.*mask;

%figure(5), imshow(imUp);


% Bottom face
mask = poly2mask([irx(4) irx(3) cpOutx(3) cpOutx(4)]+lmargin, [iry(4) iry(3) cpOuty(3) cpOuty(4) ]+tmargin, size(big_im, 1), size(big_im, 2));
imBottom = big_im.*mask;

%figure(6), imshow(imBottom);



%% get depth of each face
% depth based on the ratio 

% left
if(cpOutx(1)==1)    
    i = cpOuty(1);
else
    i = cpy(1);
end

if(cpOutx(4)==1)
    j = cpOuty(4);
else
    j = cpy(4);
end

length1 = iry(4) - iry(1); % leftside length of rectangle
length2 = j - i;           % leftside length of big image
ratio = length1/length2;

focalLength = round(1500*ratio); % estimate focalLength 

depthLeft = (focalLength-ratio*focalLength) / ratio; 
lefty = zeros(1,4);
lefty(1) = i;
lefty(4) = j;

% right
if(cpOutx(2)==max_x)    
    i = cpOuty(2);
else
    i = cpy(2);
end

if(cpOutx(3)==max_x)
    j = cpOuty(3);
else
    j = cpy(3);
end

length1 = iry(3) - iry(2); % rightside length of rectangle
length2 = j - i;           % rightside length of big image
ratio = length1/length2;
depthRight = (focalLength-ratio*focalLength) / ratio; 

righty = zeros(1,4);
righty(2) = i;
righty(3) = j;

% up
if(cpOuty(1)==1)    
    i = cpOutx(1);
else
    i = cpx(1);
end

if(cpOuty(2)==1)
    j = cpOutx(2);
else
    j = cpx(2);
end

length1 = irx(2) - irx(1); % topside length of rectangle
length2 = j - i;           % topside length of big image 
ratio = length1/length2;
depthUp = (focalLength-ratio*focalLength) / ratio; 

upx = zeros(1,4);
upx(1) = i;
upx(2) = j;

% bottom
if(cpOuty(4)==max_y)    
    i = cpOutx(4);
else
    i = cpx(4);
end

if(cpOuty(3)==max_y)
    j = cpOutx(3);
else
    j = cpx(3);
end

length1 = irx(3) - irx(4); % bottomside length of rectangle
length2 = j - i;           % bottomside length of big image
ratio = length1/length2;
depthBottom = (focalLength-ratio*focalLength) / ratio;

bottomx = zeros(1,4);
bottomx(4) = i;
bottomx(3) = j;

% foreground
[row_fore,col_fore]=find(big_foreground(:,:,1)<1); % find the bottom boundary of foreground

%% test depth (using the max depth)
depth = [depthLeft,depthRight,depthUp,depthBottom];
max_depth = max(depth);

depthLeft = max_depth;
depthRight = max_depth;
depthUp = max_depth;
depthBottom = max_depth;

%% get texture maps
% homographies for each face
% -------------------------Up face-------------------------------------
pts1 = [[upx(1) upx(2) irx(2) irx(1)]+lmargin ; [1 1 iry(2) iry(1)]+tmargin;1 1 1 1]; % projected image
pts2 = [1 max_x max_x 1 ; 1 1 depthUp depthUp;1 1 1 1];                   % original image 

H_Up = computeHomography(pts1, pts2); % calculates the homography of Up face
T = maketform('projective', H_Up.');  % creates a TFORM structure for an 3-dimensional projective transformation specified as matrix T
imUpBlend = imtransform(imUp, T, 'XData',[1 max_x],'YData',[0 depthUp]); % Apply 2-D spatial transformation to image

%figure(30), imshow(imUpBlend);title('Up face')

% -------------------------Bottom face-------------------------------------
pts1 = [[irx(4) irx(3) bottomx(3) bottomx(4) ]+lmargin; [iry(4) iry(3) max_y max_y ]+tmargin;1 1 1 1]; % projected image
pts2 = [1 max_x max_x 1; 1 1 depthBottom depthBottom;1 1 1 1 ];                           % original image

H_Bottom = computeHomography(pts1, pts2); % calculates the homography of Bottom face
T = maketform('projective', H_Bottom.');  % creates a TFORM structure for an 3-dimensional projective transformation specified as matrix T
imBottomBlend = imtransform(imBottom, T, 'XData',[1 max_x],'YData',[1 depthBottom]); % Apply 2-D spatial transformation to image

%figure(32), imshow(imBottomBlend);title('Bottom face')

% -------------------------Left face-------------------------------------
pts1 = [[1 irx(1) irx(4) 1]+lmargin; [lefty(1) iry(1) iry(4) lefty(4)]+tmargin;1 1 1 1]; % projected image
pts2 = [[1 depthLeft depthLeft 1]; [1 1 max_y max_y];1 1 1 1];               % original image

H_Left = computeHomography(pts1, pts2); % calculates the homography of Left face
T = maketform('projective', H_Left.');  % creates a TFORM structure for an 3-dimensional projective transformation specified as matrix T
imLeftBlend = imtransform(imLeft, T, 'XData',[0 depthLeft],'YData',[1 max_y]); % Apply 2-D spatial transformation to image

%figure(34), imshow(imLeftBlend);title('Left face')

% -------------------------Right face-------------------------------------
pts1 = [[irx(2) max_x max_x irx(3)  ]+lmargin; [iry(2) righty(2) righty(3) iry(3) ]+tmargin;1 1 1 1]; % projected image
pts2 = [1 depthRight depthRight 1  ;1 1 max_y max_y;1 1 1 1 ];                            % original image

H_Right = computeHomography(pts1, pts2); % calculate the homography of Right face
T = maketform('projective', H_Right.'); % creates a TFORM structure for an 3-dimensional projective transformation specified as matrix T
imRightBlend = imtransform(imRight, T, 'XData',[0 depthRight],'YData',[1 max_y]); % Apply 2-D spatial transformation to image

%figure(36), imshow(imRightBlend);title('Right face')

% -------------------------Middle face-------------------------------------
pts1 = [[irx(1) irx(2) irx(3) irx(4)]+lmargin; [iry(1) iry(2) iry(3) iry(4) ]+tmargin;1 1 1 1]; % projected image
pts2 = [1 max_x max_x 1; 1 1 max_y max_y;1 1 1 1 ];                            % original image

H_Middle = computeHomography(pts1, pts2); % calculate the homography of Right face
T = maketform('projective', H_Middle.'); % creates a TFORM structure for an 3-dimensional projective transformation specified as matrix T
imMiddleBlend = imtransform(imMiddle, T, 'XData',[1 max_x],'YData',[1 max_y]); % Apply 2-D spatial transformation to image

%figure(38), imshow(imMiddleBlend);title('Middle face')

% -------------------------foreground-------------------------------------
imForegroundBlend = ones(size(I));
imForegroundBlend(end-(max(row_fore)-min(row_fore)):end,:,:) = imcrop(big_foreground, [lmargin+1 min(row_fore) (max_x-1) (max(row_fore)-min(row_fore))]);

%figure(39), imshow(imForegroundBlend);title('foreground')

%% define 3D surfaces
% initial some variables
max_depth = max([depthLeft,depthRight,depthUp,depthBottom]);

x_max = max_x;
y_max = max_y;
z_max = max_depth;

% depth of foreground
point1 = [1;max(row_fore);1];
point2 = [irx(3)+lmargin;(iry(3)+tmargin);1];

depth_fore = getDepthForeground(point1,point2,H_Bottom);
z_fore = max_depth-depth_fore;

view = figure('name','3DViewer: Directions[W-S-A-D] Position[H-K-U-J] Zoom[Q-E] Screenshot [B] Exit[ESC]');
set(view,'windowkeypressfcn','set(gcbf,''Userdata'',get(gcbf,''CurrentCharacter''))') ;
set(view,'windowkeyreleasefcn','set(gcbf,''Userdata'','''')') ;
set(view,'Color','black')
hold on

% display box
%disp('display box');
hold on;

% create the surface and texturemap it with a given image
% bottom
surface([0 x_max; 0 x_max], [0 0; z_max z_max], [0 0; 0 0], ...
    'FaceColor', 'texturemap', 'CData', flip(imBottomBlend,1),'EdgeAlpha',0);
% top
surface([0 x_max; 0 x_max], [0 0; z_max z_max], [y_max y_max; y_max y_max], ...
    'FaceColor', 'texturemap', 'CData', imUpBlend, 'EdgeAlpha',0);
% back
surface([0 x_max; 0 x_max], [z_max z_max; z_max z_max], [0 0; y_max y_max], ...
    'FaceColor', 'texturemap', 'CData', flip(imMiddleBlend,1),'EdgeAlpha',0);
% left
surface([0 0; 0 0], [0 z_max; 0 z_max], [0 0; y_max y_max], ...
    'FaceColor', 'texturemap', 'CData', flip(imLeftBlend,1),'EdgeAlpha',0);
% right
surface([x_max x_max; x_max x_max], [0 z_max; 0 z_max], [0 0; y_max y_max], ...
    'FaceColor', 'texturemap', 'CData', flip(flip(imRightBlend,1),2),'EdgeAlpha',0);

% foreground object
if z_fore>0 && z_fore<max_depth
    logical = (imForegroundBlend(:,:,1)~=1).*255;
    foreground_handle = surface([0 x_max; 0 x_max], [z_fore z_fore; z_fore z_fore], [0 0; y_max y_max], ...
        'FaceColor', 'texturemap', 'CData', flip(imForegroundBlend,1),'EdgeAlpha',0);
    
    foreground_handle.FaceAlpha = 'texturemap';
    foreground_handle.AlphaData = flip(logical,1);
end
%% camera
% Some 3D magic...
axis equal;  % make X,Y,Z dimentions be equal
axis vis3d;  % freeze the scale for better rotations
axis off;    % turn off the stupid tick marks
camproj('perspective');  % make it a perspective projection

% set camera position
camx = x_max/2 ;
camy = -(z_max +500);
camz = y_max/2;

% set camera step
stepx = 0.05;
stepy = 0.05;
stepz = 0.05;

% set camera on ground
camup([0,0,1]);
campos([camx camy camz]);

key = 0;
while (~key)
    waitforbuttonpress;
    key = get(view, 'currentch');
% In order not to run outside the box when turning the camera
    camva(45);
    switch key
%  change camera angle
        case {'d','D'}
            camdolly(-stepx,0,0,'fixtarget');           
        case {'a','A'}
            camdolly(stepx,0,0,'fixtarget');
        case {'s','S'}
            camdolly(0,stepy,0,'fixtarget');
        case {'w','W'}
            camdolly(0,-stepy,0,'fixtarget');
        case {'q','Q'}
            camdolly(0,0,stepz,'fixtarget');
        case {'e','E'}
            camdolly(0,0,-stepz,'fixtarget');

%change camera position
        case {'h','H'}
            camdolly(-stepx,0,0);
        case {'k','K'}
            camdolly(stepx,0,0);
        case {'u','U'}
            camdolly(0,stepy,0);
        case {'j','J'}
            camdolly(0,-stepy,0);    
% Screenshot
        case {'b','B'}
            f = getframe(gcf);
            f = frame2im(f);
            imwrite(f,'Screenshot.jpg')
            myicon = imread('Screenshot.jpg');
            msg = msgbox('Screenshot  successfully!!','msg','custom', myicon);
            uiwait(msg)
% Use esc to turn off keyboard control
         case 27
            break;

    end
    
    key = 0;

    pause(.001);
    
end

hold off;


end