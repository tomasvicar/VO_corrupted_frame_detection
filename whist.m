function [weighted_hist] = whist(img,w)


weighted_hist = zeros(1,255);


for bin = 0:255
    
    idx = bin + 1;

    pixels_binary =  img == bin;

    weighted_hist(idx) = sum(w(pixels_binary));

end




end