function j = lagrangian_cost(distortion,bitrate, step_size)
    lamda = 0.002*(step_size^2);
    j=distortion+lamda*bitrate;
end

