-- vue de synthèse par territoire (prairie 04)
create view paec.faune_entomo_synthese_prairie_04 as with geo as (
    select *
    from paec.ag_pasto_prairie_04
),
geo_entomo as(
    select *
    from paec.faune_entomo_geo_prairie_04
),
attributes AS (
    SELECT geo.id,
        count (distinct cd_ref) filter (
            where e.enjeu = 'Majeur'
        ) majeur,
        count (distinct cd_ref) filter (
            where e.enjeu = 'Fort'
        ) fort,
        count (distinct cd_ref) filter (
            where e.enjeu = 'Assez fort'
        ) assez_fort,
        max(e.surpaturage) surpaturage,
        max(e.embroussaillement) embroussaillement,
        max(e.dyn_forest) dyn_forest,
        max(e.zoosanit) zoosanit,
        max(e.rechauffement) rechauffement
    FROM geo
        join geo_entomo using (id)
        join gn_synthese.synthese_avec_partenaires s USING (id_synthese)
        JOIN paec.faune_entomo_especes_sensibles e USING (cd_ref)
    WHERE s.date_min >= '2000-01-01'
        and geo_entomo.proximite < 100
    GROUP BY geo.id
)
select geo.*,
    attributes.majeur,
    attributes.fort,
    attributes.assez_fort,
    attributes.surpaturage,
    attributes.embroussaillement,
    attributes.dyn_forest,
    attributes.zoosanit,
    attributes.rechauffement
from geo
    join attributes using (id);