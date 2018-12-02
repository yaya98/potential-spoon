clc; clear; close all;
pixels = imread(input('Enter file name: ','s'));
markers = input('Enter the markers coordinates in []: ');
imshow(pixels);

%Find the point with the highest row value
max_row = max(markers(:,1));

%Finding the column value that correspond to the max_row point, point
index_P = find(markers == max_row);
col_P = markers(index_P,2);

%Drawing a horizontal line from the point with the highest row value
y = max_row;
x1 = col_P;
x2 = col_P + 200;
l = line([x1,x2],[y,y]);
set(l,'LineWidth',1.2,'Color',[1 0 0])

%Drawing a line from point P to every other point
for mm = 1:1:length(markers)
    L = line([x1,markers(mm,2)],[y,markers(mm,1)]);
    set(L,'LineWidth',1.2)
end

%Different line colors for the all the lines
for kk = 1:1:length(markers)
    
    L = line([x1,markers(kk,2)],[y,markers(kk,1)]);
    set(L,'LineWidth',1.2,'Color',rand(1,3))
    
end

%Finding the angles for all the lines
for jj = 1:1:length(markers)
    
    if jj == index_P
        matrix(jj) = 0;
    else
        v1 = [x2,y] - [col_P,max_row];
        v2 = [col_P,max_row] - [markers(jj,2),markers(jj,1)];
        CosTheta = dot(v1,v2)/(norm(v1)*norm(v2));
        ThetaInDegrees = 180 - acosd(CosTheta);
        matrix(jj,:) = ThetaInDegrees;
    end
    
end

%Angles sorted in ascending order
asort = sortrows(cat(2,markers,matrix),3);

%Finding the angles for all the lines
for jj = 1:1:length(markers)
    
    if jj == index_P
        matrix(jj) = 0;
    else
        v1 = [x2,y] - [col_P,max_row];
        v2 = [col_P,max_row] - [markers(jj,2),markers(jj,1)];
        CosTheta = dot(v1,v2)/(norm(v1)*norm(v2));
        ThetaInDegrees = 180 - acosd(CosTheta);
        matrix(jj,:) = ThetaInDegrees;
    end
end

%Angles sorted in ascending order
asort = sortrows(cat(2,markers,matrix),3);

%making vectors and finding new angles
[r,c] = size(asort);
for ii = 1:1:r-3
    x1 = asort(r, 1);
    x2 = asort(ii+1, 1);
    x3 = asort(ii+2, 1);
    y1 = asort(ii, 2);
    y2 = asort(ii+1, 2);
    y3 = asort(ii+2, 2);
    
    %Finding new angles
    v1 = [x2,y2] - [x1,y1];
    v2 = [x3,y3] - [x2,y2];
    CosTheta = dot(v1,v2)/(norm(v1)*norm(v2));
    ThetaInDegrees = 180 - acosd(CosTheta);
    
    %Cross Product
    cross = norm(v1)*norm(v2)*sin(ThetaInDegrees);
    fprintf('Cross value is: %g \n',cross)
    
end


