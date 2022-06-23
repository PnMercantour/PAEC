-- construit un objet geojson qui décrit les unités pastorales
-- properties:
--      id (entier)
--      nom (chaîne UTF8)
--      surface (entier, unité m2)
--      cp (liste d'objets) liste des conventions de pâturage [{id, intersect}*] (ou [null])
--      https://stackoverflow.com/questions/33304983/how-to-create-an-empty-json-object-in-postgresql
-- geometry: multipolygone
-- bbox : la boîte englobante.
-- https://datatracker.ietf.org/doc/html/rfc7946
WITH up AS (
  SELECT
    id,
    nom,
    geom,
    round(st_area (geom)) surface
  FROM
    ag_pasto.c_unite_pastorale_unp
),
to_4326 AS (
  SELECT
    id,
    st_transform (geom, 4326) geom
  FROM
    up
),
ev AS (
  SELECT
    id,
    box2d (geom) envelope
  FROM
    to_4326
),
j_mesure AS (
  SELECT
    up.id id,
    json_build_object('id', mesure.id, 'intersect', round(st_area (st_intersection (mesure.geom, up.geom)))) recouvrement
  FROM
    up
    JOIN ag_pasto.c_mesure_gestion_pastorale_meg mesure ON (st_intersects (mesure.geom, up.geom))
),
j_cp AS (
  SELECT
    up.id id,
    json_build_object('id', cp.id, 'intersect', round(st_area (st_intersection (cp.geom, up.geom)))) cp
  FROM
    ag_pasto.c_convention_paturage_cpa cp
    JOIN up ON (st_intersects (cp.geom, up.geom))
),
j_mesure_agg AS (
  SELECT
    id,
    array_to_json(array_agg(recouvrement)) recouvrement_json
  FROM
    up
    LEFT JOIN j_mesure USING (id)
  GROUP BY
    id
),
j_cp_agg AS (
  SELECT
    id,
    array_to_json(array_agg(cp)) cp_json
  FROM
    up
    LEFT JOIN j_cp USING (id)
  GROUP BY
    id
),
features AS (
  SELECT
    json_build_object('type', 'Feature', 'properties', json_build_object('id', id, 'nom', nom, 'surface', surface, 'mesures', recouvrement_json, 'cp', cp_json), 'geometry', st_asgeojson (to_4326.geom, 6)::json, 'bbox', json_build_array(st_xmin (envelope), st_ymin (envelope), st_xmax (envelope), st_ymax (envelope))) feature
  FROM
    up
    JOIN to_4326 USING (id)
    JOIN ev USING (id)
    JOIN j_mesure_agg USING (id)
    JOIN j_cp_agg USING (id))
SELECT
  json_build_object('type', 'FeatureCollection', 'features', json_agg(feature))::text geojson
FROM
  features;

