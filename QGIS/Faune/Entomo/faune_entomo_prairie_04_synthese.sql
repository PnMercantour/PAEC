with selection as (
    select entomo_prairie.id,
        count(*) nb_obs
    from paec.prairie_04_entomo_vm entomo_prairie
        left join paec.faune_entomo_exclus fee using (cd_ref)
        join gn_synthese.synthese_avec_partenaires s USING (id_synthese)
    where fee.cd_ref is null
        and date_min >= '2000-01-01'
    group by entomo_prairie.id
)
select prairie.*,
    nb_obs as obs_entomo
from paec.ag_pasto_prairie_04 prairie
    join selection using(id)