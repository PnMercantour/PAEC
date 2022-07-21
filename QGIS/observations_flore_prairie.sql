WITH taxref AS (
  SELECT
    taxref.*
  FROM
    taxonomie.taxref
    JOIN paec.enjeu_flore USING (cd_ref)
),
observation AS (
  SELECT
    id_synthese,
    cd_nom,
    nom_cite,
    cd_ref,
    nom_valide,
    geom
  FROM
    gn_synthese.synthese_avec_partenaires sap
    JOIN taxref USING (cd_nom)
  WHERE
    id_nomenclature_observation_status = ref_nomenclatures.get_id_nomenclature ('STATUT_OBS', 'Pr')
    AND id_nomenclature_info_geo_type = ref_nomenclatures.get_id_nomenclature ('TYP_INF_GEO', '1')
    AND date_min >= '1990-01-01'
),
prairie AS (
  SELECT
    id_st,
    prairie.*
  FROM
    paec.prairie_st
    JOIN ag_pasto.c_prairie_pra prairie ON id_prairie = prairie.id
),
vue AS (
  SELECT DISTINCT
    prairie.id,
    nom_valide
  FROM
    prairie
    JOIN observation ON st_distance (observation.geom, prairie.geom) < 100
),
aggreg AS (
  SELECT
    id,
    count(*) nombre,
  array_agg(nom_valide) taxons
FROM
  vue
GROUP BY
  id
)
SELECT
  id,
  id_st,
  nombre,
  taxons,
  geom
FROM
  aggreg
  JOIN prairie USING (id);
