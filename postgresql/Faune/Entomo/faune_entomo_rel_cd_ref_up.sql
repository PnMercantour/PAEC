create or replace view paec.faune_entomo_rel_cd_ref_up as
select relation.id,
    relation.cd_ref,
    count(*) nb_observations
from paec.faune_entomo_geo_up relation
    join paec.faune_entomo_especes_sensibles using(cd_ref)
    join ag_pasto.tr_entomo_taxref using(cd_ref)
    join paec.gn_synthese s using (cd_nom)
group by relation.id,
    relation.cd_ref;