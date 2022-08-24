-- table de synthèse par id et enjeu
with geo as (
    select prairie.id,
        prairie.id nom,
        prairie.geom,
        1 id_st
    from paec.prairie_04 prairie
),
geo_entomo as(
    select id,
        cd_ref,
        id_synthese
    from paec.prairie_04_entomo_vm
),
attributes AS (
    SELECT geo.id,
        e.enjeu,
        max(e.surpaturage) surpaturage,
        max(e.embroussaillement) embroussaillement,
        max(e.brulage) brulage,
        max(e.dyn_forest) dyn_forest,
        max(e.zoosanit) zoosanit,
        max(e.rechauffement) rechauffement
    FROM geo
        join geo_entomo using (id)
        join gn_synthese.synthese_avec_partenaires s USING (id_synthese)
        JOIN ag_pasto.tr_entomo_enjeu e USING (cd_ref)
    WHERE s.date_min >= '2000-01-01'
    GROUP BY geo.id,
        enjeu
)
select geo.nom,
    geo.geom,
    geo.id_st,
    attributes.*
from geo
    join attributes using (id);