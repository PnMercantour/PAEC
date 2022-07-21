SELECT
  up.id,
  up.geom,
  up_st.id_st,
  vue.proximite,
  vue.cd_ref,
  taxref.nom_valide
FROM
  ag_pasto.c_unite_pastorale_unp up
  JOIN paec.up_st ON up.id = up_st.id_up
  JOIN paec.flore_up_vm vue USING (id)
  JOIN taxonomie.taxref ON vue.cd_ref = cd_nom