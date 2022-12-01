function [A] = dct2matrixA(M)
A = zeros(M);
for i=0:M-1
    for j=0:M-1
        if i==0
            alpha = sqrt(1/M);
        else
            alpha = sqrt(2/M);
        end
        A(i+1,j+1) = alpha*cos((2*j+1)*i*pi/(2*M));
    end
end

