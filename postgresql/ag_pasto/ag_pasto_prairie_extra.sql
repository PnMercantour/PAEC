-- Localisation des prairies / limites réglementaires
CREATE MATERIALIZED VIEW paec.ag_pasto_prairie_extra TABLESPACE pg_default AS with geo as (
    select id,
        geom
    from ag_pasto.c_prairie_pra
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
    round(st_area(st_intersection(geo.geom, coeur.geom))) coeur,
    round(
        st_area(st_intersection(geo.geom, aire_adhesion.geom))
    ) aire_adhesion,
    round(
        st_area(
            st_intersection(geo.geom, aire_optimale_adhesion.geom)
        )
    ) aire_optimale_adhesion
from geo,
    coeur,
    aire_adhesion,
    aire_optimale_adhesion with data;
create index on paec.ag_pasto_prairie_extra(id);