CREATE MATERIALIZED VIEW paec.flore_prairie_04_vm TABLESPACE pg_default AS
WITH taxref AS (
  SELECT
    taxref.cd_nom,
    taxref.cd_ref
  FROM
    taxonomie.taxref
    JOIN paec.enjeu_flore USING (cd_ref)
),
observation AS (
  SELECT
    taxref.cd_ref,
    sap.geom
  FROM
    gn_synthese.synthese_avec_partenaires sap
    JOIN taxref USING (cd_nom)
  WHERE
    sap.id_nomenclature_observation_status = ref_nomenclatures.get_id_nomenclature
      ('STATUT_OBS'::character varying, 'Pr'::character varying)
    AND sap.id_nomenclature_info_geo_type = ref_nomenclatures.get_id_nomenclature
      ('TYP_INF_GEO'::character varying, '1'::character varying)
    AND sap.date_min >= '1990-01-01 00:00:00'::timestamp WITHOUT time zone
)
SELECT
  prairie.id,
  observation.cd_ref,
  round(min(st_distance (observation.geom, prairie.geom))) AS proximite
FROM
  paec.prairie_04 prairie
  JOIN observation ON st_distance (observation.geom, prairie.geom) < 200::double precision
GROUP BY
  prairie.id,
  observation.cd_ref WITH DATA;
