select s.*
from gn_synthese.synthese_avec_partenaires s
    join taxonomie.taxref using(cd_nom)
where cd_ref = 2962
    and date_min >= '2000-01-01'
    and id_nomenclature_info_geo_type = ref_nomenclatures.get_id_nomenclature('TYP_INF_GEO', '1');