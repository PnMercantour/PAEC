-- Extensions de la table eau_zh.site pour les besoins du PAEC
-- ajout des attributs id_st, surface_zh, surface_defens, coeur, aire_adhesion et aire_optimale_adhesion
-- paec.eau_zh_site_extra source
CREATE MATERIALIZED VIEW paec.eau_zh_site_extra TABLESPACE pg_default AS WITH coeur AS (
  SELECT limites.geom
  FROM limites.limites
  WHERE limites.nom = 'coeur'::text
),
aire_adhesion AS (
  SELECT limites.geom
  FROM limites.limites
  WHERE limites.nom = 'aire_adhesion'::text
),
aire_optimale_adhesion AS (
  SELECT limites.geom
  FROM limites.limites
  WHERE limites.nom = 'aire_optimale_adhesion'::text
),
zh AS (
  SELECT zh_1.id_site AS id,
    sum(zh_1.surface) AS surface,
    COALESCE(
      bool_or(st_intersects(zh_1.geom, coeur.geom)),
      false
    ) AS coeur,
    COALESCE(
      bool_or(st_intersects(zh_1.geom, aire_adhesion.geom)),
      false
    ) AS aire_adhesion,
    COALESCE(
      bool_or(
        st_intersects(zh_1.geom, aire_optimale_adhesion.geom)
      )
    ) AS aire_optimale_adhesion
  FROM eau_zh.zh zh_1,
    coeur,
    aire_adhesion,
    aire_optimale_adhesion
  GROUP BY zh_1.id_site
),
defens AS (
  SELECT defens_1.id_site AS id,
    sum(defens_1.surface) AS surface,
    COALESCE(
      bool_or(st_intersects(defens_1.geom, coeur.geom)),
      false
    ) AS coeur,
    COALESCE(
      bool_or(st_intersects(defens_1.geom, aire_adhesion.geom)),
      false
    ) AS aire_adhesion,
    COALESCE(
      bool_or(
        st_intersects(defens_1.geom, aire_optimale_adhesion.geom)
      ),
      false
    ) AS aire_optimale_adhesion
  FROM eau_zh.defens defens_1,
    coeur,
    aire_adhesion,
    aire_optimale_adhesion
  GROUP BY defens_1.id_site
)
SELECT site.id,
  st.id AS id_st,
  zh.surface AS surface_zh,
  defens.surface AS surface_defens,
  COALESCE(zh.coeur, false)
  OR COALESCE(defens.coeur, false) AS coeur,
  COALESCE(zh.aire_adhesion, false)
  OR COALESCE(defens.aire_adhesion, false) AS aire_adhesion,
  COALESCE(zh.aire_optimale_adhesion, false)
  OR COALESCE(defens.aire_optimale_adhesion, false) AS aire_optimale_adhesion
FROM eau_zh.site
  LEFT JOIN zh USING (id)
  LEFT JOIN defens USING (id)
  JOIN limregl.cr_pnm_services_territoriaux_topo st ON st_within(site.geom, st.geom)
ORDER BY site.id WITH DATA;
-- View indexes:
CREATE unique INDEX ON paec.eau_zh_site_extra(id);