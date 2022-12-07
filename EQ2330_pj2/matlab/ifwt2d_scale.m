function output = ifwt2d_scale(LLs, LHs, HLs, HHs, scale)
    % Daubechies 8-tap filter is used
    [ ~, ~, LPF, ~] = wfilters("db8");
    output = LLs{scale};
    % achieve scaling by recusively apply the filter
    for i = scale:-1:1
        output = ifwt2d(output, LHs{i}, HLs{i}, HHs{i}, LPF);
    end

end

