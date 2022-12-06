%inverse dct2 function
function [x] = get_indct2(y,M)
A = dct2matrixA(M);
x = A'*y*A;
plot_matrix(x);
end