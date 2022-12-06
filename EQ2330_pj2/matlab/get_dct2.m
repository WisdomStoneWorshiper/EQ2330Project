%dct2 function
function [y] = get_dct2(x,M)
A=dct2matrixA(M);
y = A*x*A'; %x is the signal block
plot_matrix(y);
end

