function set = dec2set(dec,K)
%dec2set convert the demical number to the set of the binary bits

temp =  dec2bin(dec,K);
temp = [temp(:)' ; 
    repmat(' ',1,length(dec)*K)];
temp = str2num(temp(:)');
set =  reshape(temp,length(dec),K);

end

