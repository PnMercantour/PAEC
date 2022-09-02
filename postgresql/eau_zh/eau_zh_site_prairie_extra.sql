-- Jointure entre site zh (zh, defens ou altération) et prairie
-- Une ligne par (prairie, site) en relation
-- paec.eau_zh_site_prairie_extra source
CREATE MATERIALIZED VIEW paec.eau_zh_site_prairie_extra TABLESPACE pg_default AS WITH geo AS (
    SELECT c_prairie_pra.id,
        c_prairie_pra.geom
    FROM ag_pasto.c_prairie_pra
),
zh AS (
    SELECT geo.id,
        zh_1.id_site,
        round(
            sum(st_area(st_intersection(geo.geom, zh_1.geom)))
        ) AS surface
    FROM geo
        JOIN eau_zh.zh zh_1 ON st_intersects(geo.geom, zh_1.geom)
    GROUP BY geo.id,
        zh_1.id_site
),
defens AS (
    SELECT geo.id,
        defens_1.id_site,
        round(
            sum(
                st_area(st_intersection(geo.geom, defens_1.geom))
            )
        ) AS surface
    FROM geo
        JOIN eau_zh.defens defens_1 ON st_intersects(geo.geom, defens_1.geom)
    GROUP BY geo.id,
        defens_1.id_site
),
alteration AS (
    SELECT geo.id,
        alteration_1.id_site,
        array_agg(DISTINCT alteration_1.id_type) AS alteration_types
    FROM geo
        JOIN eau_zh.alteration alteration_1 ON st_intersects(geo.geom, alteration_1.geom)
    GROUP BY geo.id,
        alteration_1.id_site
)
SELECT gs.id,
    gs.id_site,
    zh.surface AS surface_zh,
    defens.surface AS surface_defens,
    alteration.alteration_types
FROM (
        SELECT geo.id,
            geo.geom,
            site.id AS id_site
        FROM geo,
            eau_zh.site
    ) gs
    LEFT JOIN zh USING (id, id_site)
    LEFT JOIN defens USING (id, id_site)
    LEFT JOIN alteration USING (id, id_site)
WHERE zh.id IS NOT NULL
    OR defens.id IS NOT NULL
    OR alteration.id IS NOT NULL WITH DATA;
-- View indexes:
CREATE INDEX eau_zh_site_prairie_extra_id_idx ON paec.eau_zh_site_prairie_extra USING btree (id);
CREATE INDEX eau_zh_site_prairie_extra_id_site_idx ON paec.eau_zh_site_prairie_extra USING btree (id_site);