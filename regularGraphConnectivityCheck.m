function con = regularGraphConnectivityCheck(A)
%con = regularGraphConnectivityCheck(A)
%   Checks if the graph with adjacent matrix A is fully connected or not.
d = sum(A(1,:));
s = sum(A(1:d-1,:));
con = true;
for i = d:size(A,2)-1
    s = s+A(i,:);
    c = find(s==d);
    if ~isempty(c) && all(sum(A(c,c),2)==d)
       con = false;
       break
    end
end

