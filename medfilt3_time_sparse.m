function [x] = medfilt3_time_sparse(x,w,sparsity)


orig_t_size = size(x,3);
x = x(:,:,1:sparsity:end);


w = (round(w / sparsity)) - mod(round(w / sparsity),2) + 1;


x = medfilt3(x,[1,1,w]);


inds = kron(1:size(x,3),[1,1,1]);
inds = inds(1:orig_t_size);

x = x(:,:,inds);


end