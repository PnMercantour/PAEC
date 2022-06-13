-- construit un objet geojson qui décrit les unités pastorales
-- properties:
--      id (entier)
--      nom (chaîne UTF8)
-- geometry: multipolygone
-- bbox : la boîte englobante.
-- https://datatracker.ietf.org/doc/html/rfc7946
WITH ev AS (
  SELECT
    id,
    nom,
    st_transform (geom, 4326) geom,
    box2d (st_transform (geom, 4326)) envelope
  FROM
    ag_pasto.c_unite_pastorale_unp
),
up AS (
  SELECT
    id,
    nom,
    geom,
    st_xmin (envelope),
    st_xmax (envelope),
    st_ymin (envelope),
    st_ymax (envelope)
  FROM
    ev
),
features AS (
  SELECT
    json_build_object('type', 'Feature', 'properties',
      json_build_object('id', id, 'nom', nom), 'geometry', st_asgeojson
      (geom, 6)::json, 'bbox', json_build_array(st_xmin, st_ymin, st_xmax, st_ymax))
      feature
  FROM
    up
)
SELECT
  json_build_object('type', 'FeatureCollection', 'features', json_agg(feature))::text geojson
FROM
  features;
