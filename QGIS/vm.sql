DROP MATERIALIZED VIEW paec.mesure_gestion_pastorale_geom_vm CASCADE;
create materialized view paec.mesure_gestion_pastorale_geom_vm as(
    select mesure.id,
        coalesce(mesure.geom, up.geom) geom,
        round(st_area(coalesce(mesure.geom, up.geom))) surface
    from ag_pasto.c_mesure_gestion_pastorale_meg mesure
        join ag_pasto.t_maec_gestion_pastorale_mgp maec on (maec = maec.id)
        join ag_pasto.c_unite_pastorale_unp up on (unite_pastorale = up.id)
);
CREATE UNIQUE INDEX ON paec.mesure_gestion_pastorale_geom_vm USING btree (id);
CREATE INDEX ON paec.mesure_gestion_pastorale_geom_vm USING gist (geom);
create materialized view paec.up_maec_vm as(
    select mesure.id id_mesure,
        up.id id_up,
        round(
            st_area (st_intersection (mesure.geom, up.geom))
        ) intersection
    from paec.mesure_gestion_pastorale_geom_vm mesure
        join ag_pasto.c_unite_pastorale_unp up on (st_intersects (mesure.geom, up.geom))
);
CREATE INDEX ON paec.up_maec_vm USING btree (id_mesure);
CREATE INDEX ON paec.up_maec_vm USING btree (id_up);
GRANT SELECT ON TABLE paec.up_maec_vm TO cdm_agpasto;
GRANT SELECT ON TABLE paec.up_maec_vm TO consult_agpasto;
GRANT SELECT ON TABLE paec.mesure_gestion_pastorale_geom_vm TO cdm_agpasto;
GRANT SELECT ON TABLE paec.mesure_gestion_pastorale_geom_vm TO consult_agpasto;