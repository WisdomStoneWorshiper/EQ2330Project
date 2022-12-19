function output = quantizer(input, step)
    output = step * round(input / step);
end
