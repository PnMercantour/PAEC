WITH 
gestion as (select id, geom, commentaire, engagement_unitaire, debut_contractualisation debut, fin_contractualisation fin from ag_pasto.c_mesure_pres_fauche_mep),
to_4326 AS (
  SELECT id,
    st_transform (geom, 4326) geom
  FROM gestion
),
ev AS (
  SELECT id,
    box2d (geom) envelope
  FROM to_4326
),
j as(
  select gestion.id id,
    json_build_object(
      'id',
      prairie.id,
      'intersect',
      round(
        st_area (st_intersection (gestion.geom, prairie.geom))
      )
    ) recouvrement
  from gestion
    join ag_pasto.c_prairie_pra prairie on (st_intersects (gestion.geom, prairie.geom))
),
j1 as(
  select id,
    array_to_json(array_agg(recouvrement)) recouvrement_json
  from gestion
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
        'commentaire',
        commentaire,
        'surface',
        round(st_area(gestion.geom)),
        'engagement',
        engagement_unitaire,
        'debut', debut,
        'fin', fin,
        'prairies', recouvrement_json
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
  FROM gestion
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