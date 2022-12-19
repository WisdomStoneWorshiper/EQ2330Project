function [avg_img_psnr, avg_img_bitrates, img_distortion, img_bitrates, img, img_idct] = intra_frame_coder(img_path)
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
    img_bitrates = zeros(4, block_size, block_size);

    % for each step size
    for i = 3:6
        concated_coffs = 0;

        % for each frame
        for j = 1:num_of_frames
            % divide into 16x16 blocks
            divided = mat2cell(img_quantized{i - 2, j}, repelem(16, frame_height / block_size), repelem(16, frame_width / block_size));

            for k = 1:frame_height / block_size

                for l = 1:frame_width / block_size
                    dct_sec = img_quantized{i - 2, j}((k - 1) * block_size + 1:k * block_size, (l - 1) * block_size + 1:l * block_size);
                    img_re = blockproc(dct_sec, [8 8], @(block_struct) idct2(block_struct.data));
                    img_distortion(i - 2, j, k, l) = mse(img_re, img{j}((k - 1) * block_size + 1:k * block_size, (l - 1) * block_size + 1:l * block_size));

                    if j == 1 && k==1 && l==1
                        concated_coffs = divided{k, l};
                    else
                        concated_coffs = cat(3,concated_coffs, divided{k, l});
                    end

                end

            end

        end
        % calculate the bit-rate
        for k=1:block_size
            for l =1:block_size
                img_bitrates(i-2,k,l)=bitrate(reshape(concated_coffs(k,l,:),1,[]));
            end
        end

    end

    avg_img_bitrates = mean(img_bitrates, 2);
    avg_img_bitrates = mean(avg_img_bitrates, 3);
end
