-- table de synthèse par id
create or replace view paec.flore_synthese_prairie_04 as with geo as (
        select *
        from paec.ag_pasto_prairie_04
    ),
    geo_flore as(
        select id,
            cd_ref,
            proximite
        from paec.flore_prairie_04_vm
    ),
    extra AS (
        SELECT geo_flore.id,
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
        FROM geo_flore
            join paec.enjeu_flore USING (cd_ref)
        GROUP BY geo_flore.id
    )
select geo.*,
    extra.super_priorite,
    extra.priorite_1,
    extra.priorite_2,
    extra.priorite_3,
    extra.variete,
    case
        when (
            super_priorite > 0
            or priorite_1 > 1
        ) then 3
        when (priorite_1 > 0) then 2
        when priorite_2 + priorite_3 > 3 then 1
        else 0
    end score
from geo
    join extra using (id)
where super_priorite > 0
    or priorite_1 > 0
    or priorite_2 + priorite_3 > 3;