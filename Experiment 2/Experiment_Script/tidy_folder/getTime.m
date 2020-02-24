function time = getTime
%Get the current time in the format 'DD-MM_HH-MM'

%fix rounds towards zero
s = fix(clock);
%String together the time
time = strcat(num2str(s(3)),'-',num2str(s(2)),'_',num2str(s(4)),'-',num2str(s(5)));

end%function