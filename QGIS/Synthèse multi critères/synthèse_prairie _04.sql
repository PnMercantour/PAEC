with prairie as (
    select *
    from paec.ag_pasto_prairie_04
),
entomo as(
    select entomo_prairie.id,
        count(*) nb_obs
    from paec.prairie_04_entomo_vm entomo_prairie
        left join paec.faune_entomo_exclus fee using (cd_ref)
        join gn_synthese.synthese_avec_partenaires s USING (id_synthese)
    where fee.cd_ref is null
        and date_min >= '2000-01-01'
    group by entomo_prairie.id
),
points as (
    select id,
        sum(points) score
    from (
            select id,
                1 as points
            from entomo
        ) r
    group by id
)
select prairie.*,
    points.score,
    entomo.nb_obs nb_obs_entomo
from prairie
    join points using(id)
    left join entomo using(id)