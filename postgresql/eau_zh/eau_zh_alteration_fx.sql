-- paec.eau_zh_alteration_fx source
CREATE OR REPLACE VIEW paec.eau_zh_alteration_fx AS
SELECT alteration.id,
    alteration.geom,
    alteration.id_site,
    alteration.id_type
FROM eau_zh.alteration
    LEFT JOIN paec.eau_zh_site_exclus exclus ON alteration.id_site = exclus.id
WHERE exclus.id IS NULL
ORDER BY alteration.id;