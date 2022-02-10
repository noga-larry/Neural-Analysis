function y = randPermute(x)

inx = randperm(length(x))
y = x(inx)