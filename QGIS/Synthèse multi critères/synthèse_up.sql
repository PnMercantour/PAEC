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
bouquetin as (
    with from_bzh as (
        select id,
            'bzh' as source
        from paec.bouquetin_hivernage_up_vm bhuv
        where surface_hivernage > 50000
    ),
    from_gps as (
        select id,
            'gps' as source
        from paec.bouquetin_gps_up_vm
        where nb_obs > 100
    )
    select up.id,
        array_agg(source) sources
    from paec.ag_pasto_up up
        join (
            select *
            from from_bzh
            union all
            select *
            from from_gps
        ) sources using (id)
    group by up.id
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
            union all
            select id,
                1 as points
            from bouquetin
        ) r
    group by id
)
select up.*,
    points.score,
    zh.sites_zh,
    lago.surface_lago,
    bouquetin.sources hivernage_bouquetin
from paec.ag_pasto_up up
    join points using(id)
    left join zh using(id)
    left join lago using(id)
    left join bouquetin using(id)