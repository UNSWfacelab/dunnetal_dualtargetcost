
female = 1;
male = 2;
targetListComplete = [];
IDList = [1:20]';
usedList = [1:16,18:19]';
targetListGendered{female} = [2
    3
    4
    7
    11
    15
    16
    18
    19];
targetListGendered{male} = [1
    5
    6
    8
    9
    10
    12
    13
    14];

targetListComplete = [targetListGendered{female}; targetListGendered{male}];

unfamiliarIdentityNumList = IDList;

famFile = strcat('nameList.csv');
fid = fopen(famFile);
nameList = textscan(fid, '%s', 'Delimiter', ',');%C = textscan(FID,'FORMAT','PARAM',VALUE)


secondListGendered{female} = [7
    8
    9
    13
    19
    26
    29
    32
    34];

secondListGendered{male} = [5
    10
    14
    20
    23
    24
    31
    35
    39];

UKtargetListComplete = [secondListGendered{female}; secondListGendered{male}];

unfamiliarIdentityNumListUK=[1:40];

secondListGendered{female} = Shuffle(secondListGendered{female});
secondListGendered{male} = Shuffle(secondListGendered{male});

famFile = strcat('UKnameList.csv');
fid = fopen(famFile);
UKnameList = textscan(fid, '%s', 'Delimiter', ',');%C = textscan(FID,'FORMAT','PARAM',VALUE)