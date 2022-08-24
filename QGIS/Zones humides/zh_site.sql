select site.id,
    site.geom,
    site.nom_site,
    site.etat,
    bilan.enjeux,
    bilan.menaces,
    bilan.annee,
    bilan.resume,
    bilan.restauration,
    bilan.defens
from eau_zh.site
    join eau_zh.bilan on site.id = bilan.id_site;