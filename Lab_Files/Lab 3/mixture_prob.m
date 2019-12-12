function prob = mixture_prob(image, K, L, mask)
%Let I be a set of pixels and V be a set of K Gaussian components in 3D (R,G,B).
    %  Store all pixels for which mask=1 in a Nx3 matrix
    mask = logical(mask(:));
    Ivec = double(reshape(image, size(image, 1) * size(image, 2), 3));
    pixels = Ivec(mask, :);

    %  Randomly initialize the K components using masked pixels
    muidx = randi([1, K], size(pixels, 1), 1);
    mu = zeros(K, 3);
    cov = cell(K, 1);
    w = zeros(K, 1);
    for i=1:K
        mu(i, :) = mean(pixels(muidx == i, :), 1);
        
        cov{i} = eye(3) * 100;
        
        w(i) = sum(muidx == i) / size(pixels, 1);
    end
    
    p = zeros(size(pixels, 1), K);
    %  Iterate L times
    for i=1:L
        %     Expectation: Compute probabilities P_ik using masked pixels
        for k=1:K
            p(:, k) = w(k) * mvnpdf(pixels, mu(k, :), cov{k});
        end
        p = p ./ sum(p, 2);
        %     Maximization: Update weights, means and covariances using masked pixels
        for k=1:K
            w(k) = sum(p(:, k)) / size(pixels, 1);
            mu(k, :) = sum(p(:,k) .* pixels, 1) ./ sum(p(:, k), 1);
            cov{k} = ((p(:, k) .* (pixels - mu(k, :)))' * ((pixels - mu(k, :))) ./ sum(p(:, k), 1)) + eye(3) * 1e-10;
        end
    end
    %  Compute probabilities p(c_i) in Eq.(3) for all pixels I.
    prob = zeros(size(Ivec, 1), 1);
    for k=1:K
        prob = prob + w(k) * mvnpdf(Ivec, mu(k,:), cov{k});
    end
    prob = reshape(prob, size(image, 1), size(image, 2));
end

