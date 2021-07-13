function elecNum = channel2num( elName,chanlocs )

elecNum = [];
for i = 1:length(elName)
    for j = 1 : size(chanlocs,2)
        if strcmp(elName(1,i) , chanlocs(1,j).labels)
            elecNum = [elecNum  j];
        end
    end
end

end

