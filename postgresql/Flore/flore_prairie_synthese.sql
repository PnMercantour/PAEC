-- table de synthèse par id
create view paec.flore_prairie_synthese as with geo as (
    select *
    from paec.ag_pasto_prairie
),
geo_flore as(
    select id,
        cd_ref,
        proximite
    from paec.flore_prairie_vm
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
    extra.variete
from geo
    join extra using (id);