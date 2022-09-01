create materialized view paec.tetras_lyre_up_vm as WITH geo AS (
    SELECT up.id,
        up.geom,
        up.surface
    FROM ag_pasto.c_unite_pastorale_unp up
),
tl AS (
    select fid_eon_se id,
        geom
    from faune.avifaune_tl_model_eon
)
SELECT geo.id,
    round(
        st_area(st_union(st_intersection(geo.geom, tl.geom)))
    ) surface_tl,
    round(
        st_area(st_union(st_intersection(geo.geom, tl.geom))) / geo.surface / 100
    ) / 100 recouvrement
FROM geo
    join tl on st_intersects(geo.geom, tl.geom)
group by geo.id,
    geo.surface with data;
create index on paec.tetras_lyre_up_vm(id);
GRANT SELECT ON TABLE paec.tetras_lyre_up_vm TO consult_agpasto;
GRANT SELECT ON TABLE paec.tetras_lyre_up_vm TO pnm_consult;