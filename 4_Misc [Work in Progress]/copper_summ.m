file_name1 = input('File name: ','s');
T1 = tiff2mat(file_name1);
file_name2 = input('File name: ','s');
T1a = tiff2mat(file_name2);
clear file_name1 file_name2
T1a = imresize3(T1a, size(T1));
T1(T1 == 0) = NaN;
T1a(T1a == 0) = NaN;

%%
%T1_t = T1;
%T1_t(T1_t > 52000 | T1_t < 32000) = NaN;
T1_t = histeq(T1(:,:,2),100);
imshowpair(T1(:,:,2),T1_t,'montage')

%imshow3D(T1,[])
%figure(2)
%imshow3D(T1a,[])
%imshow3D(T1_t,[])
