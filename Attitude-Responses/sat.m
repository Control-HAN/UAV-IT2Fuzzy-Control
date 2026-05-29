function out = sat(u,limit)
% limit = 0.1;
if abs(u) <= limit
out = u;
else
out = limit*sign(u);
end