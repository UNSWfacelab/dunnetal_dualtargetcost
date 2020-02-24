function [windowWidth, windowHeight, X0, Y0] = getInfoAboutScreen(window)
%Get the width and height of the window, the X centre and Y centre of the screen

%[width, height]=Screen('WindowSize', windowPointerOrScreenNumber);
[windowWidth, windowHeight]=Screen('WindowSize', window);%find the height and width of the window (monitor).

% Find the centre of the screen
X0 = windowWidth/2;%centre X coordinate
Y0 = windowHeight/2;%centre Y coordinate

end