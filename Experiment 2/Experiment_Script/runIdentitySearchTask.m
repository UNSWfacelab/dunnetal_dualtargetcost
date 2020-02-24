clear all
close all

addpath(genpath('tidy_folder'));


%function memoryTask
rand('twister',sum(100*clock));%sorts out matlab randomisation problem

%% ------------------------------------------------------------------------
%Get studentNumber, age, and gender by asking for input
[studentNumber, age, G, gender] = getPptInfo;%User-defined function
pptNo = studentNumber;%Define participant number
versionCB = mod(pptNo,3)+1;
time = getTime; %Get the current time in the format 'DD-MM_HH-MM' (user-defined function)

%% ------------------- Opening the screen ---------------------------------

Screen('Preference', 'SkipSyncTests', 1);
%PsychJavaTrouble;%UNCOMMENT WHEN GET BACK TO WORK

% Opening a new window to display stimuli
screens=Screen('Screens'); screenNumber=max(screens);
window=Screen('OpenWindow',screenNumber, [], [], [], [], [], []);

%Get the width and height of the window, the X centre and Y centre of the screen
[windowWidth, windowHeight, X0, Y0] = getInfoAboutScreen(window);%user-defined function

%Set up some things to do with the keyboard
KbName('UnifyKeyNames');
ListenChar(2);%turn on character listening but suppress output of keypresses to Matlab windows
escapeKey = KbName('ESCAPE');
nextKey = KbName('space');
%HideCursor %Don't hide the cursor in this experiment

%% THESE ARE THE EXPERIMENTAL VARIABLES THAT YOU CAN CHANGE
experimentNo = 14;

% --- COLOUR LOOKUP ---
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
frameColour = black;
correctFrameColour = green;
incorrectFrameColour = red;
framePenWidth = 6;
secondsToDisplayFaces = 2;%in seconds; only valid if keyboardPressForNextTurn = 0

targetText1 = 'Find this person';
targetTextDifferent = 'Find either of these people';
targetTextSame = 'Find this person';
XposHeading = 'center';
YposHeading = Y0-150;
YposSubtext = Y0+150;
textOffset = 50; 

% --- FIXATION POINT ---
heightOfFix = 20;
widthOfFix = 20;
lineWidth = 3;


% --- VARIABLES TO DO WITH TEXT ---
textSize = 32;

%% ---------------- DEFINING VARIABLES ------------------------------------
%Put the identity numbers into this list. Must be numbers only (paste list between brackets).
%Just use numbers from the "Comparisons" folder
identityList

% --- BLOCKS ---
howManyBlocks = 1;  %including practice block
shuffleBlocks = 0; %0 = in order; 1 = shuffled
identityCap = 20; %min number of images in each identity folder
incorrectTimePenalty = 2; %Time penalty for incorrect responses
ITI = 0; %Inter-trial Interval in seconds
demoDisplay = 0;

%% ------------------------ EDIT BLOCKS -----------------------------------

% --- VARIABLES ---
%You can allocate just one number to variables (*FOR EACH BLOCK*)
%
%                       *** NB ***
%I have changed this bit of allocating variables to blocks to save space.
%The first number corresponds to the value for Block 1, the second number
%corresponds to the value for Block 2 etc. If you need to add another block
%then just add a number to the end of each list.

%For the memory task, number of trials = number of games
numberOfTrials = {18}; %enter the number of trials (games) you want for each block
numberOfTargets = {[4 6 8]}; %enter the number of targets per trial you want for each block
setSize = {40}; %enter the number of foils per trial you want for each block
targetDisplayTime = {6}; %how long the target image is shown for in seconds
selfTerminate = {1}; % 0 = Auto, 1 = Self
feedback = {0}; %incorrect selection feedback, 0 = no, 1 = yes
incorrectStreakTerminate = {99}; %number of consecutive incorrect choices made before termination


% --- LISTS ---
%You can allocate multiple numbers to lists
%e.g. list = [0 0 1] means that 1/3 of trials will have a value of 1
%NB: To add another block, copy+paste a new list under each list and change
%the number in curly brackets to the block number

%There are currently no lists

block = 1;

%% ------------------------------------------------------------------------

%Make a list of blocks
if shuffleBlocks == 1
    blockList = Shuffle(1:howManyBlocks);
