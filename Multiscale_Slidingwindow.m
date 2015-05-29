clear all;

%Multi-Scale Sliding Windows
load centers.mat;
load kdtree.mat;
load SVM_model.mat;
load validvectors.mat;
load model_knn.mat;
load model_ctree.mat;
load brisk_valid_label.mat;

im = strcat ('¼Ü¹¹ÒýÏßIR_3771.jpg');

      im = imread (im);

      win_size= [128, 128]; 

      [lastRightCol lastRightRow d] = size(im);

      counter = 1;
      
      
for s=1:0.2:3
          disp(strcat('s is:    ',num2str(s)));
          X=win_size(1)*s;
          Y=win_size(2)*s;
          for y = 1:X/4:lastRightCol-Y
              for x = 1:Y/4:lastRightRow-X
                  p1 = [x,y];
                  p2 = [x+(X-1), y+(Y-1)];
                  po = [p1; p2] ;

                  % Croped image and scan it.
                  crop_px = [po(1,1) po(2,1)];
                  crop_py  = [po(1,2) po(2,2)];

                  topLeftRow = ceil(min(crop_px));
                  topLeftCol = ceil(min(crop_py));

                  bottomRightRow = ceil(max(crop_px));
                  bottomRightCol = ceil(max(crop_py));

                  cropedImage = im(topLeftCol:bottomRightCol,topLeftRow:bottomRightRow,:);
                  % Get the feature vector from croped image using HOG descriptor
%                   featureVector{counter} = getHOGDescriptor(img);
                  featureVector{counter} = getVLADDescriptor(cropedImage,kdtree, C);
                  boxPoint{counter} = [x,y,X,Y];
                  counter = counter+1;
                  x = x+2;
               end
            end
end
     label = ones(length(featureVector),1);
         P = cell2mat(featureVector');
[predicted_label,acur_SVM] = svmpredict(label,P, model_svm);
[r,c,v]= find(predicted_label);



figure(),imshow(im);
hold on
for ix=1:length(r)
             rects{ix}= boxPoint{r(ix)};
             rectangle('Position',[rects{ix}(1),rects{ix}(2),128,128], 'LineWidth',2,'EdgeColor','y');
end
hold off
 A=cell2mat(rects');
[selectedBbox, selectedScore] = selectStrongestBbox(A, v,'OverlapThreshold',0.5,'RatioType','Min');
I2 = insertObjectAnnotation(im, 'rectangle', selectedBbox, cellstr(num2str(selectedScore)), 'Color', 'r');
figure(),imshow(I2);

