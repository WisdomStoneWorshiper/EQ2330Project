function [avg_img_psnr, avg_img_bitrates, img_distortion, img_bitrates] = intra_frame_coder(img_path)
    frame_width = 176;
    frame_height = 144;
    block_size = 16;
    num_of_frames = 50;

    img = yuv_import_y(img_path, [frame_width, frame_height], num_of_frames);

    img_dct = cell(num_of_frames, 1);
    img_quantized = cell(4, num_of_frames);
    img_idct = cell(4, num_of_frames);
    img_psnr = zeros(4, num_of_frames);
    %dct to all frames

    for i = 1:num_of_frames
        img_dct{i, 1} = blockproc(img{i, 1}, [8 8], @(block_struct) dct2(block_struct.data));

        for j = 3:6
            img_quantized{j - 2, i} = quantizer(img_dct{i, 1}, 2 ^ j);
            img_idct{j - 2, i} = blockproc(img_quantized{j - 2, i}, [8 8], @(block_struct) idct2(block_struct.data));
            img_psnr(j - 2, i) = psnr_8bits(img{i, 1}, img_idct{j - 2, i});
        end

    end

    avg_img_psnr = mean(img_psnr, 2);

    img_distortion = zeros(4, num_of_frames, frame_height / block_size, frame_width / block_size);
    img_bitrates = zeros(4, frame_height / block_size, frame_width / block_size);

    for i = 3:6
        concated_coffs = cell(frame_height / block_size, frame_width / block_size);

        for j = 1:num_of_frames
            divided = mat2cell(img_quantized{i - 2, j}, repelem(16, frame_height / block_size), repelem(16, frame_width / block_size));

            for k = 1:frame_height / block_size

                for l = 1:frame_width / block_size
                    dct_sec = img_quantized{i - 2, k}((k - 1) * block_size + 1:k * block_size, (l - 1) * block_size + 1:l * block_size);
                    img_re = blockproc(dct_sec, [8 8], @(block_struct) idct2(block_struct.data));
                    img_distortion(i - 2, j, k, l) = mse(img_re, img{j}((k - 1) * block_size + 1:k * block_size, (l - 1) * block_size + 1:l * block_size));

                    if j == 1
                        concated_coffs{k, l} = divided{k, l}(:);
                    else
                        concated_coffs{k, l} = [concated_coffs{k, l}; divided{k, l}(:)];
                    end

                    if j == num_of_frames
                        img_bitrates(i - 2, k, l) = bitrate(concated_coffs{k, l});
                    end

                end

            end

        end

    end

    avg_img_bitrates = mean(img_bitrates, 2);
    avg_img_bitrates = mean(avg_img_bitrates, 3);
    avg_img_bitrates = avg_img_bitrates * 30 * frame_width * frame_height / 1000;
end
