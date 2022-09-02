create view paec.ag_pasto_up as
SELECT up.id,
    up.nom,
    up.geom,
    up.commune,
    up_st.id_st,
    extra.surface,
    extra.coeur,
    extra.aire_adhesion,
    extra.aire_optimale_adhesion
FROM ag_pasto.c_unite_pastorale_unp up
    join paec.ag_pasto_up_extra extra using(id)
    left join paec.up_st up_st ON up_st.id_up = up.id;