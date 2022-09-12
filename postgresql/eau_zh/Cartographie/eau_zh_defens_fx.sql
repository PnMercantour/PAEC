-- paec.eau_zh_defens_fx source
CREATE OR REPLACE VIEW paec.eau_zh_defens_fx AS
SELECT defens.id,
    defens.geom,
    defens."annee impl",
    defens.surface,
    defens.nom_defens,
    defens.id_site,
    defens.id_mgp,
    site.coeur,
    site.aire_adhesion,
    site.aire_optimale_adhesion
FROM eau_zh.defens
    join paec.eau_zh_site_fx site on defens.id_site = site.id;