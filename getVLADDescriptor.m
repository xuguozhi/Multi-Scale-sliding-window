function [ enc ] = getVLADDescriptor( img, kdtree, C  )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
% extract vlad-brisk features of input image 'img',created by Guozhi Xu
% Email: xuguozhi0124@gmail.com
[tempDescriptors] = extractBRISKDescriptors(img);
DataToBeEncoded=(tempDescriptors.Features)';
DataToBeEncoded=double(DataToBeEncoded);

nn_test = vl_kdtreequery(kdtree, C, DataToBeEncoded) ;

assignments = zeros(128,tempDescriptors.NumFeatures);
assignments(sub2ind(size(assignments), nn_test, 1:length(nn_test))) = 1;

enc = (vl_vlad(DataToBeEncoded,C,assignments))';

end