else
    blockList = 1:howManyBlocks;
end

%Where to look for the images
parentDirectory = 'Images';
unfamiliarDirectory = '/Dutch';
unfamiliarImage = '/DU*.jpg';


%Make a list of all the image files in the Comparisons and Foils folders
%[Makes a list of files (fileList) and a list with their corresponding paths (pathList)]
[unfamiliarImagesPathList, unfamiliarImagesFileList] = folderSearch(strcat(parentDirectory,unfamiliarDirectory),unfamiliarImage);%User-defined function

%Make a list of just the prefixes of all the images, so we can compare these to the targetNumList
for i = 1:numel(unfamiliarImagesFileList)%For each image
    unfamiliarImagesPrefixList(i) = str2num(unfamiliarImagesFileList{i}(3:4));%Convert from strings to numbers
end

%Group the images into identities
groupedUnfamiliarImagesPrefixList = {}; groupedUnfamiliarList = {}; groupedFamiliarImagesPrefixList = {}; groupedFamiliarList = {}; groupedUnfamiliarPathList = {}; groupedFamiliarPathList = {};


for i = 1:numel(unfamiliarIdentityNumList)%for each target
    groupedUnfamiliarImagesPrefixList{i} = unfamiliarImagesPrefixList(unfamiliarImagesPrefixList == unfamiliarIdentityNumList(i));
    groupedUnfamiliarList{i} = unfamiliarImagesFileList(unfamiliarImagesPrefixList == unfamiliarIdentityNumList(i));
    groupedUnfamiliarPathList{i} = unfamiliarImagesPathList(unfamiliarImagesPrefixList == unfamiliarIdentityNumList(i));
end

unfamiliarDirectoryUK = '/UK';
unfamiliarImageUK = '/UK*.jpg';

[unfamiliarImagesPathListUK, unfamiliarImagesFileListUK] = folderSearch(strcat(parentDirectory,unfamiliarDirectoryUK),unfamiliarImageUK);%User-defined function

%Make a list of just the prefixes of all the images, so we can compare these to the targetNumList
for i = 1:numel(unfamiliarImagesFileListUK)%For each image
    unfamiliarImagesPrefixListUK(i) = str2num(unfamiliarImagesFileListUK{i}(3:4));%Convert from strings to numbers
end


%Group the images into identities
groupedUnfamiliarImagesPrefixListUK = {}; groupedUnfamiliarListUK = {}; groupedFamiliarImagesPrefixListUK = {}; groupedFamiliarListUK = {}; groupedUnfamiliarPathListUK = {}; groupedFamiliarPathListUK = {};


for i = 1:numel(unfamiliarIdentityNumListUK)%for each target
    groupedUnfamiliarImagesPrefixListUK{i} = unfamiliarImagesPrefixListUK(unfamiliarImagesPrefixListUK == unfamiliarIdentityNumListUK(i));
    groupedUnfamiliarListUK{i} = unfamiliarImagesFileListUK(unfamiliarImagesPrefixListUK == unfamiliarIdentityNumListUK(i));
    groupedUnfamiliarPathListUK{i} = unfamiliarImagesPathListUK(unfamiliarImagesPrefixListUK == unfamiliarIdentityNumListUK(i));
end


%%

%% ----------------------- POSITIONS --------------------------------------
TargetPositions
gridAssignment = randperm(gridColumnCount*gridRowCount);


%%

if versionCB ==1
    condition = repmat([1,2,3],[1,numel(usedList)/3]);
elseif versionCB ==2
    condition = repmat([2,3,1],[1,numel(usedList)/3]);
elseif versionCB ==3
    condition = repmat([3,1,2],[1,numel(usedList)/3]);
end

for i = 1:howManyBlocks
    index = Shuffle(1:numberOfTrials{i});
    howManyTargets{i} = repmat(numberOfTargets{block},1,ceil(numberOfTrials{block}/numel(numberOfTargets{block})));
    howManyTargets{i} = Shuffle(howManyTargets{i});
    for m = 1:numel(index)
        unfamiliarTargetImageIndices{i}(m) = usedList(index(m));
        shuffledCondition{i}(m) = condition(index(m));
    end
end
    
