function [segmentation, centers, iterations] = kmeans_segm_convergence(image, K, L, seed, threshold)
    % Randomly initialize the K cluster centers
    rng(seed);
    Ivec = double(reshape(image, size(image, 1) * size(image, 2), 3));
    distances = zeros(size(Ivec, 1), K);
    % Randomly assign pixels to cluster centers
    clusteridx = randi([1 K], size(Ivec, 1), 1);
    % Initialize clusters
    centers = zeros(K, 3);
    for i=1:K
        tmp = Ivec(repmat(clusteridx, [1, 3]) == i);
        tmp = reshape(tmp, [size(tmp, 1)/3, 3]);
        centers(i, :) = mean(tmp, 1);
    end
    
    % Compute all distances between pixels and cluster centers
    for i=1:K
        distances(:,i) = sqrt(sum((Ivec - repmat(centers(i, :), [size(Ivec, 1), 1])).^2, 2));
    end
    % save the previous centers for convergence test
    prev_clusters = Inf(K, 3);
    % Iterate L times
    for i=1:L
        % Assign each pixel to the cluster center for which the distance is minimum
        [~, clusteridx] = min(distances, [], 2);
        % Recompute each cluster center by taking the mean of all pixels assigned to it
        for j=1:K
            tmp = Ivec(repmat(clusteridx, [1, 3]) == j);
            tmp = reshape(tmp, [size(tmp, 1)/3, 3]);
            centers(j, :) = mean(tmp, 1);
        end
        % Recompute all distances between pixels and cluster centers
        for j=1:K
            distances(:,j) = sqrt(sum((Ivec - repmat(centers(j, :), [size(Ivec, 1), 1])).^2, 2));
        end
        
        %if sum(sum(sqrt((prev_clusters - centers).^2))) / (K*3) < threshold
        if max(sqrt((prev_clusters(:) - centers(:)).^2)) < threshold
            fprintf(sprintf('\nConvergence reached after %d iterations with threshold = %d\n', i, threshold))
            iterations = i;
            break
        end
        prev_clusters = centers;
        if i == L
            iterations = L;
        end
    end
    segmentation = reshape(clusteridx, size(image, 1), size(image, 2));
end

