function c = nchoosekRep(n,k,varargin)
%c = nchoosekRep(n,k,varargin)
%   Outputs all vectors whose elements are chosen from n (or 1:n) with
%   replacement.
%   == Input ==
%   n: The set which elements are chosen from, can be a vector or an
%   integer,
%   k: The length of the each output vector.
%   == Name-Value Pairs==
%   'n_type': select if n is a 'vector' or an 'integer', default is
%   'vector'.


p = inputParser;
checkstr = @(x)validatestring(x,{'integer','vector'},"nchoosekRep","n_type");
addRequired(p, 'n', @(x)validateattributes(x,{'numeric'},{'vector'},"nchoosekRep","n"))
addRequired(p, 'k', @(x)validateattributes(x,{'numeric'},{'integer','scalar','>',0},"nchoosekRep","k"))
addParameter(p,'n_type','vector', @(x)ischar(checkstr(x)))

parse(p,n,k,varargin{:})
n = p.Results.n;
k = p.Results.k;
n_type = p.Results.n_type;

if strcmp(checkstr(n_type),'integer')
    n = 1:n;    
end
ll = length(n);

if k == 1
   c = n;
   return
end

[c{1:k}]=ndgrid(n);
c = reshape(shiftdim(reshape(cell2mat(c),[ll,ll,k,repelem(ll,1,k-2)]),2),[k,ll^k])';

end

