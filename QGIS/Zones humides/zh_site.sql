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
    bilan.defens
from eau_zh.site
    join paec.eau_zh_site_extra extra using(id)
    join eau_zh.bilan on site.id = bilan.id_site;