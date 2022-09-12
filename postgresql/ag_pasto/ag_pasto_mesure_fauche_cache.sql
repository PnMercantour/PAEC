-- Localisation des mesures prés de fauche/ limites réglementaires
CREATE MATERIALIZED VIEW paec.ag_pasto_mesure_fauche_cache TABLESPACE pg_default AS with geo as (
    select id,
        geom
    from ag_pasto.c_mesure_pres_fauche_mep
    where debut_contractualisation >= '2015-01-01'
),
geo_st_full as(
    select geo.id,
        st.id id_st,
        round(st_area(st_intersection(geo.geom, st.geom))) surface_st
    from geo
        left join limregl.cr_pnm_services_territoriaux_topo st on st_intersects(geo.geom, st.geom)
),
geo_st as (
    select distinct on (id) id,
        id_st
    from geo_st_full
    order by id,
        surface_st desc
),
coeur AS (
    SELECT geom
    FROM limites.limites
    WHERE nom = 'coeur'
),
aire_adhesion AS (
    SELECT geom
    FROM limites.limites
    WHERE nom = 'aire_adhesion'
),
aire_optimale_adhesion AS (
    SELECT geom
    FROM limites.limites
    WHERE nom = 'aire_optimale_adhesion'
)
select geo.id,
    round(st_area(geo.geom)) surface,
    geo_st.id_st id_st,
    round(st_area(st_intersection(geo.geom, coeur.geom))) coeur,
    round(
        st_area(st_intersection(geo.geom, aire_adhesion.geom))
    ) aire_adhesion,
    round(
        st_area(
            st_intersection(geo.geom, aire_optimale_adhesion.geom)
        )
    ) aire_optimale_adhesion
from geo
    join geo_st using(id),
    coeur,
    aire_adhesion,
    aire_optimale_adhesion with data;
create unique index on paec.ag_pasto_mesure_fauche_cache(id);