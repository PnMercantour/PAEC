WITH r AS (
  SELECT
    ef.cd_ref,
    s.priorite
  FROM
    paec.enjeu_flore ef
    LEFT JOIN flore.taxref_12 ON (ef.cd_ref = taxref_12.cd_nom)
    LEFT JOIN flore.strategie_taxons s ON (taxref_12.cd_ref = s.cd_ref12))
UPDATE
  paec.enjeu_flore
SET
  priorite = r.priorite
FROM
  r
WHERE
  enjeu_flore.cd_ref = r.cd_ref;
