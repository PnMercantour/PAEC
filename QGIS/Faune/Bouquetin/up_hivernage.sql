select up.id,
    up.nom,
    up.geom,
    up_st.id_st,
    h.surface_hivernage,
    h.recouvrement
from ag_pasto.c_unite_pastorale_unp up
    join paec.bouquetin_hivernage_up_vm h using (id)
    join paec.up_st on (up.id = up_st.id_up);