function [f, df] = nca_obj(A)
    
  global X c;

  f  = 0;
  df = 0;

  [D N] = size(X);
  A = reshape(A,[],D);
  C = repmat(c,[D 1]);
    
  for i=1:N,
    % Compute denominator---sum of the distances between the current 
    % point x_i and all the other points x_k, k~=i:
    AX = A*X;
    Axi = A*X(:,i);
    dist_all = exp( -sum( bsxfun(@minus,Axi,AX).^2, 1 ) );
    dist_all(i) = 0;
    sum_dist_all = sum(dist_all);

    % Compute numerator---sum of the distances between the current 
    % point x_i and its neighbours x_j:
    dist_neigh = dist_all(c==c(i));
    sum_dist_neigh = sum(dist_neigh);

    % Update function value:
    f = f - sum_dist_neigh / sum_dist_all;
  end
    
  if nargout > 1,
    for i = 1:N,
      % Compute denominator---sum of the distances between the current 
      % point x_i and all the other points x_k, k~=i:
      AX = A*X;
      Axi = A*X(:,i);
      dist_all = exp( -sum( bsxfun(@minus,Axi,AX).^2, 1 ) );
      dist_all(i) = 0;
      sum_dist_all = sum(dist_all);
      
      % Compute numerator---sum of the distances between the current 
      % point x_i and its neighbours x_j:
      dist_neigh = dist_all(c==c(i));
      sum_dist_neigh = sum(dist_neigh);

      p_i = sum_dist_neigh / sum_dist_all;
      x_ik = bsxfun(@minus,X(:,i),X); 
      x_ij = reshape(x_ik(C==c(i)),D,[]);
      
      % Update gradient value:
      df = df + p_i * bsxfun(@times,dist_all,x_ik) * x_ik' / sum_dist_all ...
                - bsxfun(@times,dist_neigh,x_ij) * x_ij' / sum_dist_all;
    end
    df = -2*A*df;
    df = df(:);
  end
    
end