-- table de synthèse par id
with geo as (
    select up.id,
        up.nom,
        up.geom,
        up_st.id_st
    from ag_pasto.c_unite_pastorale_unp up
        join paec.up_st on (up.id = up_st.id_up)
),
geo_flore as(
    select id,
        cd_ref,
        proximite
    from paec.flore_up_vm
),
attributes AS (
    SELECT geo.id,
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
    FROM geo
        join geo_flore using (id)
        join paec.enjeu_flore USING (cd_ref)
    GROUP BY geo.id
)
select geo.nom,
    geo.geom,
    geo.id_st,
    attributes.*
from geo
    join attributes using (id);