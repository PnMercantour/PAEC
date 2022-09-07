-- rattachement des observations entomo (taxons sensibles aux pratiques agropastorales) aux prairies
-- lorsque la proximité est < 200m.
CREATE MATERIALIZED VIEW paec.faune_entomo_geo_prairie TABLESPACE pg_default AS with geo as (
    select id,
        geom
    from ag_pasto.c_prairie_pra
)
SELECT geo.id,
    t.cd_ref,
    s.id_synthese,
    round(st_distance(geo.geom, s.geom)) proximite
FROM gn_synthese.synthese_avec_partenaires s
    JOIN ag_pasto.tr_entomo_taxref t USING (cd_nom)
    JOIN geo ON st_distance(geo.geom, s.geom) < 200 WITH DATA;
-- View indexes:
CREATE INDEX ON paec.faune_entomo_geo_prairie(cd_ref);
CREATE INDEX ON paec.faune_entomo_geo_prairie(id);
CREATE INDEX ON paec.faune_entomo_geo_prairie(id_synthese);