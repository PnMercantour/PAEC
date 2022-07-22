with ups as (
    select id_mesure id,
        array_agg(id_up) ups
    from paec.up_maec_vm
    where intersection > 100
    group by id_mesure
)
select mesure.id,
    mesure.maec,
    st.id_st,
    ups.ups,
    type_mesure_gestion.valeur type_mesure_gestion,
    extra.surface,
    mesure.mesure,
    mesure.commentaire,
    extra.geom geom
from ag_pasto.c_mesure_gestion_pastorale_meg mesure
    join paec.mesure_gestion_st st on mesure.id = st.id_mesure
    join paec.mesure_gestion_pastorale_geom_vm extra using (id)
    join ups using(id)
    join ag_pasto.tr_mesure_gestion_pastorale_mpa type_mesure_gestion on (
        mesure.type_mesure_gestion = type_mesure_gestion.id
    );