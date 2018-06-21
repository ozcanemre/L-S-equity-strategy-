
function H =ForCoint(X,Y)

series=[X Y];
[h, ~, ~, ~, reg1] = egcitest(series);
H=h;
end
