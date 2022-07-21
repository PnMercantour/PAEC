SELECT
  prairie.id,
  prairie.geom,
  1 as id_st,
  vue.proximite,
  vue.cd_ref,
  taxref.nom_valide
FROM
  paec.prairie_04 prairie
  JOIN paec.flore_prairie_04_vm vue USING (id)
  JOIN taxonomie.taxref ON vue.cd_ref = cd_nom;
