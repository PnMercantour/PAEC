select site.id,
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
    -- bilan.defens,
    extra.coeur,
    extra.aire_adhesion,
    extra.aire_optimale_adhesion
from eau_zh.site
    join paec.eau_zh_site_vm extra using(id)
    join eau_zh.bilan on site.id = bilan.id_site
    where site.id not in (select id from paec.eau_zh_site_exclus);