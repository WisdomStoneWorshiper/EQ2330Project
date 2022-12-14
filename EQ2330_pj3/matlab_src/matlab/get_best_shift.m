function best_shift = get_best_shift(video, block_size)
    shift_vectors = -10:1:10;
    num_of_frames = length(video);
    [frame_height, frame_width] = size(video{1});
    best_shift = zeros(num_of_frames - 1, frame_height / block_size, frame_width / block_size, 2);

    for i = 2:num_of_frames
    
        for j = 1:frame_height / block_size
    
            for k = 1:frame_width / block_size
                y_start = (j - 1) * block_size + 1;
                y_end = j * block_size;
                x_start = (k - 1) * block_size + 1;
                x_end = k * block_size;
                curr_block = video{i}(y_start:y_end, x_start:x_end);
                min_mse = realmax;
                min_vector = [0, 0];
    
                for dy = 1:length(shift_vectors)
                    shifted_y_start = y_start + shift_vectors(dy);
                    shifted_y_end = y_end + shift_vectors(dy);
    
                    if shifted_y_start < 1 || shifted_y_end > frame_height
                        continue
                    end
    
                    for dx = 1:length(shift_vectors)
                        shifted_x_start = x_start + shift_vectors(dx);
                        shifted_x_end = x_end + shift_vectors(dx);
    
                        if shifted_x_start < 1 || shifted_x_end > frame_width
                            continue
                        end
    
                        shifted_block = video{i - 1}(shifted_y_start:shifted_y_end, shifted_x_start:shifted_x_end);
                        this_mse = mse(curr_block, shifted_block);
    
                        if min_mse > this_mse
                            min_vector = [shift_vectors(dy), shift_vectors(dx)];
                            min_mse = this_mse;
                        end
    
                    end
    
                end
                best_shift(i - 1, j, k, :) = min_vector;
            end
    
        end
    
    end

end

