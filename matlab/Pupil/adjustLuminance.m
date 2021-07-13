clear all;close all;
images_L = cell(60,1);
images_a = cell(60,1);
images_b= cell(60,1);
name = [];
i = 0;
in = 'henkou/';
out = 'Stim/';

listing = dir(in);
for J = 3:size(listing)
    name = [name,listing(J).name];
    [tmp1,tmp2] = imread([in, listing(J).name]);
    i= i+1;
    tmp1 = rgb2lab(tmp1);
    images_L{i,1} = tmp1(:,:,1);
    images_a{i,1} = tmp1(:,:,2);
    images_b{i,1} = tmp1(:,:,3);
end

newimages1 = SHINE(images_L);
sprintf('hist');


% newimages1 = SHINE(newimages1);

i=0;

for J = 3:size(listing)
    i= i+1;
    tmp1(:,:,1) = newimages1{i,1};
    tmp1(:,:,2) = images_a{i,1};
    tmp1(:,:,3) = images_b{i,1};
    tmp1 = lab2rgb(tmp1);
    imwrite(tmp1,[out, listing(J).name]);
end