-- Extensions de la table eau_zh.site pour les besoins du PAEC
-- ajout d'une colonne id_st
-- paec.eau_zh_site_extra source
CREATE MATERIALIZED VIEW paec.eau_zh_site_vm TABLESPACE pg_default AS
with coeur AS (
  SELECT
    geom
  FROM
    limites.limites
  WHERE
    nom = 'coeur'
),
aire_adhesion AS (
  SELECT
    geom
  FROM
    limites.limites
  WHERE
    nom = 'aire_adhesion'
),
aire_optimale_adhesion AS (
  SELECT
    geom
  FROM
    limites.limites
  WHERE
    nom = 'aire_optimale_adhesion'
),
zh AS (
  SELECT
    zh.id_site id,
    sum(zh.surface) surface,
  coalesce(bool_or(st_intersects (zh.geom, coeur.geom)), FALSE) coeur,
coalesce(bool_or(st_intersects (zh.geom, aire_adhesion.geom)), FALSE) aire_adhesion,
coalesce(bool_or(st_intersects (zh.geom, aire_optimale_adhesion.geom))) aire_optimale_adhesion
FROM
  eau_zh.zh,
  coeur,
  aire_adhesion,
  aire_optimale_adhesion
GROUP BY
  id_site
),
defens AS (
  SELECT
    defens.id_site id,
    sum(defens.surface) surface,
    coalesce(bool_or(st_intersects (defens.geom, coeur.geom)), FALSE) coeur,
    coalesce(bool_or(st_intersects (defens.geom, aire_adhesion.geom)), FALSE) aire_adhesion,
    coalesce(bool_or(st_intersects (defens.geom, aire_optimale_adhesion.geom)), FALSE) aire_optimale_adhesion
  FROM
    eau_zh.defens defens,
    coeur,
    aire_adhesion,
    aire_optimale_adhesion
  GROUP BY
    defens.id_site
)
SELECT
  site.id,
  st.id AS id_st,
  zh.surface AS surface_zh,
  defens.surface AS surface_defens,
  coalesce(zh.coeur, FALSE)
  OR coalesce(defens.coeur, FALSE) AS coeur,
  coalesce(zh.aire_adhesion, FALSE)
  OR coalesce(defens.aire_adhesion, FALSE) AS aire_adhesion,
  coalesce(zh.aire_optimale_adhesion, FALSE)
  OR coalesce(defens.aire_optimale_adhesion, FALSE) AS aire_optimale_adhesion
FROM
  eau_zh.site
  LEFT JOIN zh USING (id)
  LEFT JOIN defens USING (id)
  JOIN limregl.cr_pnm_services_territoriaux_topo st ON st_within (site.geom, st.geom)
ORDER BY
  site.id WITH DATA;

-- View indexes:
CREATE INDEX ON paec.eau_zh_site_vm (id);

-- Permissions
ALTER TABLE paec.eau_zh_site_vm OWNER TO postgres;

GRANT ALL ON TABLE paec.eau_zh_site_vm TO postgres;

GRANT SELECT ON TABLE paec.eau_zh_site_vm TO consult_agpasto;

GRANT SELECT ON TABLE paec.eau_zh_site_vm TO consult_flore;

GRANT SELECT ON TABLE paec.eau_zh_site_vm TO pnm_consult;
