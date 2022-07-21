WITH liste AS (
  SELECT
    vue.id,
    min(proximite) proximite,
    count(*) variete,
    array_agg('[' || proximite || '] ' || nom_valide) taxons
  FROM
    paec.flore_up_vm vue
    JOIN taxonomie.taxref ON vue.cd_ref = cd_nom
  GROUP BY
    vue.id
)
SELECT
  up.id,
  up.geom,
  up_st.id_st,
  proximite,
  variete,
  taxons
FROM
  ag_pasto.c_unite_pastorale_unp up
  JOIN paec.up_st ON up.id = up_st.id_up
  JOIN liste USING (id);
