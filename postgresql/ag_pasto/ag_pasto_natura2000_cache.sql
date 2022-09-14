create materialized view paec.ag_pasto_natura2000_cache as with geo as (
    select id,
        1 as type,
        geom
    from paec.ag_pasto_up
    union all
    select id,
        2 as type,
        geom
    from paec.ag_pasto_prairie
    union all
    select id,
        3 as type,
        geom
    from paec.ag_pasto_prairie_04
),
n2000 as(
    select id,
        geom
    from paec.natura2000_sites
),
geo_n2000_full as(
    select geo.type,
        geo.id,
        n2000.id id_n2000,
        round(st_area(st_intersection(geo.geom, n2000.geom))) surface_n2000
    from geo
        join n2000 on st_intersects(geo.geom, n2000.geom)
)
select distinct on (type, id) type,
    id,
    id_n2000,
    surface_n2000
from geo_n2000_full
order by type,
    id,
    surface_n2000 desc;
create unique index on paec.ag_pasto_natura2000_cache(type, id);