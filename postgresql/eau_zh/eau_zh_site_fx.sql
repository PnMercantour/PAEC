-- paec.eau_zh_site_fx source
CREATE OR REPLACE VIEW paec.eau_zh_site_fx AS
SELECT site.id,
    site.geom,
    site.nom_site,
    site.etat,
    extra.id_st,
    extra.surface_zh,
    extra.surface_defens,
    bilan.enjeux,
    bilan.menaces,
    bilan.annee,
    bilan.resume,
    bilan.restauration,
    extra.coeur,
    extra.aire_adhesion,
    extra.aire_optimale_adhesion
FROM eau_zh.site
    JOIN paec.eau_zh_site_extra extra USING (id)
    JOIN eau_zh.bilan ON site.id = bilan.id_site
    LEFT JOIN paec.eau_zh_site_exclus exclus ON site.id = exclus.id
WHERE exclus.id IS NULL;