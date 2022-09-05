with zh as(
    select up.id,
        array_agg(site.nom_site) sites_zh
    from paec.eau_zh_up_fx up
        join eau_zh.site on (up.id_site = site.id)
    group by up.id
),
lago as (
    select id,
        sum(surface_lago) surface_lago
    from paec.faune_lago_up_fx
    group by id
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
            from lago
        ) r
    group by id
)
select up.*,
    points.score,
    zh.sites_zh,
    lago.surface_lago
from paec.ag_pasto_up up
    join points using(id)
    left join zh using(id)
    left join lago using(id)