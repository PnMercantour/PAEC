-- sous-ensemble de site.id qui ont une notice
-- paec.vm_zh_sites source
CREATE MATERIALIZED VIEW paec.vm_zh_sites TABLESPACE pg_default AS
SELECT DISTINCT site.id
FROM eau_zh.site
    JOIN eau_zh.notice ON site.id = notice.id_site
ORDER BY site.id WITH DATA;
-- View indexes:
CREATE INDEX vm_zh_sites_id_idx ON paec.vm_zh_sites USING btree (id);
-- Permissions
ALTER TABLE paec.vm_zh_sites OWNER TO postgres;
GRANT ALL ON TABLE paec.vm_zh_sites TO postgres;
GRANT SELECT ON TABLE paec.vm_zh_sites TO consult_agpasto;
GRANT SELECT ON TABLE paec.vm_zh_sites TO consult_flore;
GRANT SELECT ON TABLE paec.vm_zh_sites TO pnm_consult;