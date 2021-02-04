clear all
close all
clc
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~>SETTINGS<~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
firstMatPath = 'D:\RSA\DATA\testData\1k\001_0009_1\001_0009.mat';
secondMatPath = 'D:\RSA\DATA\testData\1k\001_0009_2\001_0009.mat';
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

firstData = [];
load(firstMatPath);
firstData = [firstData; complex(rawRe,rawIm)];

secondtData = [];
load(secondMatPath);
secondtData = [secondtData; complex(rawRe,rawIm)];

disp(isequal(firstData, secondtData));