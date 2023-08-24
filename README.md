# Tour into the Picture
## Overview
The project aims to develop an interactive user interface based on MATLAB to achieve the reconstruction and visualization of three-dimensional scenes from a single image.Perform irregular cropping of the foreground image, identify missing parts, and repair them using linear interpolation. Utilize vanishing points to determine the camera focal length and establish the depth of each image based on image relationships. Reconstruct and connect the cropped images using the four-point method, creating an axis-aligned box with five faces to model the scene. Implement interactive "touring" functionality within the image using MATLAB's camproj function.

## Poster
![image](https://github.com/LiaoQi98/TourIntoThePicture/assets/108174052/0d6cd417-101d-4681-bc93-1289ace3e61d)
## Application "Tour-Into-The-Picture" Manual

### Step 1: Picture Selection
![image](https://github.com/LiaoQi98/TourIntoThePicture/assets/108174052/9ffd37d3-72a4-4ddd-b153-1c97ca7e179c)
* Launch the application and choose an image on the left side for preview (Pictures 1-6 are system images). If you wish to use your own picture, select "Your Image" and then choose your preferred image.
* Decide whether to skip the foreground extraction step:

   a) To skip, select "Yes" (wait until you see "Done!" in the comment).
   
   b) To manually extract the foreground, select "No," and a new window will appear. Click with the mouse to create a closed shape representing the foreground. Press "Enter" after defining all the points.
       * ![image](https://github.com/LiaoQi98/TourIntoThePicture/assets/108174052/c78b9982-2e94-40f8-9b8f-12d9b037720f)

### Step 2: Rectangle Creation
Use the mouse to select two points in the popup window (the first point is the upper-left corner of the rectangle, and the second point is the lower-right corner). After selecting the points, press "Enter." If you are not satisfied, you can directly choose new points.
![image](https://github.com/LiaoQi98/TourIntoThePicture/assets/108174052/8926261b-17ec-461d-8228-5553f6eb1bcf)

### Step 3: Vanishing Point Selection
Click a point with the mouse in the popup window to choose the vanishing point. Press "Enter" after selection.
![image](https://github.com/LiaoQi98/TourIntoThePicture/assets/108174052/7dba0d3e-8830-495e-9fe0-1c3df2fc4b84)

### Step 4: Camera Adjustment
 In the popup window, use the keyboard for:

* Zooming (Zoom Out [E], Zoom In [Q])
* Camera Position ([H-K-U-J])
* Camera Angle ([W-S-A-D])
![Screenshot](https://github.com/LiaoQi98/Tour-Into-The-Picture/assets/108174052/22030905-6115-46ad-8cfb-ae864d6851ac)
![Screenshot](https://github.com/LiaoQi98/Tour-Into-The-Picture/assets/108174052/d399e960-0285-46cf-9c5a-b154c6aa1086)


### Step 5: Capturing the Image
 After adjusting the camera, press [B] to capture a screenshot. When the screenshot is successful, a message window will appear ("Screenshot successfully!"). You'll find an image named "Screenshot" in the folder. If you're not satisfied, click "Yes" to make further adjustments to the camera angle and position. Capture a new screenshot by pressing [B] again.

###  Step 6: Completion
If you're satisfied with the screenshot, press [Esc] to exit keyboard control.

