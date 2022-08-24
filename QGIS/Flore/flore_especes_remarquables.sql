SELECT ef.cd_ref,
  taxref.nom_valide,
  taxref.nom_vern,
  enjeu_espece,
  enjeu_habitat,
  super_priorite,
  priorite
FROM paec.enjeu_flore ef
  LEFT JOIN taxonomie.taxref ON ef.cd_ref = taxref.cd_nom;