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
flore as(
    select id,
        case
            when (
                super_priorite > 0
                or priorite_1 > 1
            ) then 3
            when (priorite_1 > 0) then 2
            when priorite_2 + priorite_3 > 3 then 1
            else 0
        end points
    from paec.flore_prairie_04_synthese
    where super_priorite > 0
        or priorite_1 > 0
        or priorite_2 + priorite_3 > 3
),
points as (
    select id,
        sum(points) score
    from (
            select id,
                2 as points
            from entomo
            union all
            select id,
                points
            from flore
        ) r
    group by id
)
select prairie.*,
    points.score,
    entomo.nb_obs nb_obs_entomo,
    flore.points points_flore
from prairie
    join points using(id)
    left join entomo using(id)
    left join flore using(id)