-- construit un objet geojson qui décrit les prairies
-- properties:
--      id (entier)
--      nom (chaîne UTF8)
-- geometry: multipolygone
-- bbox : la boîte englobante.
-- https://datatracker.ietf.org/doc/html/rfc7946
WITH to_4326 AS (
  SELECT
    id,
    st_transform (geom, 4326) geom
  FROM
    ag_pasto.c_prairie_pra
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
      json_build_object('id', id, 'exploitant', exploitant), 'geometry',
      st_asgeojson (to_4326.geom, 6)::json, 'bbox', json_build_array(st_xmin (envelope),
      st_ymin (envelope), st_xmax (envelope), st_ymax (envelope))) feature
  FROM
    ag_pasto.c_prairie_pra
    JOIN to_4326 USING (id)
    JOIN ev USING (id))
SELECT
  json_build_object('type', 'FeatureCollection', 'features', json_agg(feature))::text geojson
FROM
  features;
