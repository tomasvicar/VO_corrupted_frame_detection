function weighted_hists =  whist_all(data,W)


W = repmat(W,[1,1,size(data,3)]);

weighted_hists = zeros(size(data,3),255);


for bin = 0:255
    

    idx = bin + 1

    pixels_binary =  data == bin;

    weighted_hists(:,idx) = sum(W.*double(pixels_binary),[1,2]);

end




