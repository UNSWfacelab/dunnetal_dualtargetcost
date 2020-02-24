function [studentNumber, age, G, gender] = getPptInfo
%Get studentNumber, age, and gender by asking for input

%get student number
studentNumber = input('Please enter your student number WITHOUT the "z" prefix: ');

%get participant's age
age = input('Please enter your age: ');

%get participant's gender
gender = [];
while strcmp(gender,'m') ~= 1 && strcmp(gender,'f') ~= 1
    gender = input('Please enter your gender (m/f/t/o): ', 's');
    if strcmp(gender,'m') ~= 1 && strcmp(gender,'f') ~= 1 && strcmp(gender,'t') ~= 1 && strcmp(gender,'o') ~= 1
        disp(' ');
        disp('Please enter either "m", "f", "t", "o"');
    end
end

if gender == 'f'
    G = 1;
elseif gender == 'm'
    G = 2;
elseif gender == 't'
    G = 3;
elseif gender == 'o'
    G = 4;
end

end%function