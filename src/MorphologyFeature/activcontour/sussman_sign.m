function S = sussman_sign(D)
  S = D ./ sqrt(D.^2 + 1);    