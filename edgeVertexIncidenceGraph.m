function B = edgeVertexIncidenceGraph(A)
%B = EdgeVertexIncidenceGraph(A)
%   Gives the adjacent matrix between two sides of the
%   edge-vertex-incidence graph genereted by a regular graph A.
d = sum(A(1,:));
n = size(A,1);
B = zeros(d*n/2,n);
Atriu = triu(A);
n_edge = 0;
for i = 1:n-1
    s = sum(Atriu(i,:));
    edge_range = n_edge+1:n_edge+s;
    n_edge = n_edge+s;
    B(edge_range,i)=1;
    c = find(Atriu(i,:));
    for j = 1:s
        B(edge_range(j),c(j))=1;
    end
end

