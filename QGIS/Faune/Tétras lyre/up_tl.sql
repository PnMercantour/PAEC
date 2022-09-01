select up.id,
    up.nom,
    up.geom,
    up_st.id_st,
    tl.surface_tl,
    tl.recouvrement
from ag_pasto.c_unite_pastorale_unp up
    join paec.tetras_lyre_up_vm tl using (id)
    join paec.up_st on (up.id = up_st.id_up);