function cell2pylist(c, filename)
c = permute(c, ndims(c):-1:1);
% Get str representationelement
output = '';
for i = 1:numel(c)
    if isempty(c{i})
        el = 'None';
    elseif ischar(c{i}) || isstring(c{i})
        el = ['"', char(string(c{i})), '"'];
    elseif isa(c{i}, 'double') && c{i} ~= int64(c{i})
        el = sprintf('%.16e', c{i});
    else
        el = [char(string(c{i}))];
    end
    % Add to output
    output = [output, el, ', '];
end
output = ['[', output(1:end-1), ']'];
% Print out
fid = fopen(filename, 'w');
fprintf(fid, '%s\n', output);
fclose(fid);
end 
