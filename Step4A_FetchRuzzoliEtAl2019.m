%
% Script for downloading and unpacking Ruzzoli et al. (2019) data.
%

clear;

dataURL  = 'https://osf.io/bdgr4/download';
dataFile = 'Behavior_FinalDataset.zip';
dataRoot = 'data-step4';

if exist(dataRoot, 'dir')
	rmdir(dataRoot, 's');
end
mkdir(dataRoot);

websave(fullfile(dataRoot, dataFile), dataURL);
unzip(fullfile(dataRoot, dataFile), dataRoot);
