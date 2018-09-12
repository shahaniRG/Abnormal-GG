% Specify the folder where the files live.
file_name = input('File name: ','s');
myFolder = strcat('/Users/Issac/Documents/GitHub/1_Data/Exp 2/ACT data/',file_name);
% Check to make sure that folder actually exists.  Warn user if it doesn't.
if ~isdir(myFolder)
  errorMessage = sprintf('Error: The following folder does not exist:\n%s', myFolder);
  uiwait(warndlg(errorMessage));
  return;
end
% Get a list of all files in the folder with the desired file name pattern.
filePattern = fullfile(myFolder, '*.tiff');
theFiles = dir(filePattern);
test = imread(strcat(myFolder,'/0001.tiff'));
imageArray = zeros(size(test,1),size(test,2),length(theFiles));
for k = 1 : length(theFiles)
  baseFileName = theFiles(k).name;
  fullFileName = fullfile(myFolder, baseFileName);
  imageArray(:,:,k) = imread(fullFileName);
end
clear file_name myFolder filePattern theFiles test fullFileName baseFileName