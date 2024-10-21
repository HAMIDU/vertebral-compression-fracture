
function shift = shiftL(M)
  shift = [ M(:,2:size(M,2)) M(:,size(M,2)) ];


