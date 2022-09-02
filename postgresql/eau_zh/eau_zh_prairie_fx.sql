CREATE OR REPLACE VIEW paec.eau_zh_prairie_fx AS
SELECT prairie.*,
    extra.id_site,
    extra.surface_zh,
    extra.surface_defens,
    extra.alteration_types
FROM paec.ag_pasto_prairie prairie
    join paec.eau_zh_site_prairie_extra extra using (id)
    LEFT JOIN paec.eau_zh_site_exclus exclus ON extra.id_site = exclus.id
WHERE exclus.id IS NULL;