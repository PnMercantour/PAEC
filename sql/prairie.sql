-- construit un objet geojson qui décrit les prairies
-- properties:
--      id (entier)
--      nom (chaîne UTF8)
-- geometry: multipolygone
-- bbox : la boîte englobante.
-- https://datatracker.ietf.org/doc/html/rfc7946
WITH to_4326 AS (
  SELECT id,
    st_transform (geom, 4326) geom
  FROM ag_pasto.c_prairie_pra
),
ev AS (
  SELECT id,
    box2d (geom) envelope
  FROM to_4326
),
j as(
  select prairie.id id,
    json_build_object(
      'id',
      mesure.id,
      'intersect',
      round(
        st_area (st_intersection (prairie.geom, mesure.geom))
      )
    ) mesure
  from ag_pasto.c_mesure_pres_fauche_mep mesure
    join ag_pasto.c_prairie_pra prairie on (st_intersects (prairie.geom, mesure.geom))
),
j1 as(
  select id,
    array_to_json(array_agg(mesure)) mesures
  from ag_pasto.c_prairie_pra prairie
    left join j using(id)
  group by id
),
features AS (
  SELECT json_build_object(
      'type',
      'Feature',
      'properties',
      json_build_object(
        'id',
        id,
        'surface',
        round(st_area(prairie.geom)),
        'exploitant',
        exploitant,
        'mesures',
        mesures
      ),
      'geometry',
      st_asgeojson (to_4326.geom, 6)::json,
      'bbox',
      json_build_array(
        st_xmin (envelope),
        st_ymin (envelope),
        st_xmax (envelope),
        st_ymax (envelope)
      )
    ) feature
  FROM ag_pasto.c_prairie_pra prairie
    JOIN to_4326 USING (id)
    JOIN ev USING (id)
    JOIN j1 using (id)
)
SELECT json_build_object(
    'type',
    'FeatureCollection',
    'features',
    json_agg(feature)
  )::text geojson
FROM features;