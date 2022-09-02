CREATE OR REPLACE VIEW paec.eau_zh_up_fx AS
SELECT up.*,
    extra.id_site,
    extra.surface_zh,
    extra.surface_defens,
    extra.alteration_types
FROM paec.ag_pasto_up up
    join paec.eau_zh_site_up_extra extra using (id)
    LEFT JOIN paec.eau_zh_site_exclus exclus ON extra.id_site = exclus.id
WHERE exclus.id IS NULL;