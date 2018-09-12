file_name1 = input('File name: ','s');
T1 = tiff2mat(file_name1);
file_name2 = input('File name: ','s');
T1a = tiff2mat(file_name2);
clear file_name1 file_name2

T1a = imresize3(T1a, size(T1));

%%
T1a_t = T1a(:,:,1);
T1_t = T1(:,:,1);
T1a_t(T1a_t < 39000) = 0;
%T1_t(T1_t < 30000) = 0;
imshow(T1a_t,[])
%figure(2)
%imshow(T1_t,[])