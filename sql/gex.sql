WITH features AS (
  SELECT
    json_build_object('type', 'Feature', 'properties',
      json_build_object('id', id, 'nom_complet', nom_complet, 'type', type_regroupement, 'nom', nom, 'adresse', adresse,
      'adresse', adresse)) feature
  FROM
    ag_pasto.t_groupe_exploitant_gex
)
SELECT
  json_build_object('type', 'FeatureCollection', 'features', json_agg(feature))::text geojson
FROM
  features;
