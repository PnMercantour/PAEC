select to_json(
        array_agg(
            json_build_object('id', id, 'code', valeur, 'label', detail)
        )
    )
from ag_pasto.tr_engagement_unitaire_eun;