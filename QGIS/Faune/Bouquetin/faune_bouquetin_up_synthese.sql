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
),
selection as (
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
)
select up.*,
    sources
from paec.ag_pasto_up up
    join selection using(id)