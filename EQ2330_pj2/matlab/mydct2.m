%dct function
function [y] = Mydct2(x,M)
A=dct2matrixA(M);
y = A*x*A'; %x is the signal block
plot_matrix(y);
end