experimentTrial = 0; endExperiment = 0; blockOrder = 0; endTrial = 0; experimentClick = 0; imageSelected = 0; distanceTraveledClicks = 0; lastClickPosition = [];
unfamiliarImageIndex = 1; familiarImageIndex = 1; targetsRemaining = 0; left = 1; right = 2; identityName = {}; summaryHeading = {}; falseAlarms = 0;
genderCount = [0,0]; nameOrder = Shuffle(1:10);

DATAmatrix = []; heading = {}; summaryMatrix = [];

Screen('FillRect',window ,black);
Screen('TextFont',window, 'Arial');
Screen('TextSize',window, textSize);

for block = blockList
    blockOrder = blockOrder+1;
    if endExperiment == 1; break; end

    if blockOrder == 1
         startExperimentIdentity(window,windowWidth,windowHeight,Y0,nextKey);
         startPracticeTrials(window,windowWidth,windowHeight,Y0,nextKey);
         practiceExampleIdentity(window,windowWidth,windowHeight,nextKey,targetPosition,targetArrayPosition,targetPositionList,gridAssignment,X0,Y0);
         endPracticeTrials(window,windowWidth,windowHeight,Y0,nextKey);
    end
    Screen('TextSize',window, textSize);
    imageNumberDisplay = [];
    shuffledImageNumberDisplay = [];
    trialEndTime = tic;
    
    for trial = 1:numberOfTrials{block}
            experimentTrial = experimentTrial+1;
            whichImage = [];
            endTrial = 0; whichClick = 0;
            if endExperiment == 1; break; end

            gridAssignment = randperm(gridColumnCount*gridRowCount);
            
            if shuffledCondition{block}(trial) > 1
                imagesShown = 2;
            else imagesShown = 1;
            end
            

            trialType = 1; %%unfamiliar
            for n = 1:imagesShown
                if unfamiliarImageIndex > numel(groupedUnfamiliarList)
                    unfamiliarImageIndex = 1;                            
                end
                whichImage(n) = unfamiliarTargetImageIndices{block}(unfamiliarImageIndex);
                if find(whichImage(n)==targetListComplete) > numel(targetListGendered{female})
                    imageGender = male;
                else imageGender = female;
                end
            end
            unfamiliarImageIndex = unfamiliarImageIndex+1;
            
            targetImages = {};
            allTargetImages = {};
            whichFoilImage = [];
            imageSelection = [];
            targetImageNumber = [];
            foilImageNumber = [];
            getFoilImage = 1;
            index = 1;
            
            trialTargets = howManyTargets{block}(trial);
            numberOfFoils = setSize{block}-trialTargets;
            
            while numel(whichFoilImage) <= numberOfFoils
                if index > numel(targetListGendered{imageGender})
                    index = 1;                            
                end
                whichFoilImage(getFoilImage) = targetListGendered{imageGender}(index);
                if whichImage ~= whichFoilImage(getFoilImage)
                    getFoilImage = getFoilImage+1;
                end
                index = index+1;
            end
            whichFoilImage = Shuffle(whichFoilImage);
            
            targetsPerIdentity = trialTargets/imagesShown+1;

            imageSelection = randperm(identityCap);            
            id = 1;
            
                    targetNumber(1) = whichImage(1);
                    if imagesShown > 1
                        targetNumber(2) = whichImage(2);
                    else
                        targetNumber(2) = 0;
                    end
                    for n = 1:imagesShown
                        for m = 1:targetsPerIdentity
                            targetImages{n,m} = imread(strcat(groupedUnfamiliarPathList{whichImage(n)}{imageSelection(id)}, '/', groupedUnfamiliarList{whichImage(n)}{imageSelection(id)}));
                            targetImageNumber(n) = imageSelection(n);
                            id = id+1;
                        end
                    end
                    
                    identityName{left} = nameList{1}{whichImage*2-1};

                    if shuffledCondition{block}(trial) == 3
                        imageSelection = randperm(identityCap);            
                        genderCount(imageGender) = genderCount(imageGender)+1;
                        whichImage(2) = secondListGendered{imageGender}(genderCount(imageGender));
                        identityName{right} = UKnameList{1}{nameOrder(genderCount(imageGender))*2+(imageGender-2)};
                        for m = 1:targetsPerIdentity
                            targetImages{2,m} = imread(strcat(groupedUnfamiliarPathListUK{whichImage(2)}{imageSelection(id)}, '/',groupedUnfamiliarListUK{whichImage(2)}{imageSelection(id)}));
                            id = id+1;
                        end
                        targetImageNumber(2) = imageSelection(n);
                        
                    else
                        identityName{right} = identityName{left};
                    end
                    
                    imageSelection = randperm(identityCap);            
                    for i = 1:numberOfFoils
                        if id > numel(imageSelection)
                            id = 1;
                        end
                        
                        if i > numel(imageSelection)
                            sync = find(whichFoilImage(i)==whichFoilImage(1:(i-1)));
                            if sync ~= 0
                                for j = 1:numel(sync)
                                    while foilImageNumber(sync(j)) == imageSelection(id)
                                        if id >= numel(imageSelection)
                                            id = 1;
                                        else
                                            id = id+1;
                                        end
                                    end
                                end
                            end
                        end

                        foilImages{i} = imread(strcat(groupedUnfamiliarPathList{whichFoilImage(i)}{imageSelection(id)},'/', groupedUnfamiliarList{whichFoilImage(i)}{imageSelection(id)}));
                        foilImageNumber(i) = imageSelection(id);
                        imageNumberDisplay = [imageNumberDisplay imageSelection(id)];
                             id = id+1;
                    end
                        
            combinedImages = {targetImages{:,2:(targetsPerIdentity)},foilImages{1:numberOfFoils}};
            imagePositionIndex = Shuffle(1:numel(combinedImages));

            for i = 1:numel(combinedImages)
                shuffledCombinedImages{i} = combinedImages{imagePositionIndex(i)};
                positionList(:,i) = targetPositionList(:,gridAssignment(i));
