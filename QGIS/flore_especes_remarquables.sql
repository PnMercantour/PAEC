SELECT ef.cd_ref,
  taxref.nom_valide,
  enjeu_espece,
  enjeu_habitat
FROM paec.enjeu_flore ef
  LEFT JOIN taxonomie.taxref ON ef.cd_ref = taxref.cd_nom;