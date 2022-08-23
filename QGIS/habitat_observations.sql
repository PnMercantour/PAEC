WITH taxref AS (
  SELECT
    taxref.*
  FROM
    taxonomie.taxref
    JOIN paec.enjeu_flore USING (cd_ref) where enjeu_flore.enjeu_habitat)
SELECT
  id_synthese,
  cd_nom,
  nom_cite,
  cd_ref,
  nom_valide,
  date_min,
  geom
FROM
  gn_synthese.synthese_avec_partenaires sap
  JOIN taxref USING (cd_nom)
WHERE
  id_nomenclature_observation_status = ref_nomenclatures.get_id_nomenclature ('STATUT_OBS', 'Pr')
  AND id_nomenclature_info_geo_type = ref_nomenclatures.get_id_nomenclature ('TYP_INF_GEO', '1')
  AND date_min >= '1990-01-01';
