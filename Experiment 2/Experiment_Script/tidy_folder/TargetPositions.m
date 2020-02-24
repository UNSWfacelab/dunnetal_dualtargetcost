%% ----------------------- POSITIONS --------------------------------------
%This bit of code sets up where each image will be displayed

targetIm_height = 285*0.75; targetIm_width = 190*0.75; imageGap = 25;

Im_height = 285*0.75; Im_width = 190*0.75;

gridRowCount = floor(windowHeight/Im_height);

gridColumnCount = floor(windowWidth/Im_width);
emptyRows = windowHeight - gridRowCount*Im_height;

emptyColumns = windowWidth - gridColumnCount*Im_width;

jiggleSpaceRows = emptyRows/gridRowCount;

jiggleSpaceColumns = emptyColumns/gridColumnCount;
targetPositionList = [];
targetArrayPosition = [];



X1 = 1;
Y1 = 2;
X2 = 3;
Y2 = 4;

for row = 1:gridRowCount
    for column = 1:gridColumnCount
        jiggle = rand;
        targetPositionList(X1,column+(row-1)*gridColumnCount) = (column-1)*(Im_width+jiggleSpaceColumns)+jiggle*jiggleSpaceColumns;
        targetPositionList(Y1,column+(row-1)*gridColumnCount) = (row-1)*(Im_height+jiggleSpaceRows)+jiggle*jiggleSpaceRows;
        targetPositionList(X2,column+(row-1)*gridColumnCount) = (column-1)*(Im_width+jiggleSpaceColumns)+jiggle*jiggleSpaceColumns+Im_width;
        targetPositionList(Y2,column+(row-1)*gridColumnCount) = (row-1)*(Im_height+jiggleSpaceRows)+jiggle*jiggleSpaceRows+Im_height;
    end
end
gridAssignment = [];

targetPosition = [X0-targetIm_width/2,Y0-targetIm_height/2,X0+targetIm_width/2,Y0+targetIm_height/2]';
targetArrayPosition(:,1) = [X0-targetIm_width-imageGap,Y0-targetIm_height/2,X0-imageGap,Y0+targetIm_height/2];
targetArrayPosition(:,2) = [X0+imageGap,Y0-targetIm_height/2,X0+targetIm_width+imageGap,Y0+targetIm_height/2];
% targetArrayPosition(:,3) = [X0-targetIm_width-imageGap,Y0+imageGap,X0-imageGap,Y0+targetIm_height+imageGap];
% targetArrayPosition(:,4) = [X0+imageGap,Y0+imageGap,X0+targetIm_width+imageGap,Y0+targetIm_height+imageGap];