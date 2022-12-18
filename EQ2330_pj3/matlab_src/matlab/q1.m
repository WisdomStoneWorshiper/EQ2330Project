clc;
clear;

frame_width = 176;
frame_height = 144;
block_size = 16;
num_of_frames = 50;

foreman = yuv_import_y('../../foreman_qcif/foreman_qcif.yuv', [frame_width, frame_height], num_of_frames);

foreman_dct = cell(num_of_frames ,1);
foreman_quantized = cell(4, num_of_frames);
foreman_idct = cell(4, num_of_frames);
foreman_psnr = zeros(4, num_of_frames);
%dct to all frames

for i = 1:num_of_frames
    foreman_dct{i,1} = blockproc(foreman{i,1}, [8 8], @(block_struct) dct2(block_struct.data));
    for j = 3:6
        foreman_quantized{j-2,i} = quantizer(foreman_dct{i,1},2^j);
        foreman_idct{j-2,i} = blockproc(foreman_quantized{j-2,i}, [8 8], @(block_struct) idct2(block_struct.data));
        foreman_psnr(j-2,i) = psnr_8bits(foreman{i,1}, foreman_idct{j-2,i});
    end
end

avg_foreman_psnr = mean(foreman_psnr,2);

foreman_distortion = zeros(4, num_of_frames,frame_height/block_size,frame_width/block_size);
foreman_bitrates = zeros(4,block_size,block_size);

for i = 3:6
    concated_coffs = 0;
    for j = 1:num_of_frames
        divided = mat2cell(foreman_quantized{i-2,j},repelem(16,frame_height/block_size),repelem(16,frame_width/block_size)); 
        for k = 1:frame_height/block_size
            for l= 1:frame_width/block_size
                dct_sec = foreman_quantized{i-2,k}((k-1)*block_size+1:k*block_size, (l-1)*block_size+1:l*block_size);
                img_re = blockproc(dct_sec, [8 8], @(block_struct) idct2(block_struct.data));
                foreman_distortion(i-2,j,k,l)=mse(img_re, foreman{j}((k-1)*block_size+1:k*block_size, (l-1)*block_size+1:l*block_size));
                if j ==1 && k==1 && l==1
                    concated_coffs=divided{k,l};
                else
                    concated_coffs = cat(3,concated_coffs,divided{k,l});
                end
%                 if j == num_of_frames
%                     foreman_bitrates(i-2,k,l)=bitrate(concated_coffs{k,l});
%                 end
            end
        end 
        
    end
    for k=1:block_size
        for l =1:block_size
%             temp = concated_coffs(k,l,:);
            foreman_bitrates(i-2,k,l)=bitrate(reshape(concated_coffs(k,l,:),1,[]));
        end
    end
end

avg_foreman_bitrates = mean(foreman_bitrates,2);
avg_foreman_bitrates = mean(avg_foreman_bitrates,3);
avg_foreman_bitrates = avg_foreman_bitrates*30*frame_width*frame_height/1000;


% foreman16x16 = cell([50 1]);
% 
% %subdivide frames into 16x16 blocks%
% for i = 1:length(foreman)
%     foreman16x16{i} = mat2cell(foreman{i}, [16 16 16 16 16 16 16 16 16], [16 16 16 16 16 16 16 16 16 16 16]);
% end
% 
% foreman8x8 = foreman16x16;
% 
% for i = 1:length(foreman16x16)
% 
%     for i = 1:9
% 
%         for k = 1:11
%             foreman8x8{i, 1}{i, k} = mat2cell(foreman16x16{i, 1}{i, k}, [8 8], [8 8]);
%         end
% 
%     end
% 
% end
% 
% foreman8x8_dct = foreman8x8;
% foreman8x8_dctquant3 = foreman8x8;
% foreman8x8_dctquant4 = foreman8x8;
% foreman8x8_dctquant5 = foreman8x8;
% foreman8x8_dctquant6 = foreman8x8;
% 
% for i = 1:length(foreman16x16)
% 
%     for i = 1:9
% 
%         for k = 1:11
% 
%             for a = 1:2
% 
%                 for b = 1:2
%                     foreman8x8_dct{i}{i, k}{a, b} = dct2(foreman8x8{i}{i, k}{a, b});
%                     foreman8x8_dctquant3{i}{i, k}{a, b} = quantizer(foreman8x8{i}{i, k}{a, b}, 2 ^ 3);
%                     foreman8x8_dctquant4{i}{i, k}{a, b} = quantizer(foreman8x8{i}{i, k}{a, b}, 2 ^ 4);
%                     foreman8x8_dctquant5{i}{i, k}{a, b} = quantizer(foreman8x8{i}{i, k}{a, b}, 2 ^ 5);
%                     foreman8x8_dctquant6{i}{i, k}{a, b} = quantizer(foreman8x8{i}{i, k}{a, b}, 2 ^ 6);
%                 end
% 
%             end
% 
%         end
% 
%     end
% 
% end
