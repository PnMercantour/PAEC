WITH 
gestion as(select mesure.id, coalesce(mesure.geom, up.geom) geom, type_mesure_gestion, maec, mesure.mesure, mesure.commentaire 
from ag_pasto.c_mesure_gestion_pastorale_meg mesure 
join ag_pasto.t_maec_gestion_pastorale_mgp maec on (maec = maec.id)
join ag_pasto.c_unite_pastorale_unp up on (unite_pastorale = up.id)),
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
      up.id,
      'intersect',
      round(
        st_area (st_intersection (gestion.geom, up.geom))
      )
    ) recouvrement
  from  gestion
    join ag_pasto.c_unite_pastorale_unp up on (st_intersects (gestion.geom, up.geom))
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
        'surface',
        round(st_area(gestion.geom)),
        'type_mesure', type_mesure_gestion,
        'maec', maec,
        'mesure', mesure,
        'commentaire', commentaire,
        'ups', recouvrement_json
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