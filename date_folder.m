function [ path_left,path_right ] = date_folder( path )
%date_folder Summary of this function goes here
%   Detailed explanation goes here
x = date;
files = dir(path);
dirFlags = [files.isdir];
% Extract only those that are directories.
subFolders = files(dirFlags);
% Print folder names to command window.
flag1=0;
for k = 1 : length(subFolders)
    if(strcmp(x,subFolders(k).name)==1)
       
       path = strcat(path,'\',subFolders(k).name);
       disp(path);
       flag1 =1;
        break;
    end
        

end
if(flag1==0)
    path = strcat(path,'\',x);
mkdir(path);
end
files =dir(path);
% Get a logical vector that tells which is a directory.
dirFlags = [files.isdir];
% Extract only those that are directories.
subFolders = files(dirFlags);
% Print folder names to command window.
len = length(subFolders)-2;
len = len+1;
path = strcat(path,'\',num2str(len));
mkdir(path);
path_left = strcat(path,'\','Left');
path_right = strcat(path,'\','Right');
mkdir(path_left);
mkdir(path_right);


end

