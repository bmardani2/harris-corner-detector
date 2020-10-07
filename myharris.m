%Harris Corner Detection



image = imread('checkerboard.png'); % Read Image
figure ;imshow(image);            % Show Image fig 1

%image = rgb2gray(image)

im1=im2double(image);             % convert the image im to double precision

if(size(im1,3) > 1)  % project to gray scale for RGB image
  im1 = rgb2gray( im1 ) ;
end


dx = [-1 0 1; -1 0 1; -1 0 1]; % This filter detect vertical lines
dy = dx';                      % This fiter detect horzental lines		
%[dx,dy] = imgradient(im1);

% Calculate image gradient

Ix = imfilter(im1, dx);        % Compute Ix (imply dx to image)
Iy = imfilter(im1, dy);        %Compute Iy  (imply dy to image)


window = fspecial('gaussian',10,1); % window function (gaussian filter of size 10*10 and standard deviation sima=1)

Ix2 = conv2(Ix .* Ix, window, 'same');      % Compute Ix^2

Iy2 = conv2(Iy .* Iy, window, 'same');      % Compute Iy^2

IxIy = conv2(Ix .* Iy, window, 'same');    % Compute Ix*Iy


%%%%%% In this section I compute R matrix 

[row col]=size(Ix2);
R = zeros(row, col);
k = [0.04 0.05 0.06]; % Empirical constant
threshold = 1e-7;
% here compute the sums of products of derivative at each pixel
for k = [0.04 0.05 0.06]
    for i=2:1:row-1
        for j=2:1:col-1
            Ix21=sum(sum(Ix2(i-1:i+1,j-1:j+1)));
            Iy21=sum(sum(Iy2(i-1:i+1,j-1:j+1)));
            IxIy1= sum(sum(IxIy(i-1:i+1,j-1:j+1)));
            M=[Ix21 IxIy1;IxIy1 Iy21];            % Struct M matrix
            R(i,j)=det(M)-k*trace(M).^2;          %Struct R matrix by determinant and trace of M
        end
    end

    figure, imshow(mat2gray(R)); %Let see what happned;  

    [sortR,R_index] = sort(R(:),'descend');
    

    R1= ordfilt2(R,100,ones(10,10));% Get the coordinates with maximum cornerness responses
    R2=(R1==R) & (R > threshold);
    [sortR2,R2_index] = sort(R2(:),'descend');
    [x, y] = ind2sub([row col],R2_index); %The mapping from linear indexes to subscript equivalents for the matrix
    points = [x y];
    figure; imshow(im1, []); hold on; xlabel('Max 50 points'); %labeling along with X axis    
     
    plot(points(1:50,1), points(1:50,2), 'r+'); 
    
end
