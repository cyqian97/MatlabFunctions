function A = regularGraph(n,d)
%A = regularGraph(n,d)
%   Gives a randomly generated adjacent matrix of a d-regular graph with n
%   nodes.
if n<d+1
    error("n=%d is not larger than d=%d",n,d);
end
fail = true;
while fail
    A = zeros(n);
    edge = randsample(n-1,d)+1;
    A(1,edge)=1;
    A(edge,1)=1;
    for i=2:d
        c = sum(A(i,1:i-1));
        if n-i<d-c
            i=0;
            fail = true;
            break
        end
        edge=randsample(n-i,d-c)+i;
        A(i,edge)=1;
        A(edge,i)=1;
    end
    if i==d
        c = sum(A(i+1:n,1:i),2);
        full = find(c==d)+i;
        for i = d+1:n-1
            if ismember(i,full)
                c=c(2:length(c));
                continue
            end
            s = setdiff((1:n-i)+i,full);
            if d-c(1)>length(s)
                i=0;
                fail = true;
                break
            end
            if length(s)==1
                edge = s;
            else
                edge = randsample(s,d-c(1));
            end
            
            A(i,edge)=1;
            
            A(edge,i)=1;
            c = sum(A(i+1:n,1:i),2);
            full = find(c==d)+i;
        end
    end
    if i==n-1 && sum(A(n,:))==d
        fail = false;
    end
end
end
