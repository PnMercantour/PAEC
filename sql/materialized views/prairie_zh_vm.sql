-- paec.prairie_zh_vm source
CREATE MATERIALIZED VIEW paec.prairie_zh_vm TABLESPACE pg_default AS with geo as (
    select id,
        geom
    from ag_pasto.c_prairie_pra
),
zh as (
    select geo.id,
        array_agg(distinct zh.id_site) sites,
        round(sum(st_area(st_intersection(geo.geom, zh.geom)))) surface
    from geo
        join eau_zh.zh on st_intersects(geo.geom, zh.geom)
    group by geo.id
),
defens as (
    select geo.id,
        round(
            sum(st_area(st_intersection(geo.geom, defens.geom)))
        ) surface
    from geo
        join eau_zh.defens on st_intersects(geo.geom, defens.geom)
    group by geo.id
),
alteration as (
    select geo.id,
        array_agg(distinct alteration.id_type) alteration_types
    from geo
        join eau_zh.alteration on st_intersects(geo.geom, alteration.geom)
    group by geo.id
)
select geo.id,
    zh.sites,
    zh.surface surface_zh,
    defens.surface surface_defens,
    alteration_types
from geo
    left join zh using(id)
    left join defens using(id)
    left join alteration using (id) WITH DATA;
-- View indexes:
CREATE INDEX ON paec.prairie_zh_vm USING btree (id);
-- Permissions
ALTER TABLE paec.prairie_zh_vm OWNER TO postgres;
GRANT ALL ON TABLE paec.prairie_zh_vm TO postgres;
grant select on table paec.prairie_zh_vm to consult_agpasto,
    consult_flore,
    pnm_consult;