function newImage = hueadjust(img, hAdjust, fullcolormatrix)
    if hAdjust <= 0 %'flips' the color wheel
        hAdjust = hAdjust + 360;
    end
    if size(img,3) == 1 % if grayscale image
        img(:,:,2) = img(:,:,1);
        img(:,:,3) = img(:,:,1);
    end
    r = img(:,:,1); 
    g = img(:,:,2);
    b = img(:,:,3);
    ro = r;
    r(ro ~= 255 & ro ~= 0) = fullcolormatrix(hAdjust,1);
    g(ro ~= 255 & ro ~= 0) = fullcolormatrix(hAdjust,2);
    b(ro ~= 255 & ro ~= 0) = fullcolormatrix(hAdjust,3);
    newImage(:,:,1) = r;
    newImage(:,:,2) = g;
    newImage(:,:,3) = b;
end