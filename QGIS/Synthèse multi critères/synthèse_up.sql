with up as (
    select *
    from paec.ag_pasto_up
),
zh as(
    select zh_up.id,
        array_agg(site.nom_site) sites_zh
    from paec.eau_zh_up_fx zh_up
        join eau_zh.site on (zh_up.id_site = site.id)
    group by zh_up.id
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
    from up
        join (
            select *
            from from_bzh
            union all
            select *
            from from_gps
        ) sources using (id)
    group by up.id
),
tl as(
    with eon as (
        select id,
            'eon' as source
        from paec.tetras_lyre_up_vm
        where recouvrement > 0.1
    )
    select up.id,
        array_agg(source) sources
    from up
        join (
            select *
            from eon
        ) sources using(id)
    group by up.id
),
entomo as(
    select entomo_up.id,
        count(*) nb_obs
    from ag_pasto.vm_entomo_up entomo_up
        left join paec.faune_entomo_exclus fee using (cd_ref)
        join gn_synthese.synthese_avec_partenaires s USING (id_synthese)
    where fee.cd_ref is null
        and date_min >= '2000-01-01'
    group by entomo_up.id
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
            union all
            select id,
                1 as points
            from tl
            union all
            select id,
                1 as points
            from entomo
        ) r
    group by id
)
select up.*,
    points.score,
    zh.sites_zh,
    lago.surface_lago,
    bouquetin.sources hivernage_bouquetin,
    tl.sources repro_tetras_lyre,
    entomo.nb_obs nb_obs_entomo
from up
    join points using(id)
    left join zh using(id)
    left join lago using(id)
    left join bouquetin using(id)
    left join tl using(id)
    left join entomo using(id)