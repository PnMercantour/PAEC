create view paec.gn_synthese as
select *
from gn_synthese.synthese_avec_partenaires s
where date_min >= '2000-01-01'
    and s.id_nomenclature_info_geo_type = ref_nomenclatures.get_id_nomenclature ('TYP_INF_GEO', '1')
    and s.id_nomenclature_observation_status = ref_nomenclatures.get_id_nomenclature('STATUT_OBS', 'Pr');
COMMENT ON VIEW paec.gn_synthese IS 'Observations geonature éligibles pour le projet PAEC';