foreman = yuv_import_y('../../foreman_qcif/foreman_qcif.yuv',[176,144],50);
foreman16x16 = cell([50 1]);

%subdivide frames into 16x16 blocks%
for i = 1:length(foreman)
    foreman16x16{i} = mat2cell(foreman{i},[16 16 16 16 16 16 16 16 16],[16 16 16 16 16 16 16 16 16 16 16]);
end

foreman8x8 = foreman16x16;
for i = 1:length(foreman16x16)
    for j = 1:9
        for k = 1:11
            foreman8x8{i,1}{j,k} = mat2cell(foreman16x16{i,1}{j,k},[8 8],[8 8]);
        end
    end
end

foreman8x8_dct = foreman8x8;
foreman8x8_dctquant3 = foreman8x8;
foreman8x8_dctquant4 = foreman8x8;
foreman8x8_dctquant5 = foreman8x8;
foreman8x8_dctquant6 = foreman8x8;
for i = 1:length(foreman16x16)
    for j = 1:9
        for k = 1:11
            for a = 1:2
                for b = 1:2
                    foreman8x8_dct{i}{j,k}{a,b} = dct2(foreman8x8{i}{j,k}{a,b});
                    foreman8x8_dctquant3{i}{j,k}{a,b} = quantizer(foreman8x8{i}{j,k}{a,b},3);
                    foreman8x8_dctquant4{i}{j,k}{a,b} = quantizer(foreman8x8{i}{j,k}{a,b},4);
                    foreman8x8_dctquant5{i}{j,k}{a,b} = quantizer(foreman8x8{i}{j,k}{a,b},5);
                    foreman8x8_dctquant6{i}{j,k}{a,b} = quantizer(foreman8x8{i}{j,k}{a,b},6);
                end
            end
        end
    end
end

            