%                 shuffledImageNumberDisplay(i) = imageNumberDisplay(imagePositionIndex(i));
            end
            
            %% -------------------- Make textures -----------------------------
        allTextures = [];
        targetTexture = [];
        
        for n = 1:imagesShown
            targetTexture(end+1) = Screen('MakeTexture', window, targetImages{n,1});
        end
        
        for i = 1:numel(combinedImages)       
            allTextures(end+1) = Screen('MakeTexture', window, shuffledCombinedImages{i});
        end
        
                %% -------------- Blank screen (500 ms) ---------------------------
        Screen('FillRect', window ,black);
        Screen('Flip',window);
        penaltyScreen = 0;
        
        while toc(trialEndTime) <= incorrectTimePenalty*(targetsRemaining+falseAlarms);
            if penaltyScreen == 0
                DrawFormattedText(window, 'Penalty Time', XposHeading, YposHeading, white);
                Screen('Flip',window);
                penaltyScreen = 1;
            end
        end
        
        if endExperiment ~= 1 && block > 0 && block ~= blockList(end)
            takeBreak(window,windowWidth,windowHeight,Y0,nextKey);
        end
        
        Screen('DrawLine', window, white, X0-widthOfFix/2, Y0, X0+widthOfFix/2, Y0,lineWidth);
        Screen('DrawLine', window, white, X0, Y0-heightOfFix/2, X0, Y0+heightOfFix/2,lineWidth);
        Screen('Flip',window);
        WaitSecs(0.5);
        
        
        %% -------------- Blank screen (500 ms) ---------------------------
        
        if imagesShown > 1
            Screen('DrawTextures', window, targetTexture, [], targetArrayPosition);
            
            if shuffledCondition{block}(trial) == 2
                DrawFormattedText(window, targetTextSame, XposHeading, YposHeading, white);
                DrawFormattedText(window, identityName{left}, mean([targetArrayPosition(1,1), targetArrayPosition(3,1)])-textOffset, YposSubtext, white);
                DrawFormattedText(window, identityName{left}, mean([targetArrayPosition(1,2), targetArrayPosition(3,2)])-textOffset, YposSubtext, white);

            elseif shuffledCondition{block}(trial) == 3
                DrawFormattedText(window, targetTextDifferent, XposHeading, YposHeading, white);
                DrawFormattedText(window, identityName{left}, mean([targetArrayPosition(1,1), targetArrayPosition(3,1)])-textOffset, YposSubtext, white);
                DrawFormattedText(window, identityName{right}, mean([targetArrayPosition(1,2), targetArrayPosition(3,2)])-textOffset, YposSubtext, white);
            end


            if demoDisplay == 1
                for i = 1:imagesShown
                    DrawFormattedText(window, num2str(targetImageNumber(i)), targetArrayPosition(1,i), targetArrayPosition(2,i), white);
                end
            end
        else
            Screen('DrawTextures', window, targetTexture, [], targetPosition);
            if demoDisplay == 1
                DrawFormattedText(window, num2str(targetImageNumber(1)), targetPosition(1), targetPosition(2), white);
            end
            DrawFormattedText(window, targetText1, XposHeading, YposHeading, white);
            DrawFormattedText(window, identityName{left}, XposHeading, YposSubtext, white);

        end
        
        Screen('Flip',window);
