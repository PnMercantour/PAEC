with features as (SELECT json_build_object(
    'id_cp', cp.id,
    'intersection', round(st_area (st_intersection (cp.geom, up.geom))),
    'id_up', up.id) feature from ag_pasto.c_convention_paturage_cpa cp
    JOIN ag_pasto.c_unite_pastorale_unp up ON (st_intersects (cp.geom, up.geom)))
select json_agg(feature) from features;