with prairie as (
    select *
    from paec.ag_pasto_prairie
),
zh as(
    select zh_prairie.id,
        array_agg(site.nom_site) sites_zh
    from paec.eau_zh_prairie_fx zh_prairie
        join eau_zh.site on (zh_prairie.id_site = site.id)
    group by zh_prairie.id
),
entomo as(
    select entomo_prairie.id,
        count(*) nb_obs
    from ag_pasto.vm_entomo_prairie entomo_prairie
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
            from zh
            union all
            select id,
                1 as points
            from entomo
        ) r
    group by id
)
select prairie.*,
    points.score,
    zh.sites_zh,
    entomo.nb_obs nb_obs_entomo
from prairie
    join points using(id)
    left join zh using(id)
    left join entomo using(id)