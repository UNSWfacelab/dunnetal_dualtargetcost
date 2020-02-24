function practiceExampleImages(window,windowWidth,windowHeight,nextKey,targetPosition,targetArrayPosition,targetPositionList,gridAssignment,X0,Y0)
grey = 128;
black = 0;
white = 255;
red = [255 0 0];
green = [0 255 0];
blue = [0 0 255];
yellow = red + green;
purple = red + blue;
cyan = blue + green;

% --- VARIABLES TO DO WITH FEEDBACK ---
framePenWidth = 6;
textSize = 32;

% Select specific text font, style and size:
Screen('TextFont',window, 'Arial');
Screen('TextSize',window, textSize);

textOffset = 40;
YposHeading = Y0-150;
YposSubtext = Y0+120;
textOffset = 40; 

% --- FIXATION POINT ---
heightOfFix = 20;
widthOfFix = 20;
lineWidth = 3;

Screen('FillRect', window, grey, [0, 0, windowWidth, windowHeight]);%clear the screen
Screen(window, 'Flip');

parentDirectory = 'Example';
exampleImage = '/EX*.jpg';
escapeKey = KbName('ESCAPE');
XposHeading = 'center';

targetText1 = 'Find this person';
targetTextDifferent = 'Find either of these people';
targetTextSame = 'Find this person';

exampleIdentityNumList = [1:13];

[exampleImagesPathList, exampleImagesFileList] = folderSearch(parentDirectory,exampleImage);%User-defined function


for i = 1:numel(exampleImagesFileList)%For each image
    exampleImagesPrefixList(i) = str2num(exampleImagesFileList{i}(3:4));%Convert from strings to numbers
end

%Group the images into identities
groupedExampleImagesPrefixList = {}; groupedExampleList = {}; groupedFamiliarImagesPrefixList = {}; groupedFamiliarList = {}; groupedExamplePathList = {}; groupedFamiliarPathList = {};

for i = 1:numel(exampleIdentityNumList)%for each target
    groupedExampleImagesPrefixList{i} = exampleImagesPrefixList(exampleImagesPrefixList == exampleIdentityNumList(i));
    groupedExampleList{i} = exampleImagesFileList(exampleImagesPrefixList == exampleIdentityNumList(i));
    groupedExamplePathList{i} = exampleImagesPathList(exampleImagesPrefixList == exampleIdentityNumList(i));
end
X1 = 1;
Y1 = 2;
incorrectTimePenalty = 2;
targetsRemaining=0;
falseAlarms=0;
trialEndTime = tic;
endExperiment = 0;

