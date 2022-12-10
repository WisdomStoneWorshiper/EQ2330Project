% q1
[avg_img_psnr, avg_img_bitrates, ~,~,~,~] = intra_frame_coder('../../foreman_qcif/foreman_qcif.yuv');

figure(1);

plot(avg_img_bitrates, avg_img_psnr, '-bo');

xlabel("Bit-rates");
ylabel("PSNR");
grid on;