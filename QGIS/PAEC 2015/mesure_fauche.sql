select mesure.id,
    mesure.prairie,
    st.id_st,
    round(st_area(mesure.geom)) surface,
    mesure.commentaire,
    engagement_unitaire.detail engagement_unitaire,
    debut_contractualisation,
    fin_contractualisation,
    montant_contrat,
    mesure.geom
from ag_pasto.c_mesure_pres_fauche_mep mesure
    join paec.mesure_fauche_st st on mesure.id = st.id_mesure
    join ag_pasto.tr_engagement_unitaire_eun engagement_unitaire on mesure.engagement_unitaire = engagement_unitaire.id;