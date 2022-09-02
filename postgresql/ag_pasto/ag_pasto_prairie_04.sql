create view paec.ag_pasto_prairie_04 as
SELECT prairie.id,
    prairie.id_exploit exploitant,
    prairie.foncier,
    prairie.mae,
    prairie.nb_coupe,
    date1,
    date2,
    date3,
    paturage_printemps,
    paturage_automne,
    fertilisation,
    mecanisation,
    irrigation,
    degradation,
    nom_exploitant,
    prairie.geom,
    1 as id_st,
    extra.surface,
    extra.coeur,
    extra.aire_adhesion,
    extra.aire_optimale_adhesion
FROM paec.prairie_04 prairie
    join paec.ag_pasto_prairie_04_extra extra using(id);