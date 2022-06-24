select to_json(
        array_agg(
            json_build_object('id', id, 'label', valeur)
        )
    )
from ag_pasto.tr_mesure_gestion_pastorale_mpa;