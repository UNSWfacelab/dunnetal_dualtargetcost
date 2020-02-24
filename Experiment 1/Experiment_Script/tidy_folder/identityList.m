
female = 1;
male = 2;
targetListComplete = [];
IDList = [1:20];
usedList = [1:20,1:20];
targetListGendered{female} = [2
    3
    4
    7
    11
    15
    16
    18
    19
    20];
targetListGendered{male} = [1
    5
    6
    8
    9
    10
    12
    13
    14
    17];

targetListComplete = [targetListGendered{female}; targetListGendered{male}];

unfamiliarIdentityNumList = IDList;

famFile = strcat('nameList.csv');
fid = fopen(famFile);
nameList = textscan(fid, '%s', 'Delimiter', ',');%C = textscan(FID,'FORMAT','PARAM',VALUE)