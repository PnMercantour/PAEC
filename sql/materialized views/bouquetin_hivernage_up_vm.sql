create materialized view paec.bouquetin_hivernage_up_vm as WITH geo AS (
    SELECT up.id,
        up.geom,
        up.surface
    FROM ag_pasto.c_unite_pastorale_unp up
),
bzh AS (
    SELECT b.id,
        b.geom
    FROM faune.c_bouquetin_zone_hivernage_bzh b
    where annee_donnee >= 2017
)
SELECT geo.id,
    round(
        st_area(st_union(st_intersection(geo.geom, bzh.geom)))
    ) surface_hivernage,
    round(
        st_area(st_union(st_intersection(geo.geom, bzh.geom))) / geo.surface / 100
    ) / 100 recouvrement
FROM geo
    join bzh on st_intersects(geo.geom, bzh.geom)
group by geo.id,
    geo.surface with data;
create index on paec.bouquetin_hivernage_up_vm(id);
GRANT SELECT ON TABLE paec.bouquetin_hivernage_up_vm TO consult_agpasto;
GRANT SELECT ON TABLE paec.bouquetin_hivernage_up_vm TO pnm_consult;