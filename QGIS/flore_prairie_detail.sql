SELECT prairie.id,
  prairie.geom,
  prairie_st.id_st,
  vue.proximite,
  vue.cd_ref,
  taxref.nom_valide,
  enjeu_flore.enjeu_espece,
  enjeu_flore.enjeu_habitat
FROM ag_pasto.c_prairie_pra prairie
  JOIN paec.prairie_st ON prairie.id = prairie_st.id_prairie
  JOIN paec.flore_prairie_vm vue USING (id)
  JOIN taxonomie.taxref ON vue.cd_ref = cd_nom
  JOIN paec.enjeu_flore ON vue.cd_ref = enjeu_flore.cd_ref;