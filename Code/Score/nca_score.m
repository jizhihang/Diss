function [score] = nca_score(X_train, c_train, X_test, c_test, A)

  if exist('A','var'),
    X_train = A*X_train;
    X_test  = A*X_test;
  end
  
  N_test = size(X_test, 2);
  c_predictions = zeros(1,N_test);
  
  for i = 1:N_test,
    % Compute contribution from each point in the training set:
    X_diff = bsxfun(@minus, X_train, X_test(:,i));
    K = exp( - sum( X_diff.*X_diff, 1 ) );

    % Add the contributions within each class:
    class_score = accumarray(c_train', K', [], @sum);
    [dummy, c_predictions(i)] = max(class_score);
  end
  
  score = 1 - nnz(c_predictions - c_test) / N_test;

end