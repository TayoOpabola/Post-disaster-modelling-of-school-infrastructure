function [R,pdf] = randp(in,N,mFirst,lambda)
%RANDP PERT distributed pseudorandom numbers.
%   R = RANDP([a m b],N) returns an N-by-N matrix containing pseudorandom values
%   drawn from the PERT distribution on the open interval(a,b) with mode
%   m. RANDP([a m b],[M,N]) returns an M-by-N matrix. RANDP([a m b],[M,N,P,...])
%   returns an M-by-N-by-P-by-... array. RANDP([a m b]) returns a scalar. 
% 
%   RANDP([a b],...) uses the midpoint between a and b for m.
%
%   RANDP([a NaN b],...) returns pseudorandom numbers on a uniform distribution
%   between a and b.
% 
%   R = RANDP(m,...), or if a = b, returns scalar R = m.
% 
%   R = RANDP(...,N,mFirst), where mFirst = TRUE, sets R(1) = m.
% 
%   R = RANDP(...,N,mFirst,lambda) reshapes the distribution based on
%   non-negative shape parameter lambda. Default lambda = 4. Higher lambda
%   yields a more "peaky" distribution, lower lambda yields a more uniform
%   distribution (with lambda = 0 being fully uniform). 
% 
%   [R,pdf] = RANDP(...) also returns the probability density function as a
%   function handle.

if nargin < 4
    lambda = 4;
end
validateattributes(lambda,{'numeric'},{'scalar','nonnegative','finite'},...
    'randp','shape parameter, lambda,');

if nargin < 3
    mFirst = 0;
end
if nargin < 2
    N = 1;
end

validateattributes(in,{'numeric','DimVar'},{'vector'},'','[a m b] vector')

a = in(1);
b = in(end);

switch numel(in)
    case 3
        m = in(2);
    case {1,2}
        m = (a + b)/2;
    otherwise
        error('Input vector must have 1, 2 ([a b]), or 3 ([a m b]) elements.')
end

if (m>b && m>a) || (m<b && m<a)
    error('Ensure m lies between a and b.')
end

if a == b
    R = m;
    if nargout > 1
        pdf = @(x) (x==a)*1e1000;
    end
    return
end

u = rand(N);

span = b - a;
if isnan(m)
    R = a + u.*span;
    if mFirst
        R(1) = (a + b)/2;
    end
    return
else
    mn = (m - a)./span;
    
    mu = (lambda.*mn + 1) ./ (lambda + 2);
    
    alph = mu.*(2*mn - 1) ./ (mn - mu);
    
    ind = abs(1 - mn./mu) <= eps; % i.e. m==mu, practically.
    alph(ind) = lambda./2 + 1;
    
    bet = alph.*(1 - mu) ./ mu;
  
    R = a + span.*betaincinv(u,alph,bet);
end

if mFirst
    R(1) = m;
end

if nargout > 1
    % Return pdf as function handle.
    pdf = @(x) ( (x-a).^(alph-1)  .*  (b-x).^(bet-1) )   ./...
               (  span.^(alph+bet-1)  .*  beta(alph,bet) );
end

