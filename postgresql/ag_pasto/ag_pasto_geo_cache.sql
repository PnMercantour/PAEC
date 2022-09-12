create materialized view paec.ag_pasto_geo_cache as with geo as (
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
geo_st_full as(
    select geo.type,
        geo.id,
        st.id id_st,
        round(st_area(st_intersection(geo.geom, st.geom))) surface_st
    from geo
        left join limregl.cr_pnm_services_territoriaux_topo st on st_intersects(geo.geom, st.geom)
),
geo_st as (
    select distinct on (type, id) type,
        id,
        id_st
    from geo_st_full
    order by type,
        id,
        surface_st desc
),
coeur AS (
    SELECT limites.geom
    FROM limites.limites
    WHERE limites.nom = 'coeur'::text
),
aire_adhesion AS (
    SELECT limites.geom
    FROM limites.limites
    WHERE limites.nom = 'aire_adhesion'::text
),
aire_optimale_adhesion AS (
    SELECT limites.geom
    FROM limites.limites
    WHERE limites.nom = 'aire_optimale_adhesion'::text
)
SELECT geo.type,
    geo.id,
    geo.geom,
    round(st_area(geo.geom)) AS surface,
    geo_st.id_st id_st,
    round(st_area(st_intersection(geo.geom, coeur.geom))) AS coeur,
    round(
        st_area(st_intersection(geo.geom, aire_adhesion.geom))
    ) AS aire_adhesion,
    round(
        st_area(
            st_intersection(geo.geom, aire_optimale_adhesion.geom)
        )
    ) AS aire_optimale_adhesion
FROM geo
    join geo_st using(type, id),
    coeur,
    aire_adhesion,
    aire_optimale_adhesion;
create index on paec.ag_pasto_geo_cache using gist(geom);
create unique index on paec.ag_pasto_geo_cache(type, id);