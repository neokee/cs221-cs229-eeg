dog = 'Dog_5';
[feature_matrix, num_interictal, num_preictal] = Get_DWT_Features(dog);
feature_matrix = permute(feature_matrix,[1 3 2]);
feature_matrix = reshape(feature_matrix,[size(feature_matrix,1) size(feature_matrix,2)*size(feature_matrix,3)]);
[coeff,score,latent] = pca(feature_matrix);
num_not_halved = 0;
cutoff = 3;
% for i = 1:size(latent,1)-1
%     if latent(i)/latent(i+1) < 2
%         num_not_halved = num_not_halved + 1;
%     else
%         num_not_halved = 0;
%     end
%     
%     if latent(i) / sum(latent) < 0.05 && num_not_halved > 1
%         cutoff = i+1;
%         break
%     end
% end

new_features = zeros(size(feature_matrix,1),cutoff);
for i = 1:size(feature_matrix,1)
    for j = 1:cutoff
        new_features(i,j) = dot(coeff(j,:),feature_matrix(i,:));
    end
end

new_features = feature_matrix;

new_features_train = [new_features(151:450,:)' new_features(461:480,:)']';
labels_train = [ones(1,300) zeros(1,20)]';
new_features_cross_val = [new_features(1:150,:)' new_features(451:460,:)']';
labels_cross_val = [ones(1,150) zeros(1,10)]';

labels = [ones(1,num_interictal) zeros(1,num_preictal)]';
% model = fitcsvm(new_features_train,labels_train,'KernelFunction','rbf',...
%                                     'BoxConstraint',Inf,'ClassNames',[-1,1]);

% label = predict(model,new_features_cross_val);

theta = glmfit(new_features_train,labels_train,'binomial');
num_correct = 0;
guessed_labels = zeros(size(new_features_cross_val,1),1);
for i = 1:size(new_features_cross_val,1)
    if dot(theta(2:end),new_features_cross_val(i,:))+theta(1) > 0
        label = 1;
        guessed_labels(i) = 1;
    else
        label = 0;
        guessed_labels(i) = 0;
    end
    if label == labels_cross_val(i)
        num_correct = num_correct+1;
    end
end

display(['Accuracy on training data = ' num2str(100*num_correct/size(new_features_cross_val,1))])
% model = train(labels, new_features);



        