%         imageArray = Screen('GetImage', window);
%         imwrite(imageArray, strcat('target',num2str(block),'-',num2str(trial),'.jpg'))
        WaitSecs(targetDisplayTime{block});
        
        %% ----------------- Present the images ---------------------------
        Screen('DrawTextures', window, allTextures, [], positionList);
        
        %Image number for demo        
        
        if demoDisplay == 1
            for m = 1:numel(shuffledImageNumberDisplay)
                DrawFormattedText(window, num2str(shuffledImageNumberDisplay(m)), positionList(1,m), positionList(2,m), white);
            end
        end

        Screen('Flip',window);
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
        incorrectStreak = 0;
        hits = 0;
        falseAlarms = 0;
        RTstart = -99;
%         imageArray = Screen('GetImage', window);
%         imwrite(imageArray, strcat('array',num2str(block),'-',num2str(trial),'.jpg'))

        while  1
            if endTrial == 1;  break; end
            if endExperiment == 1; break; end
            while ~any(buttons)
                [theX,theY,buttons] = GetMouse(window); %Get the position of the mouse and call the coordinates [theX, theY]
                [ keyIsDown, seconds, keyCode ] = KbCheck; %Check the state of the keyboard. See if a key is currently pressed on the keyboard.
                
                if theX ~= lastX || theY ~= lastY
                    distanceTraveled = distanceTraveled+sqrt((lastX-theX)^2+(lastY-theY)^2);
                    lastX = theX;
                    lastY = theY;
                end
                
                if keyIsDown
                    if keyCode(escapeKey); endTrial = 1; endExperiment = 1; break; end
                    if keyCode(nextKey); endTrial = 1;
                        RTstart = toc(tstart);
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
                
                if endTrial == 0
                    clickedPositionIndex = find((positionList(1,:) < theX) & (positionList(3,:) > theX) & (positionList(2,:) < theY) & (positionList(4,:) > theY));
                    if any(clickedPositionIndex)
                        experimentClick = experimentClick+1;
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
                                targetImageSelected = ceil(imageSelected/(trialTargets/imagesShown));
                                targetSelected = whichImage(ceil(imageSelected/(trialTargets/imagesShown)));

                                if trialType ==1
                                    if shuffledCondition{block}(trial) == 3 && imageSelected > (trialTargets/imagesShown)
                                        whichSelected = groupedUnfamiliarListUK{targetSelected}{targetImageNumber(targetImageSelected)};
                                    else
                                        whichSelected = groupedUnfamiliarList{targetSelected}{targetImageNumber(targetImageSelected)};
                                    end
                                elseif trialType == 2
                                    whichSelected = groupedFamiliarList{targetSelected}{targetImageNumber(targetImageSelected)};
                                end
                            imagePositionIndex(clickedPositionIndex) = [];
                            allTextures(clickedPositionIndex) = [];%then delete those faces
                            positionList(:,clickedPositionIndex) = [];%and the positions of those faces
