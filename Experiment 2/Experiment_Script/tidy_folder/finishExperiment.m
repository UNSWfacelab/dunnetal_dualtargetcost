function finishExperiment(windowPtr,windowWidth,windowHeight,v_where)

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
endExperimentText = 'End of experiment.';
endExperimentText2 = 'Please get the experimenter.';
DrawFormattedText(windowPtr, endExperimentText, 'center', 'center', textcolour, wrapat2, [], [], vSpacing2);
DrawFormattedText(windowPtr, endExperimentText2, 'center', v_where+50, textcolour, wrapat2, [], [], vSpacing2);

Screen(windowPtr, 'Flip');

KbWait

end