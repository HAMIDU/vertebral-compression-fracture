function shift = shiftR(M)
  shift = [ M(:,1) M(:,1:size(M,2)-1) ];
