WITH liste AS (
  SELECT
    vue.id,
    min(proximite) proximite,
    count(*) variete,
    array_agg('[' || proximite || '] ' || nom_valide) taxons
  FROM
    paec.flore_prairie_vm vue
    JOIN taxonomie.taxref ON vue.cd_ref = cd_nom
  GROUP BY
    vue.id
)
SELECT
  prairie.id,
  prairie.geom,
  prairie_st.id_st,
  proximite,
  variete,
  taxons
FROM
  ag_pasto.c_prairie_pra prairie
  JOIN paec.prairie_st ON prairie.id = prairie_st.id_prairie
  JOIN liste USING (id);
