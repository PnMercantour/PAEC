WITH liste AS (
  SELECT
    vue.id,
    min(proximite) proximite,
    count(*) variete,
    array_agg('[' || proximite || '] ' || nom_valide) taxons
  FROM
    paec.flore_prairie_04_vm vue
    JOIN taxonomie.taxref ON vue.cd_ref = cd_nom
  GROUP BY
    vue.id
)
SELECT
  prairie.id,
  prairie.geom,
  1 AS id_st,
  proximite,
  variete,
  taxons
FROM
  paec.prairie_04 prairie
  JOIN liste USING (id);