%                             shuffledImageNumberDisplay(clickedPositionIndex) = [];
                            correct = 1;
                            hits = hits+1;
                            incorrectStreak = 0;
                            targetsRemaining = targetsRemaining - 1;
                            if demoDisplay == 1
                                for m = 1:numel(shuffledImageNumberDisplay)
                                    DrawFormattedText(window, num2str(shuffledImageNumberDisplay(m)), positionList(1,m), positionList(2,m), white);
                                end
                            end
                        else %%if incorrect image selected
                            imageSelected = imagePositionIndex(clickedPositionIndex)-trialTargets;
                            correct = 0;
                            falseAlarms = falseAlarms+1;
                            incorrectStreak = incorrectStreak+1;
                            if trialType ==1
                                whichSelected = groupedUnfamiliarList{whichFoilImage(imageSelected)}{foilImageNumber(imageSelected)};
                            elseif trialType == 2
                                whichSelected = groupedFamiliarList{whichFoilImage(imageSelected)}{foilImageNumber(imageSelected)};
                            end
                            if selfTerminate{block} == 0
    %                             Screen('DrawTextures', window, allTextures, [], positionList);
                                if feedback{block} == 1
    %                                 Screen('FrameRect', window, red, positionList(:,clickedPositionIndex), framePenWidth);%Then draw a border around those faces
                                    DrawFormattedText(window, 'Incorrect!', 'center', 'center', 255, 60, [], [], 2);
                                end
                                if demoDisplay == 1
                                    for m = 1:numel(shuffledImageNumberDisplay)
                                        DrawFormattedText(window, num2str(shuffledImageNumberDisplay(m)), positionList(1,m), positionList(2,m), white);
                                    end
                                end

                                Screen('Flip',window);          
    %                             imagePositionIndex(clickedPositionIndex) = [];
    %                             allTextures(clickedPositionIndex) = [];%then delete those faces
    %                             positionList(:,clickedPositionIndex) = [];%and the positions of those faces
    %                             shuffledImageNumberDisplay(clickedPositionIndex) = [];

                                if demoDisplay == 1
                                    for m = 1:numel(shuffledImageNumberDisplay)
                                        DrawFormattedText(window, num2str(shuffledImageNumberDisplay(m)), positionList(1,m), positionList(2,m), white);
                                    end
                                end
                                if incorrectStreak >= incorrectStreakTerminate{block}
                                    endTrial = 1;                        
                                    DrawFormattedText(window, 'Incorrect Selection - End Trial', 'center', 'center', 255, 60, [], [], 2);
                                    Screen('Flip',window);
                                    WaitSecs(incorrectTimePenalty);
                                else
                                    WaitSecs(incorrectTimePenalty);
                                    lastClickTime = tic;
                                end

                            else
                                if feedback{block} == 1
                                    Screen('FrameRect', window, red, positionList(:,clickedPositionIndex), framePenWidth);%Then draw a border around those faces
                                    DrawFormattedText(window, 'Incorrect!', 'center', 'center', 255, 60, [], [], 2);
                                end
                                if demoDisplay == 1
                                    for m = 1:numel(shuffledImageNumberDisplay)
                                        DrawFormattedText(window, num2str(shuffledImageNumberDisplay(m)), positionList(1,m), positionList(2,m), white);
                                    end
                                end
                                if incorrectStreak >= incorrectStreakTerminate{block}
                                    endTrial = 1;                        
                                    Screen('Flip',window);          
                                    DrawFormattedText(window, 'End Trial', 'center', 'center', 255, 60, [], [], 2);
                                    Screen('Flip',window);
                                    WaitSecs(incorrectTimePenalty);
                                end

                                imagePositionIndex(clickedPositionIndex) = [];
                                allTextures(clickedPositionIndex) = [];%then delete those faces
                                positionList(:,clickedPositionIndex) = [];%and the positions of those faces
                                lastClickTime = tic;
                            end


                        end

                    end
                end
                
                    if selfTerminate{block}~=0 && numel(allTextures) == 0
                        Screen('Flip',window);          
                        DrawFormattedText(window, 'End Trial', 'center', 'center', 255, 60, [], [], 2);
                        Screen('Flip',window);          
                        endTrial = 1;
                    elseif selfTerminate{block}==0 && targetsRemaining == 0;%if there are no faces left
                        Screen('Flip',window);          
                        DrawFormattedText(window, 'Complete!', 'center', 'center', 255, 60, [], [], 2);
                        Screen('Flip',window);          
                        WaitSecs(ITI);
                        endTrial = 1;
                    elseif endTrial == 0; 
                        Screen('DrawTextures', window, allTextures, [], positionList);
                        Screen('Flip',window);
                    end
                    

                    
                    if clickedPositionIndex ~= 0;                        
                        %full data
                        pos = 0; heading = {};
                        pos=pos+1;  DATAmatrix(experimentClick,pos) = pptNo;                                        heading{pos} = 'Ppt no.';
                        pos=pos+1;  DATAmatrix(experimentClick,pos) = G;                                            heading{pos} = 'Gender (1=F, 2=M)';
                        pos=pos+1;  DATAmatrix(experimentClick,pos) = age;                                          heading{pos} = 'Age';
                        pos=pos+1;  DATAmatrix(experimentClick,pos) = blockOrder;                                   heading{pos} = 'Block order (the order blocks were presented)';
                        pos=pos+1;  DATAmatrix(experimentClick,pos) = block;                                        heading{pos} = 'Block (specific block presented)';
                        pos=pos+1;  DATAmatrix(experimentClick,pos) = experimentTrial;                              heading{pos} = 'Experiment Trial';
                        pos=pos+1;  DATAmatrix(experimentClick,pos) = selfTerminate{block};                         heading{pos} = 'Termination Condition (0=Auto, 1=Self)';
                        pos=pos+1;  DATAmatrix(experimentClick,pos) = feedback{block};                              heading{pos} = 'Feedback';
                        pos=pos+1;  DATAmatrix(experimentClick,pos) = incorrectStreakTerminate{block};              heading{pos} = 'Incorrect Streak Limit';
                        pos=pos+1;  DATAmatrix(experimentClick,pos) = trial;                                        heading{pos} = 'Trial';
                        pos=pos+1;  DATAmatrix(experimentClick,pos) = trialTargets;                                 heading{pos} = 'Number of Targets';
                        pos=pos+1;  DATAmatrix(experimentClick,pos) = numberOfFoils;                                heading{pos} = 'Number of Foils';
                        pos=pos+1;  DATAmatrix(experimentClick,pos) = imagesShown;                                  heading{pos} = 'Number of Target Images';
                        pos=pos+1;  DATAmatrix(experimentClick,pos) = shuffledCondition{block}(trial);              heading{pos} = 'Trial Type (1 = Single, 2 = Same, 3 = Different)';
                        pos=pos+1;  DATAmatrix(experimentClick,pos) = targetNumber(1);                              heading{pos} = 'Target Number 1';
                        pos=pos+1;  DATAmatrix(experimentClick,pos) = targetNumber(2);                              heading{pos} = 'Target Number 2';
                        pos=pos+1;  DATAmatrix(experimentClick,pos) = experimentClick;                              heading{pos} = 'How Many Clicks in Experiment?';
                        pos=pos+1;  DATAmatrix(experimentClick,pos) = whichClick;                                   heading{pos} = 'How Many Clicks in Trial?';
                        pos=pos+1;  DATAmatrix(experimentClick,pos) = str2num(whichSelected(3:4));                  heading{pos} = 'Which Identity Was Clicked';
                        pos=pos+1;  DATAmatrix(experimentClick,pos) = str2num(whichSelected(6:7));                  heading{pos} = 'Which Image Was Clicked';
                        pos=pos+1;  DATAmatrix(experimentClick,pos) = distanceTraveledClicks;                       heading{pos} = 'Distance Travelled between Images';
                        pos=pos+1;  DATAmatrix(experimentClick,pos) = distanceTraveled;                             heading{pos} = 'Mouse Distance Travelled';
                        pos=pos+1;  DATAmatrix(experimentClick,pos) = correct;                                      heading{pos} = 'Correct';
                        pos=pos+1;  DATAmatrix(experimentClick,pos) = incorrectStreak;                              heading{pos} = 'No. of consecutive incorrect selections';
                        pos=pos+1;  DATAmatrix(experimentClick,pos) = targetsRemaining;                             heading{pos} = 'No. Targets Left';
                        pos=pos+1;  DATAmatrix(experimentClick,pos) = RTstart;                                      heading{pos} = 'Time Since Start';
                        pos=pos+1;  DATAmatrix(experimentClick,pos) = RTlastClick;                                  heading{pos} = 'Time Since Last Click';
    
                    end

                 [theX,theY,buttons] = GetMouse(window); %Get the position of the mouse and call the coordinates [theX, theY]
                 clickedPositionIndex = [];
                 correct = -99;
                 imageSelected = [];
                 targetCode = 0;
                 distanceTraveled = 0;

        end%while
        
        if endTrial == 1
            trialEndTime = tic;
            %summary data
            pos = 0; summaryHeading = {};
            pos=pos+1; summaryMatrix(experimentTrial,pos) = pptNo;                                      summaryHeading{pos} = 'Ppt no.';
            pos=pos+1; summaryMatrix(experimentTrial,pos) = G;                                          summaryHeading{pos} = 'Gender (1=F, 2=M)';
            pos=pos+1; summaryMatrix(experimentTrial,pos) = age;                                        summaryHeading{pos} = 'Age';
            pos=pos+1; summaryMatrix(experimentTrial,pos) = blockOrder;                                 summaryHeading{pos} = 'Block order (the order blocks were presented)';
            pos=pos+1; summaryMatrix(experimentTrial,pos) = block;                                      summaryHeading{pos} = 'Block (specific block presented)';
            pos=pos+1; summaryMatrix(experimentTrial,pos) = experimentTrial;                            summaryHeading{pos} = 'Experiment Trial';
            pos=pos+1; summaryMatrix(experimentTrial,pos) = trial;                                      summaryHeading{pos} = 'Trial';
            pos=pos+1; summaryMatrix(experimentTrial,pos) = trialTargets;                               summaryHeading{pos} = 'Number of Targets';
            pos=pos+1; summaryMatrix(experimentTrial,pos) = imagesShown;                                summaryHeading{pos} = 'Number of Target Images';
            pos=pos+1; summaryMatrix(experimentTrial,pos) = shuffledCondition{block}(trial);            summaryHeading{pos} = 'Trial Type (1 = Single, 2 = Same, 3 = Different)';
            pos=pos+1; summaryMatrix(experimentTrial,pos) = targetNumber(1);                            summaryHeading{pos} = 'Target Number 1';
            pos=pos+1; summaryMatrix(experimentTrial,pos) = targetNumber(2);                            summaryHeading{pos} = 'Target Number 2';
            pos=pos+1; summaryMatrix(experimentTrial,pos) = hits;                                       summaryHeading{pos} = 'Hits';
            pos=pos+1; summaryMatrix(experimentTrial,pos) = falseAlarms;                                summaryHeading{pos} = 'False Alarms';
            pos=pos+1; summaryMatrix(experimentTrial,pos) = targetsRemaining;                           summaryHeading{pos} = 'Missed Targets';
            pos=pos+1; summaryMatrix(experimentTrial,pos) = RTstart;                                    summaryHeading{pos} = 'Time Taken';
        end
        
        if endExperiment == 0
                    %Save the headings to a .mat file
                     headingsFilename = 'headings.mat';
                     save(headingsFilename,'heading');
                     summaryHeadingsFilename = 'SummaryHeadings.mat';
                     save(summaryHeadingsFilename,'summaryHeading');
                    %Save the data as you go
                        variablesFilename = strcat('saveVariables/',num2str(pptNo),'_saveVariables','.mat');
                        save(variablesFilename);
                        summaryMatrixTrial = summaryMatrix(experimentTrial,:);                                        
                        trialSummaryDATAfilename = strcat('Raw_Data/SUMMARY_exp',num2str(experimentNo),' ppt',num2str(pptNo),' gender [', gender,'] age [', num2str(age),'] time [',time,'].m');
                        save(trialSummaryDATAfilename,'summaryMatrixTrial','-ascii', '-tabs','-append');
        end

   end%for trial
        
    
end%for block

                    trialDATAfilename = strcat('Raw_Data/Full/FULL_exp',num2str(experimentNo),' ppt',num2str(pptNo),' gender [', gender,'] age [', num2str(age),'] time [',time,'].m');
                    save(trialDATAfilename,'DATAmatrix','-ascii', '-tabs','-append');
                    
%% ---------------- End experiment ----------------------------------------
while KbCheck; end %Wait until all keys have been released

        while toc(trialEndTime) <= incorrectTimePenalty*(targetsRemaining+falseAlarms)
        end
        
%ShowCursor;

% finishExperiment(window,windowWidth,windowHeight,Y0);%Display finish experiment screen
% 
% ListenChar(1);%turn on character listening
% 
% 
% Screen('Close',window);
takeBreak(window,windowWidth,windowHeight,Y0,nextKey);
deceptionPhaseTask
