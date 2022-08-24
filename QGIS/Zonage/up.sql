SELECT
  id_st,
  up.*
FROM
  paec.up_st
  JOIN ag_pasto.c_unite_pastorale_unp up ON id_up = up.id;
