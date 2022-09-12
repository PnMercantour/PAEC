-- Localisation des mesures de gestion pastorale/ limites réglementaires
CREATE MATERIALIZED VIEW paec.ag_pasto_mesure_gestion_pastorale_cache TABLESPACE pg_default AS with geo as (
    SELECT mesure.id,
        COALESCE(mesure.geom, up.geom) AS geom
    FROM ag_pasto.c_mesure_gestion_pastorale_meg mesure
        JOIN paec.ag_pasto_maec maec ON mesure.maec = maec.id
        JOIN ag_pasto.c_unite_pastorale_unp up ON maec.unite_pastorale = up.id
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
    geo.geom,
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
create unique index on paec.ag_pasto_mesure_gestion_pastorale_cache(id);
create index on paec.ag_pasto_mesure_gestion_pastorale_cache using gist(geom);