for trial = 1:2
            if endExperiment ==1;  break; end
            numberOfTargetIdentity = trial;
            if trial == 1
                whichImage = [1];
            else
                whichImage = [2 3];
            end
            
            trialTargets = 8;
            numberOfFoils = 10;
            
            targetIdentity = {};            
            targetImages = {};
            allTargetImages = {};
            whichFoilImage = [];
            imageSelection = [];
            targetImageNumber = [];
            foilImageNumber = [];
            shuffledCombinedImages = {};
            positionList = [];
            imagePositionIndex = [];
            combinedImages = [];

                       
            
            targetsPerIdentity = trialTargets/numberOfTargetIdentity;
            id = 1;
            
            
                    for n = 1:numberOfTargetIdentity
                        for i = 1:targetsPerIdentity+1
                            targetImages{n,i} = imread(strcat(groupedExamplePathList{whichImage(n)}{i}, '/', groupedExampleList{whichImage(n)}{i}));
                            allTargetImages{end+1} = targetImages{n,i};
                        end
                    end
                    
                    
                    
                    for i = 4:13
                        foilImages{i-3} = imread(strcat(groupedExamplePathList{i}{1},'/', groupedExampleList{i}{1}));
                    end

            targetIdentity = targetImages(:,1);
            
            combinedImages = {allTargetImages{:,2:trialTargets+1},foilImages{1:numberOfFoils}};
            imagePositionIndex = Shuffle(1:numel(combinedImages));

            for i = 1:numel(combinedImages)
                shuffledCombinedImages{i} = combinedImages{imagePositionIndex(i)};
                positionList(:,i) = targetPositionList(:,gridAssignment(i));
            end
            
            %% -------------------- Make textures -----------------------------
        allTextures = [];
        targetTexture = [];
        
        for n = 1:numberOfTargetIdentity
            targetTexture(end+1) = Screen('MakeTexture', window, targetIdentity{n});
        end
        
        for i = 1:numel(combinedImages)       
            allTextures(end+1) = Screen('MakeTexture', window, shuffledCombinedImages{i});
        end
        
                %% -------------- Blank screen (500 ms) ---------------------------
        Screen('FillRect', window ,grey);
        Screen('Flip',window);
        penaltyScreen = 0;
        while toc(trialEndTime) <= incorrectTimePenalty*(targetsRemaining+falseAlarms);
            if penaltyScreen == 0
                DrawFormattedText(window, 'Penalty Time', 'center', 'center', white);
                Screen('Flip',window);
                penaltyScreen = 1;
            end
        end
        
        Screen('DrawLine', window, black, X0-widthOfFix/2, Y0, X0+widthOfFix/2, Y0,lineWidth);
        Screen('DrawLine', window, black, X0, Y0-heightOfFix/2, X0, Y0+heightOfFix/2,lineWidth);
        Screen('Flip',window);
        WaitSecs(0.5);
        
        
        
        %% -------------- Blank screen (500 ms) ---------------------------
        
        if numberOfTargetIdentity > 1
            Screen('DrawTextures', window, targetTexture, [], targetArrayPosition);
            DrawFormattedText(window, targetTextDifferent, XposHeading, YposHeading, black);
            DrawFormattedText(window, 'Bart', mean([targetArrayPosition(1,1), targetArrayPosition(3,1)])-textOffset, YposSubtext+20, black);
            DrawFormattedText(window, 'Lisa', mean([targetArrayPosition(1,2), targetArrayPosition(3,2)])-textOffset, YposSubtext+20, black);
        else
            DrawFormattedText(window, targetText1, XposHeading, YposHeading, black);
            Screen('DrawTextures', window, targetTexture, [], targetPosition);
            DrawFormattedText(window, 'Homer', XposHeading, YposSubtext+20, black);
        end
        Screen('Flip',window);
        waitTime = 6;    
            
        WaitSecs(waitTime);
        
        %% ----------------- Present the images ---------------------------
        Screen('DrawTextures', window, allTextures, [], positionList);
        
        %Image number for demo         

        Screen('Flip',window);
        
