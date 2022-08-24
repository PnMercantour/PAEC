SELECT up.id,
  up.nom,
  up.geom,
  up_st.id_st,
  vue.proximite,
  vue.cd_ref,
  taxref.nom_valide,
  enjeu_flore.priorite
FROM ag_pasto.c_unite_pastorale_unp up
  JOIN paec.up_st ON up.id = up_st.id_up
  JOIN paec.flore_up_vm vue USING (id)
  JOIN taxonomie.taxref ON vue.cd_ref = cd_nom
  JOIN paec.enjeu_flore ON vue.cd_ref = enjeu_flore.cd_ref
WHERE enjeu_flore.enjeu_espece;