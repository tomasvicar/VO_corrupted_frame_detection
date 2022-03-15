function [x] = my_medfilt1(x,w)


x = padarray(x,[floor(w/2) 0],'symmetric','both');
x = medfilt1(x,w);
x=x(floor(w/2)+1,end-floor(w/2));



end