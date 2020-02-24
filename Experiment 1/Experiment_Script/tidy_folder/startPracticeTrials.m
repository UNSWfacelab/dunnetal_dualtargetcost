function startPracticeTrials(windowPtr,windowWidth,windowHeight,v_where,spaceKey)

grey = 128;

% Select specific text font, style and size:
Screen('TextFont',windowPtr, 'Arial');
Screen('TextSize',windowPtr, 16);
%Screen('TextStyle', window, 1+2);

textcolour = 255;%white
wrapat = 60;%wrap at 60 characters
wrapat2 = 100;
vSpacing = 4;
vSpacing2 = 2;


Screen('FillRect', windowPtr, grey, [0, 0, windowWidth, windowHeight]);%clear the screen
startPracticeText = 'We are now going to start with some practice trials.';
startPracticeText2 = 'Please call the experimenter now if you have any questions.';
startPracticeText3 = 'Press the SPACE key to continue.';
DrawFormattedText(windowPtr, startPracticeText, 'center', v_where-70, textcolour, wrapat2, [], [], vSpacing2);
DrawFormattedText(windowPtr, startPracticeText2, 'center', 'center', textcolour, wrapat2, [], [], vSpacing2);
DrawFormattedText(windowPtr, startPracticeText3, 'center', v_where+50, textcolour, wrapat2, [], [], vSpacing2);
Screen(windowPtr, 'Flip');

while KbCheck;
end % Wait until all keys are released before continuing.
while 1 %while 1 is always true, so this loop will continue indefinitely.
    [ keyIsDown, seconds, keyCode ] = KbCheck; %Check the state of the keyboard. See if a key is currently pressed on the keyboard.
    if keyIsDown
        find(keyCode);
        KbName(keyCode);
        %if keyCode(spaceKey); break; end
        if keyCode(spaceKey);
            break;
        end
        while KbCheck;
        end %Once a key has been pressed we wait until all keys have been released before going through the loop again
    end%if keyIsDown
end%while

for countdown = 0:4
    experimentStartText = 'This block will start in';
    countdownText = 5-countdown;
    DrawFormattedText(windowPtr, experimentStartText, 'center', 'center', textcolour, [], [], [], []);
    DrawFormattedText(windowPtr, num2str(countdownText), 'center', v_where+50, textcolour, [], [], [], []);
    Screen(windowPtr,'Flip');
    WaitSecs(1);
end


end