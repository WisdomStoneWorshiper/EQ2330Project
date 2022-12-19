function j = lagrangian_cost(distortion, bitrate, step_size)
    lamda = 0.0005 * (step_size ^ 2);
    j = distortion + lamda * bitrate;
end
