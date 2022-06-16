WITH to_4326 AS (
  SELECT
    id,
    st_transform (geom, 4326) geom
  FROM
    ag_pasto.c_convention_paturage_cpa
),
ev AS (
  SELECT
    id,
    box2d (geom) envelope
  FROM
    to_4326
),
features AS (
  SELECT
    json_build_object('type', 'Feature', 'properties',
      json_build_object('id', id, 'exploitant', locataire, 'type_location', type_location, 'debut', debut_contractualisation, 'fin', fin_contractualisation), 'geometry',
      st_asgeojson (to_4326.geom, 6)::json, 'bbox', json_build_array(st_xmin (envelope),
      st_ymin (envelope), st_xmax (envelope), st_ymax (envelope))) feature
  FROM
    ag_pasto.c_convention_paturage_cpa
    JOIN to_4326 USING (id)
    JOIN ev USING (id))
SELECT
  json_build_object('type', 'FeatureCollection', 'features', json_agg(feature))::text geojson
FROM
  features;