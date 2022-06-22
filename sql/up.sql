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
with ev as (
  select id,
    nom,
    round(st_area(geom)) surface,
    st_transform (geom, 4326) geom,
    box2d (st_transform (geom, 4326)) envelope
  from ag_pasto.c_unite_pastorale_unp
),
up as (
  select id,
    nom,
    surface,
    geom,
    st_xmin (envelope),
    st_xmax (envelope),
    st_ymin (envelope),
    st_ymax (envelope)
  from ev
),
j as (
  select up.id id,
    json_build_object(
      'id',
      cp.id,
      'intersect',
      round(st_area (st_intersection (cp.geom, up.geom)))
    ) cp
  from ag_pasto.c_convention_paturage_cpa cp
    join ag_pasto.c_unite_pastorale_unp up on (st_intersects (cp.geom, up.geom))
),
j1 as(
  select id,
    round(st_area(up.geom)) surface,
    array_to_json(array_agg(cp)) cp
  from ag_pasto.c_unite_pastorale_unp up
    left join j using(id)
  group by id
),
features as (
  select json_build_object(
      'type',
      'Feature',
      'properties',
      json_build_object(
        'id',
        id,
        'nom',
        nom,
        'surface',
        up.surface,
        'cp',
        cp
      ),
      'geometry',
      st_asgeojson (geom, 6)::json,
      'bbox',
      json_build_array(st_xmin, st_ymin, st_xmax, st_ymax)
    ) feature
  from up
    join j1 using (id)
)
select json_build_object(
    'type',
    'FeatureCollection',
    'features',
    json_agg(feature)
  )::text geojson
from features;