function xy = makeXYdata(rect, nVertexes)

% nVertexes : number of edges

rw = RectWidth(rect);
rh = RectHeight(rect);
radius = rw / 2;
theta = 2 * pi / nVertexes; 
xy = zeros(2, nVertexes * 2); 
for i = 0 : nVertexes - 1
    xy(1, 2 * i + 1) = radius * cos(theta * i); % ??X
    xy(2, 2 * i + 1) = radius * sin(theta * i); % ??Y
    xy(1, 2 * i + 2) = radius * cos(theta * (i + 1)); % ??X
    xy(2, 2 * i + 2) = radius * sin(theta * (i + 1)); % ??Y
end;
end

