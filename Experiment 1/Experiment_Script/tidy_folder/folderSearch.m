function [pathList, fileList] = folderSearch(folderName,format,existingList,existingPathList,path)

if nargin < 2
    format = [];
    existingList = {};
    existingPathList = {};
    path = [];
elseif nargin < 3
    existingList = {};
    existingPathList = {};
    path = [];
elseif nargin < 4
    existingPathList = {};
    path = [];
elseif nargin < 5
    path = [];
end

pathList = existingPathList;
fileList = existingList;%Make the fileList the existing list

%add any .hdr files to the list
c = dir(strcat(path,folderName,format));%find any files ending in .hdr

for i = 1:numel(c)%for how many files there are
    pathList{end+1} = strcat(path,folderName);
    fileList{end+1} = c(i).name;%add those files to fileList
end


a = dir(strcat(path,folderName));%list all the contents of the specified folder

path = strcat(path,folderName,'/');
for i = 1:numel(a)%check each item in a
    if numel(regexp(a(i).name,'\w')) > 0%if the folder name contains a word character
        if a(i).isdir == 1%if it is a directory
            folderName = a(i).name;%find the name of the directory
            [pathList, fileList] = folderSearch(folderName,format,fileList,pathList,path);%search this directory
        end
    end
end

end