create view paec.ag_pasto_prairie as
SELECT prairie.id,
    prairie.exploitant,
    prairie.irrigation,
    prairie.nom,
    prairie.nombre_fauche,
    prairie.deprimage,
    prairie.paturage,
    prairie.mecanisable,
    date_fauche_1,
    date_fauche_2,
    date_fauche_3,
    prairie.geom,
    prairie_st.id_st,
    extra.surface,
    extra.coeur,
    extra.aire_adhesion,
    extra.aire_optimale_adhesion
FROM ag_pasto.c_prairie_pra prairie
    join paec.ag_pasto_prairie_extra extra using(id)
    left join paec.prairie_st prairie_st ON prairie_st.id_prairie = prairie.id;