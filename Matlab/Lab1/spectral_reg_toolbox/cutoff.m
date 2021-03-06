function [alpha]=cutoff(K, t_range, y)
%CUTOFF Calculates the coefficient vector using cutoff method.
%   [ALPHA] = CUTOFF(K, T_RANGE, Y) calculates the spectral cut-off 
%   solution of the problem 'K*ALPHA = Y' given a kernel matrix 'K[n,n]' a 
%   range of regularization parameters 'T_RANGE' and a label/output 
%   vector 'Y'.
%
%   The function works even if 'T_RANGE' is a single value
%
%   Example:
%       K = kernel('lin', [], X, X);
%       alpha = cutoff(K, logspace(-3, 3, 7), y);
%       alpha = cutoff(K, 0.1, y);
%
% See also RLS, NU, TSVD, LAND

n = length(y);
alpha = cell(size(t_range));

[U,S,V] = svd(K);
ds = diag(S);
for i=1:length(t_range)
    t = t_range(i);
    
    mask = ( ds > t*n );
    index = sum(mask) + 1;
    
    inv_ds = [ 1   ./ ds(1:(index-1))    ; 
               1/(t*n) *  ones(n-index+1, 1)];
    TinvS = diag(inv_ds);
    TK = V * TinvS * U';
    
    alpha{i} = TK * y;
end
