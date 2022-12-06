%inverse dct function
function [x] = Myindct2(y,M)
A = dct2matrixA(M);
x = A'*y*A;
plot_matrix(x);
end