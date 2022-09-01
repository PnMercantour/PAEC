create materialized view paec.lago_up_vm as WITH geo AS (
    SELECT up.id,
        up.geom,
        up.surface
    FROM ag_pasto.c_unite_pastorale_unp up
),
lago AS (
    SELECT id,
        geom,
        priorite
    FROM paec.lago_zones
)
SELECT geo.id,
    round(
        st_area(st_union(st_intersection(geo.geom, lago.geom)))
    ) surface_lago,
    round(
        st_area(
            st_union(st_intersection(geo.geom, lago.geom))
        ) / geo.surface / 100
    ) / 100 recouvrement,
    priorite
FROM geo
    join lago on st_intersects(geo.geom, lago.geom)
group by geo.id,
    geo.surface,
    priorite with data;
create index on paec.lago_up_vm(id);
GRANT SELECT ON TABLE paec.lago_up_vm TO consult_agpasto;
GRANT SELECT ON TABLE paec.lago_up_vm TO pnm_consult;