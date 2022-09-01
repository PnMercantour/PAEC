select up.id,
    up.geom,
    up.nom,
    up_st.id_st,
    nb_obs
from ag_pasto.c_unite_pastorale_unp up
    join paec.bouquetin_gps_up_vm using (id)
    left join paec.up_st on(up.id = id_up);