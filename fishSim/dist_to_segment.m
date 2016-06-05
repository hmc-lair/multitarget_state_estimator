function dist = dist_to_segment(px, py, x1, y1, x2, y2)
% px and py: Point
% x1 and y1: Segment Start, x2 and y2: Segment End

v = [x2 y2] - [x1 y1];
w = [px py] - [x1 y1];

c1 = dot(v, w);


dist = 0;

if c1 <= 0
    dist = distance(px, py, x1, y1);
end

else
    c2 = dot(v,v);
    if c2 <= c1
        dist = distance(px, py, x2, y2);
    end
    
    else
        b = c1/c2;
        pb = [x1 y1] + b * v;
        dist = distance(px, py, Pb(1), Pb(2));
end
end