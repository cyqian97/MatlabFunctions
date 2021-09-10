function [path,c_pairs] = eulerianPathEVIG(A,varargin)
%path = EulerianPath(A)
%   Give the Eulerian path of a graph using its adjacent matrix A
%   == Input ==
%   A: The adjacent matrix.
%   start: The node to start with, specified by an integer.
p = inputParser;
addRequired(p, 'A', @(x)validateattributes(x,{'numeric'},{'2d','nonempty'},"EulerianPathEVIG","A"))
addOptional(p,'start',1,@(x)validateattributes(x,{'numeric'},{'integer','<=',min(size(A))},"EulerianPathEVIG","start"))
addParameter(p,'log',false,@(x)validateattributes(x,{'logical'},{'scalar'},"EulerianPathEVIG","log"))

parse(p,A,varargin{:})
A = p.Results.A;
start = p.Results.start;
log = p.Results.log;

s1 = sum(A);
s2 = sum(A,2);
if ~all(s1-s1(1)==0)
    error("The degrees within the first party is not equal");
elseif  ~all(s2-s2(1)==0)
    error("The degrees within the second party is not equal");
elseif any(mod(s1,2)) || any(mod(s2,2))
    error("Some vertices have odd degrees, they should be all evem");
end


if all(s1==2) && all(s2>2)
    A=A';
end
s2 = sum(A);
d = s2(1);
n = size(A,2);

c_pairs = zeros(5,n);
path = zeros(2,d*n/2);
path(1,1) = start;

if log
logname = "eulerianPathEVIG_log.txt";
fid = fopen(logname,'w');
end

i = 1;
fa = 1;
loop = 1;
temp = [];
ll = d*n/2;

if log
writematrix(A,'A.txt','Delimiter','tab')
fprintf(fid,"A =\n"); filetext = fileread('A.txt');
fprintf(fid,filetext);
end 

% try
%     figure()
%     hold on
%
while i < ll+1
    % Find connected codebit vertex
    v = find(A(:,path(1,i)));
    if log
    fprintf(fid,"i = %d\tll = %d\t",i,ll);  
    fprintf(fid,"v="+mat2str(v)+'\n');
    end
    if isempty(v)
        path(:,i:n*d/2)=0;
        path(:,i:i+size(temp,2)-1)=temp;
        i = i+size(temp,2);
        
        if log
        fprintf(fid,"v is empty, enter loop %d\n",loop);
        fprintf(fid,"move forward\n");
        fprintf(fid,"i = %d\n",i);
        writematrix(path,'path.txt','Delimiter','tab')
        fprintf(fid,"path =\n");
        filetext = fileread('path.txt');
        fprintf(fid,filetext);
        end
        
        c1 = find((~all(c_pairs>0)).*c_pairs(5,:));
        c1 = c1(1);
        fa = find(path(1,:)==c1);
        fa = fa(1);
        
        
        temp = path(:,fa:i-1);
        path(:,fa:n*d/2) = 0;
        path(1,fa) = c1;
        path(:,n*d/2-(i-1-fa):n*d/2) = temp;
        
        if log
        fprintf(fid,"move backward");
        fprintf(fid,"c1 = %d\tfa = %d\n",c1,fa);
        writematrix(path,'path.txt','Delimiter','tab')
        fprintf(fid,"path =\n"); 
        filetext = fileread('path.txt');
        fprintf(fid,filetext);
        end
        
        ll = n*d/2-(i-1-fa)-1;
        i = fa;
        loop = loop+1;
        v = find(A(:,path(1,i)));
        
        if log
        fprintf(fid,"i = %d\tl = %d\n",i,ll);
        fprintf(fid,"v="+mat2str(v)+'\n');
        end
    end
    
    if length(v)>1
        path(2,i) = randsample(v,1);
    else
        path(2,i) = v;
    end
    
    c_pairs(5,path(1,i)) = c_pairs(5,path(1,i)) + 1;
    c_pairs(c_pairs(5,path(1,i)),path(1,i)) = path(2,i);
    
    A(path(2,i),path(1,i)) = 0;    
    
    if log
    writematrix(c_pairs,'c_pairs.txt','Delimiter','tab')
    fprintf(fid,"c_pairs =\n"); 
    filetext = fileread('c_pairs.txt');
    fprintf(fid,filetext);
    
    writematrix(path,'path.txt','Delimiter','tab')
    fprintf(fid,"path =\n"); 
    filetext = fileread('path.txt');
    fprintf(fid,filetext);
    
    writematrix(A,'A.txt','Delimiter','tab')
    fprintf(fid,"A =\n"); filetext = fileread('A.txt');
    fprintf(fid,filetext);
    end
    %     plot([2,1],[path(1,i)-(n+1)/2,path(2,i)-(size(A,1)+1)/2],'b-')
    
    if i == ll
        break
    end
    
    % Find connected constraint vertex
    path(1,i+1) = find(A(path(2,i),:));
    
    c_pairs(5,path(1,i+1)) = c_pairs(5,path(1,i+1)) + 1;
    c_pairs(c_pairs(5,path(1,i+1)),path(1,i+1)) = path(2,i);
    
    A(path(2,i),path(1,i+1)) = 0;
    
    if log
    writematrix(path,'path.txt','Delimiter','tab')
    fprintf(fid,"path =\n"); 
    filetext = fileread('path.txt');
    fprintf(fid,filetext);
    
    writematrix(c_pairs,'c_pairs.txt','Delimiter','tab')
    fprintf(fid,"c_pairs =\n"); 
    filetext = fileread('c_pairs.txt');
    fprintf(fid,filetext);
    
    writematrix(A,'A.txt','Delimiter','tab')
    fprintf(fid,"A =\n"); 
    filetext = fileread('A.txt');
    fprintf(fid,filetext);
    end
    %     plot([2,1],[path(1,i+1)-(n+1)/2,path(2,i)-(size(A,1)+1)/2],'b-')
    
    i=i+1;
end

c_pairs(5,path(1,fa)) = c_pairs(5,path(1,fa))+1;
c_pairs(c_pairs(5,path(1,fa)),path(1,fa)) = path(2,ll);

if log
writematrix(c_pairs,'c_pairs.txt','Delimiter','tab')
fprintf(fid,"c_pairs =\n"); 
filetext = fileread('c_pairs.txt');
fprintf(fid,filetext);
end

if log
fclose(fid);
end

end


%     plot([2,1],[path(1,1)-(n+1)/2,path(2,d*n/2)-(size(A,1)+1)/2],'b-')
%     hold off
% catch ME
%     ME.message
%     ME.stack
% end

