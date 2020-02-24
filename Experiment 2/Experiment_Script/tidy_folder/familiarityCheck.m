
famFile = strcat('Identities.csv');

folder = 'Familiarity';
fileLocation = [];
familiarKey = KbName('y');
unfamiliarKey = KbName('n');
numberOfIdentities = 40;

fid = fopen(strcat(folder,'/',famFile));

C1 = textscan(fid, '%s', 'Delimiter', ',');%C = textscan(FID,'FORMAT','PARAM',VALUE)
fclose(fid);
Screen('FillRect',window, grey);
Screen('TextFont',window, 'Arial');
Screen('TextSize',window, 48);

familiarityInstructions(window,windowWidth,windowHeight,Y0,nextKey);

familiarText = 'Is this name familiar to you?';
familiarityResponse = [];
endExperiment = 0;
familiarIdentityNumList = [];
unfamiliarIdentityNumList = [];
numberList = Shuffle(1:numberOfIdentities);

for n = 1:numberOfIdentities
    identityText = C1{1}{numberList(n)};
    DrawFormattedText(window, familiarText, 'center', Y0-200, white);
    DrawFormattedText(window, identityText, 'center', 'center', white);
    Screen('Flip',window);

    while KbCheck; end %Wait until all keys have been released
    while 1 %while 1 is always true, so this loop will continue indefinitely.
        if endExperiment == 1; Screen('Close',window); ShowCursor; ListenChar(1); quitexperiment; end
        [ keyIsDown, seconds, keyCode ] = KbCheck; %Check the state of the keyboard. See if a key is currently pressed on the keyboard.
            
        if keyIsDown
            find(keyCode);
            KbName(keyCode);
            whichKey = find(keyCode);
                %If a meaningful key was pressed
                if keyCode(escapeKey); endExperiment = 1; break; end
                if keyCode(familiarKey) || keyCode(unfamiliarKey)
                    %this records the number of the image that was selected (1 or 2), NOT the side that was chosen
                    if keyCode(familiarKey); familiarityResponse(numberList(n)) = 1; end
                    if keyCode(unfamiliarKey); familiarityResponse(numberList(n)) = 0;  end                       
                    Screen('Flip',window);
                    WaitSecs(0.5);
                    break;
                end
                
                while KbCheck; end %Once a key has been pressed we wait until all keys have been released before going through the loop again
                
            end%if keyIsDown
        end%while 1
end

                    trialDATAfilename = strcat('Raw_Data/Familiarity/Familiarity_exp',num2str(experimentNo),' ppt',num2str(pptNo),' gender [', gender,'] age [', num2str(age),'] time [',time,'].m');
                    save(trialDATAfilename,'familiarityResponse','-ascii', '-tabs','-append');
