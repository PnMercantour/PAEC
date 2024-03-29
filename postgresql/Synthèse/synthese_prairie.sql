create or replace view paec.synthese_prairie as with geo as (
        select *
        from paec.ag_pasto_prairie
    ),
    geo_zh as(
        select *
        from paec.eau_zh_synthese_prairie
    ),
    geo_bouquetin as(
        select *
        from paec.faune_bouquetin_synthese_up
        limit 0
    ), geo_entomo as (
        select *
        from paec.faune_entomo_synthese_prairie
    ),
    geo_lago as (
        select *
        from paec.faune_lago_synthese_up
        limit 0
    ), geo_tl as (
        select *
        from paec.faune_tl_synthese_up
        limit 0
    ), geo_flore as (
        select *
        from paec.flore_synthese
        where type = 2
    ),
    cumul as (
        select id,
            sum(score) score
        from (
                select id,
                    score
                from geo_zh
                union all
                select id,
                    score
                from geo_lago
                union all
                select id,
                    score
                from geo_bouquetin
                union all
                select id,
                    score
                from geo_tl
                union all
                select id,
                    score
                from geo_entomo
                union all
                select id,
                    score
                from geo_flore
            ) r
        group by id
    )
select geo.*,
    n2000.id_n2000,
    n2000.surface_n2000,
    cumul.score,
    geo_zh.sites_zh,
    geo_lago.surface_lago,
    geo_bouquetin.sources hivernage_bouquetin,
    geo_tl.sources repro_tetras_lyre,
    geo_entomo.majeur enjeu_entomo_majeur,
    geo_entomo.fort enjeu_entomo_fort,
    geo_entomo.assez_fort enjeu_entomo_assez_fort,
    geo_flore.score score_flore
from geo
    join cumul using(id)
    left join (
        select *
        from paec.ag_pasto_natura2000_cache
        where type = 2
    ) n2000 using(id)
    left join geo_zh using(id)
    left join geo_lago using(id)
    left join geo_bouquetin using(id)
    left join geo_tl using(id)
    left join geo_entomo using(id)
    left join geo_flore using(id);