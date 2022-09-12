create materialized view paec.faune_tl_eon_model_up_cache as WITH geo AS (
    SELECT up.id,
        up.geom,
        up.surface
    FROM paec.ag_pasto_up up
),
tl AS (
    select geom
    from faune.avifaune_tl_model_eon
)
SELECT geo.id,
    round(
        st_area(st_union(st_intersection(geo.geom, tl.geom)))
    ) surface_tl,
    round(
        (
            st_area(st_union(st_intersection(geo.geom, tl.geom))) / geo.surface
        )::numeric,
        2
    ) recouvrement
FROM geo
    join tl on st_intersects(geo.geom, tl.geom)
group by geo.id,
    geo.surface with data;
create index on paec.faune_tl_eon_model_up_cache(id);