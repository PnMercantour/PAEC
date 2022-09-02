-- paec.eau_zh_defens_fx source
CREATE OR REPLACE VIEW paec.eau_zh_defens_fx AS
SELECT defens.id,
    defens.geom,
    defens."annee impl",
    defens.surface,
    defens.nom_defens,
    defens.id_site,
    defens.id_mgp
FROM eau_zh.defens
    LEFT JOIN paec.eau_zh_site_exclus exclus ON defens.id_site = exclus.id
WHERE exclus.id IS NULL
ORDER BY defens.id;