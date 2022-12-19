function [avg_video_psnr,avg_video_bitrate] = conditional_replenishment(video_path)
frame_width = 176;
frame_height = 144;
block_size = 16;
num_of_frames = 50;

[~, avg_intra_bitrates, ~, ~, org_video, video_intra_idct] = intra_frame_coder(video_path);

video_bitrates = zeros(4, num_of_frames, frame_height / block_size, frame_width / block_size);
% video_bitrates_debug = cell(4, num_of_frames);

video_re = cell(4, num_of_frames);
frame_psnr = zeros(4, num_of_frames);

for i = 3:6

    for j = 1:num_of_frames

        for k = 1:frame_height / block_size

            for l = 1:frame_width / block_size
                y_start = (k - 1) * block_size + 1;
                y_end = k * block_size;
                x_start = (l - 1) * block_size + 1;
                x_end = l * block_size;
                if j == 1
                    video_bitrates(i - 2, j, k, l) = avg_intra_bitrates(i-2)*block_size^2+1;
%                     video_bitrates_debug{i - 2, j}(k, l) = intra_bitrates(i - 2, k, l) + 1; % add 1 start bit for indicating copy or intra mode
                    
                    video_re{i - 2, j}(y_start:y_end, x_start:x_end) = video_intra_idct{i - 2, j}(y_start:y_end, x_start:x_end);
                else
                    org_frame = org_video{j}(y_start:y_end, x_start:x_end);
                    r_intra = avg_intra_bitrates(i-2)*(block_size^2)+1;
                    intra_re = video_intra_idct{i - 2, j}(y_start:y_end, x_start:x_end);
                    intra_distortion = mse(org_frame, intra_re);
                    j_intra = lagrangian_cost(intra_distortion, r_intra, 2 ^ i);

                    
                    last_frame = video_re{i - 2, j - 1}(y_start:y_end, x_start:x_end);
                    copy_distortion = mse(org_frame, last_frame);
                    j_copy = lagrangian_cost(copy_distortion, 1, 2 ^ i); % only 1 start bit for indicating copy intra mode

                    if j_intra < j_copy
                        % if intra mode is selected
                        video_bitrates(i - 2, j, k, l) = avg_intra_bitrates(i-2)*block_size^2 + 1;
%                         video_bitrates_debug{i - 2, j}(k, l) = intra_bitrates(i - 2, k, l) + 1;
                        video_re{i - 2, j}(y_start:y_end, x_start:x_end) = video_intra_idct{i - 2, j}(y_start:y_end, x_start:x_end);
                    else
                        % if copy mode is selected
                        video_bitrates(i - 2, j, k, l) = 1;
%                         video_bitrates_debug{i - 2, j}(k, l) = 1;
                        video_re{i - 2, j}(y_start:y_end, x_start:x_end) = video_re{i - 2, j - 1}(y_start:y_end, x_start:x_end);
                    end

                end

            end

        end

        frame_psnr(i - 2, j) = psnr_8bits(org_video{j}, video_re{i - 2, j});
    end

end

avg_video_psnr = mean(frame_psnr, 2);

frame_bitrate = sum(video_bitrates,[3,4]);

avg_video_bitrate = mean(frame_bitrate, 2);

avg_video_bitrate = avg_video_bitrate* 30 / 1000;

end

