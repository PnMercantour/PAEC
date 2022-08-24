CREATE MATERIALIZED VIEW paec.prairie_04_entomo_vm TABLESPACE pg_default AS
SELECT p.id,
    t.cd_ref,
    s.id_synthese
FROM gn_synthese.synthese_avec_partenaires s
    JOIN ag_pasto.tr_entomo_taxref t USING (cd_nom)
    JOIN paec.prairie_04 p ON st_contains(p.geom, s.geom) WITH DATA;
-- Permissions
ALTER TABLE paec.prairie_04_entomo_vm OWNER TO "admin";
GRANT ALL ON TABLE paec.prairie_04_entomo_vm TO "admin";
GRANT SELECT ON TABLE paec.prairie_04_entomo_vm TO consult_agpasto,
    consult_flore,
    pnm_consult;