%         imageArray = Screen('GetImage', window);
%         imwrite(imageArray, strcat('practice',num2str(trial),'.jpg'))
%         
        ShowCursor(0);%Show the cursor on the screen
        [theX,theY,buttons] = GetMouse(window); %Get the position of the mouse and call the coordinates [theX, theY]
        clickedPositionIndex = [];
        tstart = tic;
        lastClickTime = tic;
        distanceTraveled = 0;
        targetCode = 0;
        lastX = theX;
        lastY = theY;
        targetsRemaining = trialTargets;
        falseAlarms = 0;
        incorrectStreak = 0;
        endTrial = 0;
        whichClick = 0;

        while  1
            if endExperiment ==1;  break; end
            if endTrial ==1;  break; end
            while ~any(buttons)
                [theX,theY,buttons] = GetMouse(window); %Get the position of the mouse and call the coordinates [theX, theY]
                [ keyIsDown, seconds, keyCode ] = KbCheck; %Check the state of the keyboard. See if a key is currently pressed on the keyboard.
                
                if theX ~= lastX || theY ~= lastY
                    distanceTraveled = distanceTraveled+sqrt((lastX-theX)^2+(lastY-theY)^2);
                    lastX = theX;
                    lastY = theY;
                end
                
                if keyIsDown
                    if keyCode(escapeKey); endExperiment = 1; break; end
                    if keyCode(nextKey); endTrial = 1;                        
                        Screen('Flip',window);          
                        DrawFormattedText(window, 'End Trial', 'center', 'center', 255, 60, [], [], 2);
                        Screen('Flip',window);          
                        break; 
                    end
                end
             end
        
            while any(buttons)
                [theX,theY,buttons] = GetMouse(window);
                if theX ~= lastX || theY ~= lastY
                    distanceTraveled = distanceTraveled+sqrt((lastX-theX)^2+(lastY-theY)^2);
                    lastX = theX;
                    lastY = theY;
                end
                
            end

                %Get the position of the mouse and call the coordinates [theX, theY]
            [theX,theY,buttons] = GetMouse(window);
                
                if theX ~= lastX || theY ~= lastY
                    distanceTraveled = distanceTraveled+sqrt((lastX-theX)^2+(lastY-theY)^2);
                    lastX = theX;
                    lastY = theY;
                end

                clickedPositionIndex = find((positionList(1,:) < theX) & (positionList(3,:) > theX) & (positionList(2,:) < theY) & (positionList(4,:) > theY));
                if any(clickedPositionIndex)
                    whichClick = whichClick+1;
                    RTstart = toc(tstart);
                    RTlastClick = toc(lastClickTime);
                    lastClickTime = tic;
                    lastClickPosition(X1,whichClick) = theX;
                    lastClickPosition(Y1,whichClick) = theY;
                    if whichClick == 1
                       distanceTraveledClicks = 0;
                    else
                       distanceTraveledClicks = sqrt((lastClickPosition(X1,whichClick)-lastClickPosition(X1,whichClick-1))^2+(lastClickPosition(Y1,whichClick)-lastClickPosition(Y1,whichClick-1))^2);
                    end

                    if imagePositionIndex(clickedPositionIndex) <= trialTargets %%correct image selected
                        imageSelected = imagePositionIndex(clickedPositionIndex);
                        targetImageSelected = ceil(imageSelected/(trialTargets/numberOfTargetIdentity));
                        targetSelected = whichImage(ceil(imageSelected/(trialTargets/numberOfTargetIdentity)));
                        imagePositionIndex(clickedPositionIndex) = [];
                        allTextures(clickedPositionIndex) = [];%then delete those faces
                        positionList(:,clickedPositionIndex) = [];%and the positions of those faces
                        correct = 1;
                        incorrectStreak = 0;
                        targetsRemaining = targetsRemaining - 1;
                        
                    else %%if incorrect image selected
                        imageSelected = imagePositionIndex(clickedPositionIndex)-trialTargets;
                        correct = 0;
                        falseAlarms = falseAlarms+1;
                        incorrectStreak = incorrectStreak+1;
                        imagePositionIndex(clickedPositionIndex) = [];
                        allTextures(clickedPositionIndex) = [];%then delete those faces
                        positionList(:,clickedPositionIndex) = [];%and the positions of those faces
                        Screen('DrawTextures', window, allTextures, [], positionList);
                        Screen('Flip',window);
                    end
                end
                    if numel(allTextures) == 0
                        Screen('Flip',window);          
                        DrawFormattedText(window, 'End Trial', 'center', 'center', 255, 60, [], [], 2);
                        Screen('Flip',window);          
                        WaitSecs(ITI);
                        endTrial = 1;
                    elseif endTrial == 0;                        
                        Screen('DrawTextures', window, allTextures, [], positionList);
                        Screen('Flip',window);
                    end
                                      

                 [theX,theY,buttons] = GetMouse(window); %Get the position of the mouse and call the coordinates [theX, theY]
                 clickedPositionIndex = [];
                 correct = -99;
                 imageSelected = [];
                 targetCode = 0;
                 distanceTraveled = 0;

        end%while
        trialEndTime = tic;
   end%for trial
        penaltyScreen = 0;
        if endExperiment == 0
            while toc(trialEndTime) <= incorrectTimePenalty*(targetsRemaining+falseAlarms);
                if penaltyScreen == 0
                    DrawFormattedText(window, 'Penalty Time', 'center', 'center', white);
                    Screen('Flip',window);
                    penaltyScreen = 1;
                end
            end
        end
end
