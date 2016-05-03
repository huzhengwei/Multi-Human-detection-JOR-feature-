str = 'test.png';
img = imread(str);
[m, n, d] = size(img);
rect = [32, 24];
for scale = 1:0.5:16
    tmp = rect * scale;
    for i = 1:10: (m - tmp(1) + 1)
        for j = 1:10: (n - tmp(2) + 1)
            tmp_img = imresize( rgb2gray( ( img( i: (i+tmp(1)-1), j: (j+tmp(2)-1), :)) ), rect);
            test_granule_value = granule(tmp_img, grl_space);
            test_fv = [];
            for k = 1:length(fv)
                testR = response(fv{k},  test_granule_value);
                test_fv = [test_fv;testR];
            end
            ResultR = Classify(RLearners, RWeights, test_fv);
            if ResultR >0
                imshow(rgb2gray( ( img( i: (i+tmp(1)-1), j: (j+tmp(2)-1), :)) ));
            end
        end
    end
end