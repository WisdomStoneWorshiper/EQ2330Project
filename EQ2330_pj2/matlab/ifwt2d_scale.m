function output = ifwt2d_scale(LLs, LHs, HLs, HHs, scale)
    [ ~, ~, LPF, ~] = wfilters("db8");
    output = LLs{scale};
    for i = scale:-1:1
        output = ifwt2d(output, LHs{i}, HLs{i}, HHs{i}, LPF);
    end

end

