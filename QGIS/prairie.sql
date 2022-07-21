SELECT
  id_st,
  prairie.*
FROM
  paec.prairie_st
  JOIN ag_pasto.c_prairie_pra prairie ON id_prairie = prairie.id;
