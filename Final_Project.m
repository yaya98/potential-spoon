% Creating the convexhull
function [asort] = CreateConvexHull(markers) %comment this line when testing

%pixels = imread('UF_MarkersAlpha.png');
%markers = [370 318; 126 534; 581 713; 429 865; 600 1145]; 
%uncomment the previous two lines when testing

%Find the point with the highest row value
max_row_value = max(markers(:,1));

%Finding the row value that correspond to the max_row_value
mr = find(markers(:,1) == max_row_value);

%Finding the angles for all the lines
[row, col] = size(markers);
for jj = 1:1:row
    if jj == mr
        matrix(jj) = 0;
    else
        m = [0,1,0];
        magm = norm(m);
        n = [markers(jj,1)-markers(mr,1), markers(jj,2)-markers(mr,2), 0];
        magn = norm(n);
        dprod = dot(m,n);
        theta = acosd(dprod/(magm*magn));
        matrix(jj,:) = theta;
    end
end

%Angles sorted in ascending order
asort = sortrows(cat(2,markers,matrix),3);

%making vectors and finding new angles
[r,~] = size(asort);
ii = 2;
while ii <= size(asort,1) -1
    x1 = asort(ii-1, 2);
    x2 = asort(ii, 2);
    x3 = asort(ii+1, 2);
    y1 = asort(ii-1, 1);
    y2 = asort(ii, 1);
    y3 = asort(ii+1, 1);
    %cross product math
    a = [x3-x2, y3-y2, 0];
    b = [x2-x1, y2-y1, 0];
    crosspro = cross(a,b);
    if crosspro(3) <= 0
        asort(ii,:) = [];
        ii = ii-1;
    else
        ii=ii+1;
    end
end
end %comment this line when testing

%-------------------------------------------------------------------------------------------------%

% Finding the path between any two points
function [path] = FindPath(start,finish,binary) %comment this line when testing

[height, width] = size(binary);
explore = start;
counter = 1;
parentchain = 0;
btrack = zeros(size(binary));
btrack(start(1),start(2)) = 1;
path = finish;

%checking neighboring pixels and updating our data
while true
    if explore(counter,1) == finish(1) && explore(counter,2) == finish(2)
        break
    end
    direction = [-1,0 ; 0,-1; 1,0; 0,1];
    for ii = 1:1:4
        checked = explore(counter,:) + direction(ii,:);
        if checked(1) < height && checked(2) < width && checked(1) > 1 && checked(2) > 1
            if binary(checked(1),checked(2)) == 1
                if btrack(checked(1),checked(2)) == 0
                    btrack(checked(1),checked(2)) = 1;
                    explore = [explore; checked];
                    parentchain  = [parentchain; counter];
                end
            end
        end
    end
    counter = counter+1;
end
backtrack = cat(2,explore, parentchain);

%use your parent chain to make the shortest path
[r,c] = size(backtrack);
while true
    r = backtrack(r,3);
    path = [path; explore(r,:)];
    if path(end,1) == start(1) && path(end,2) == start(2)
        break
     end
end 
end %comment this line when testing

%-------------------------------------------------------------------------------------------------%

% Cropping the image 

function [crop] = CropConvexHull(convexhull,pixels) %comment this line when testing

%convexhull = [600 1145; 126 534; 370 318; 581 713];
%pixels = imread('UF_MarkersAlpha.png');
%uncomment the previous two lines when testing

f=[];
j=1;
for ii = 1:1:size(convexhull,1)
    y = convexhull(ii,1);
    x = convexhull(ii,2);
    next_ii = ii+1;
    if ii == size(convexhull,1)
        next_ii = 1;
    end
    dy = convexhull(next_ii,1)-convexhull(ii,1);
    dx = convexhull(next_ii,2)-convexhull(ii,2);
    mag = sqrt(dx*dx+dy*dy);
    dy = dy/mag;
    dx = dx/mag;
    for kk = 0:1:mag
        f(j,:)=[(round(y+dy*kk)),round(x+dx*kk);];
        j=j+1;
    end
end
a=1;
for k=2:1:size(f)
    if f(k,1)~=f(k-1,1)
        g(a,:)=[f(k,1),f(k,2)];
        a=a+1;
    end
end
f=sortrows(g,1);
lowcol=min(convexhull(:,2));
highcol=max(convexhull(:,2));
lowrow=min(convexhull(:,1));
highrow=max(convexhull(:,1));
f(1,:)=[];
f(size(f,1),:)=[];
j=uint8(zeros(highrow-lowrow-1,highcol-lowcol,3));
for m=1:2:size(f)
    for c=lowcol:1:highcol
        if f(m,2)>c && f(m+1,2)>c
            j(f(m,1)-lowrow,c-lowcol+1,:)=255;
        elseif  f(m,2)<c && f(m+1,2)<c
            j(f(m,1)-lowrow,c-lowcol+1,:)=255;
        else
            j(f(m,1)-lowrow,c-lowcol+1,:)=pixels(f(m,1),c,:);
        end
        
    end
end
crop=j;
end %comment this line when testing
%imshow(crop) %uncomment this line when testing

%-------------------------------------------------------------------------------------------------%
