-- paec.eau_zh_zh_fx source
CREATE OR REPLACE VIEW paec.eau_zh_zh_fx AS
SELECT zh.id,
    zh.geom,
    zh.annee_inventaire,
    zh.etat_zh,
    zh.surface,
    zh.source,
    zh.id_site,
    site.coeur,
    site.aire_adhesion,
    site.aire_optimale_adhesion
FROM eau_zh.zh
    join paec.eau_zh_site_fx site on zh.id_site = site.id;