-- paec.eau_zh_alteration_fx source
CREATE OR REPLACE VIEW paec.eau_zh_alteration_fx AS
SELECT alteration.id,
    alteration.geom,
    alteration.id_site,
    alteration.id_type,
    site.coeur,
    site.aire_adhesion,
    site.aire_optimale_adhesion
FROM eau_zh.alteration
    join paec.eau_zh_site_fx site on alteration.id_site = site.id;