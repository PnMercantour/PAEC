-- Représentation des sites exclus (pour QGIS)
select *
from eau_zh.site
    join paec.eau_zh_site_exclus using(id);