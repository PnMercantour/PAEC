create view paec.flore_synthese as (
    with d as (
        select cache.type,
            cache.id,
            count(*) filter (
                where super_priorite
            ) super_priorite,
            count(*) filter (
                where priorite = 1
            ) priorite_1,
            count(*) filter (
                where priorite = 2
            ) priorite_2,
            count(*) filter (
                where priorite = 3
            ) priorite_3,
            count(*) variete
        from paec.flore_observation_cache cache
            join paec.enjeu_flore using(cd_ref)
        group by cache.type,
            cache.id
    ),
    s as (
        select d.*,
            case
                when (
                    super_priorite > 0
                    or priorite_1 > 1
                ) then 3
                when (priorite_1 > 0) then 2
                when priorite_2 + priorite_3 > 3 then 1
                else 0
            end score
        from d
    )
    select *
    from paec.ag_pasto_geo_cache
        join s using(type, id)
    where score > 0
);