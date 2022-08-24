-- Extensions et filtrage de la table eau_zh.site pour les besoins du PAEC
-- ajout d'une colonne id_st
-- filtrage sur le sous-ensemble de site.id qui ont une notice
-- paec.eau_zh_site_extra source
CREATE MATERIALIZED VIEW paec.eau_zh_site_extra TABLESPACE pg_default AS with selection as (
    select distinct id_site id
    from eau_zh.notice
),
surface_zh as (
    select id_site id,
        sum(surface) surface
    from eau_zh.zh
    group by id_site
),
surface_defens as (
    select id_site id,
        sum(surface) surface
    from eau_zh.defens
    group by id_site
)
SELECT site.id,
    st.id AS id_st,
    surface_zh.surface as surface_zh,
    surface_defens.surface as surface_defens
FROM eau_zh.site
    JOIN selection using (id)
    left join surface_zh using(id)
    left join surface_defens using(id)
    JOIN limregl.cr_pnm_services_territoriaux_topo st ON st_within(site.geom, st.geom)
ORDER BY site.id WITH DATA;
-- View indexes:
CREATE INDEX eau_zh_site_extra_id_idx ON paec.eau_zh_site_extra USING btree (id);
-- Permissions
ALTER TABLE paec.eau_zh_site_extra OWNER TO postgres;
GRANT ALL ON TABLE paec.eau_zh_site_extra TO postgres;
GRANT SELECT ON TABLE paec.eau_zh_site_extra TO consult_agpasto;
GRANT SELECT ON TABLE paec.eau_zh_site_extra TO consult_flore;
GRANT SELECT ON TABLE paec.eau_zh_site_extra TO pnm_consult;