select m.id,
    m.geom,
    nb_obs
from limites.maille1k m
    join faune.bouquetin_maille1k_vm using (id);